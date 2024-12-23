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
  "tabby",
];

const customerFirstName = "John";
const customerLastName = "Smith";
const customerEmail = "john1@some.mail";
const billingCountry = "KW";
const billingCity = "Kuwait City";

//    const customerPhone = "966557877988"
const _customerPhone = "99459272";
const nativePayMethodKey = 'native_pay';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final GoRouter _navigator;
  final _logger = Logger();
  final _dio = Dio();
  CheckoutTheme? _theme;
  String? _apiTransactionDetails;

  HomeScreenCubit({required GoRouter navigator})
      : _navigator = navigator,
        super(HomeScreenState(
            amount: "10",
            merchantId: merchantId,
            apiKey: apiKey,
            currencyCode: currencyCode,
            phoneNumber: _customerPhone,
            customerId: customerId,
            formsOfPaymentChecked: Map.from({
              nativePayMethodKey: true,
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
        pgCodes: pgCodesNative(),
        type: transactionType,
        customerId: state.customerId?.isNotEmpty == true ? state.customerId : null,
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
      _apiTransactionDetails = sessionResponse.transactionDetails;
      emit(state.copyWith(sessionId: sessionResponse.sessionId, hasSessionLoaded: true));
    }
  }

  void onFormsOfPaymentChecked(String key, bool isChecked) {
    final payments = state.formsOfPaymentChecked ?? Map.from({});
    payments[key] = isChecked;
    emit(state.copyWith(
        formsOfPaymentChecked: Map.from(payments), noForms: isChecked ? false : null));
  }

  void onShowPaymentDetailsChecked(bool isChecked) async {
    emit(state.copyWith(showPaymentDetails: isChecked));
  }

  void onNewCardChecked(bool? isChecked) async {
    emit(state.copyWith(newCard: isChecked));
  }

  void onNoFormsChecked(bool? isChecked) async {
    emit(state.copyWith(
        noForms: isChecked, formsOfPaymentChecked: isChecked == true ? Map.from({}) : null));
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
    final formOfPayments = state.formsOfPaymentChecked?.entries
        .where((entry) => entry.value)
        .map((entry) => _nativePaymentKey(entry.key))
        .toList();
    final args = CheckoutArguments(
        merchantId: state.merchantId,
        apiKey: state.apiKey,
        sessionId: state.sessionId ?? "",
        amount: amount,
        showPaymentDetails: state.showPaymentDetails,
        apiTransactionDetails: state.preloadPayload == true ? _apiTransactionDetails : null,
        formsOfPayment: formOfPayments?.isNotEmpty == true ? formOfPayments : null,
        theme: _theme);
    _navigator.push("/checkout", extra: args);
  }

  void onThemeCustomization() async {
    _logger.d("onThemeCustomization");
    final theme = await _navigator.push<CheckoutTheme?>("/theme_customization", extra: _theme);
    if (theme != null) {
      _theme = theme;
    }
  }

  String _nativePaymentKey(String key) {
    if (key == nativePayMethodKey) {
      return _nativePayMethodKey();
    } else {
      return key;
    }
  }

  String _nativePayMethodKey() {
    if (Platform.isAndroid) {
      return 'google_pay';
    } else if (Platform.isIOS) {
      return 'apple_pay';
    } else {
      return 'native_pay';
    }
  }

  List<String> pgCodesNative() {
    final codes = List.of(pgCodes);
    if (Platform.isIOS) {
      codes.add("apple-pay-nbk");
    }

    return codes;
  }
}
