import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/api/billing_address.dart';
import 'package:ottu_flutter_checkout_sample/api/create_transaction_request.dart';
import 'package:ottu_flutter_checkout_sample/api/session_response.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_state.dart';

const merchantId = "alpha.ottu.net";
const apiKey = "cHSLW0bE.56PLGcUYEhRvzhHVVO9CbF68hmDiXcPI";
const customerId = "john2";
const currencyCode = "KWD";
const transactionType = "e_commerce";

const pgCodes = [
  "mpgs-testing",
  "ottu_pg_kwd_tkn",
  "knet-staging",
  "benefit",
  "benefitpay",
  "stc_pay",
  "nbk-mpgs",
  "gbk-cc",
  "tamara",
  "tabby"
];

const customerFirstName = "John";
const customerLastName = "Smith";
const customerEmail = "john1@some.mail";
const billingCountry = "KW";
const billingCity = "Kuwait City";

//    const customerPhone = "966557877988"
const customerPhone = "99459272";

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final GoRouter _navigator;
  final _logger = Logger();
  final _dio = Dio();
  CheckoutTheme? _theme;

  HomeScreenCubit({required GoRouter navigator})
      : _navigator = navigator,
        super(HomeScreenState(
            merchantId: merchantId,
            apiKey: apiKey,
            currencyCode: currencyCode,
            phoneNumber: customerPhone,
            customerId: customerId,
            formsOfPaymentChecked: Map.from({
              "google_pay": true,
              "redirect": true,
              "flex_methods": true,
              "stc_pay": true,
              "ottu_pg": true,
              "token_pay": true
            })));

  void getSessionId({required String merchantId, required String apiKey}) async {
    _logger.d("getSessionId");
    emit(state.copyWith(hasSessionLoaded: false));
    final language = Platform.localeName.split("_")[0];
    final request = CreateTransactionRequest(
        amount: state.amount != null ? (double.tryParse(state.amount!).toString() ?? "0.0") : "0.0",
        currencyCode: state.currencyCode ?? "",
        pgCodes: pgCodes,
        type: transactionType,
        customerId: state.customerId,
        customerPhone: state.phoneNumber,
        includeSdkSetupPreload: state.preloadPayload ?? false,
        language: language,
        customerFirstName: customerFirstName,
        customerLastName: customerLastName,
        customerEmail: customerEmail,
        billingAddress:
            BillingAddress(country: billingCountry, city: billingCity, line1: "something"));

    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

    final response = await _dio.post(
      'https://$merchantId/b/checkout/v1/pymt-txn',
      data: request.toJson(),
      options: Options(
        headers: {
          Headers.contentTypeHeader: Headers.jsonContentType,
          "Authorization": "Api-Key $apiKey",
          "Accept-Language": language,
        },
      ),
    );

    if (response.data != null) {
      final sessionResponse = SessionResponse.fromJson(response.data);
      emit(state.copyWith(sessionId: sessionResponse.sessionId, hasSessionLoaded: true));
    }
  }

  void onFormsOfPaymentChecked(String key, bool isChecked) {
    final payments = state.formsOfPaymentChecked ?? Map.from({});
    payments[key] = isChecked;
    emit(state.copyWith(formsOfPaymentChecked: Map.from(payments)));
  }

  void onShowPaymentDetailsChecked(bool isChecked) async {
    emit(state.copyWith(showPaymentDetails: isChecked));
  }

  void onNewCardChecked(bool? isChecked) async {
    emit(state.copyWith(newCard: isChecked));
  }

  void onNoFormsChecked(bool? isChecked) async {
    emit(state.copyWith(noForms: isChecked));
  }

  void onPreloadPayloadChecked(bool? isChecked) async {
    emit(state.copyWith(preloadPayload: isChecked));
  }

  void onAmountChanged(String amount) async {
    emit(state.copyWith(amount: amount));
  }

  void onCurrencyCodeChanged(String code) async {
    emit(state.copyWith(currencyCode: code));
  }

  void onPhoneNumberChanged(String number) async {
    emit(state.copyWith(phoneNumber: number));
  }

  void onCustomerIdChanged(String customerId) async {
    emit(state.copyWith(customerId: customerId));
  }

  void onMerchantIdChanged(String merchantId) {
    emit(state.copyWith(merchantId: merchantId));
  }

  void onPay() async {
    _logger.d("onPay");
    final amount = state.amount != null ? double.tryParse(state.amount!) ?? 0.1 : 0.1;
    final args = CheckoutArguments(
        merchantId: state.merchantId,
        apiKey: state.apiKey,
        sessionId: state.sessionId ?? "",
        amount: amount,
        showPaymentDetails: state.showPaymentDetails,
        formsOfPayment: state.formsOfPaymentChecked?.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList() ??
            [], theme: _theme);
    _navigator.push("/checkout", extra: args);
  }

  void onThemeCustomization() async {
    _logger.d("onThemeCustomization");
    final theme = await _navigator.push<CheckoutTheme?>("/theme_customization", extra: _theme);
    if (theme != null) {
      _theme = theme;
    }
  }
}
