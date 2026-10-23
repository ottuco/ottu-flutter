import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/api/model/pg_codes.dart';

const _defaultPaymentsListItemCount = 5;
const _unset = Object();
const _formsOfPaymentEquality = MapEquality<FormsOfPayment, bool>();
const _pgCodeEquality = MapEquality<PGCode, bool>();

final class HomeScreenState extends Equatable {
  final String merchantId;
  final String apiKey;
  final String? sessionId;
  final String? amount;
  final String? currencyCode;
  final String? phoneNumber;
  final String? email;
  final String? customerId;
  final String? cardExpiryTime;
  final String paymentsListItemCount;
  final String? defaultSelectedPayment;
  final String? language;
  final bool showPaymentDetails;
  final bool? noForms;
  final bool? preloadPayload;
  final bool? isAutoDebit;
  final bool hasSessionLoaded;
  final bool isSessionLoading;
  final bool? failPaymentValidation;
  final bool useCustomText;
  final bool showMerchantWidget;
  final PaymentOptionsDisplayMode? paymentOptionsDisplayMode;
  final Map<FormsOfPayment, bool>? formsOfPaymentChecked;
  final Map<PGCode, bool>? pgCodesChecked;
  final String? apiTransactionDetails;
  final String? sessionErrorMessage;

  HomeScreenState({
    required this.merchantId,
    required this.apiKey,
    this.sessionId,
    this.amount,
    this.currencyCode,
    this.phoneNumber,
    this.email,
    this.customerId,
    this.cardExpiryTime,
    this.paymentsListItemCount = "$_defaultPaymentsListItemCount",
    this.defaultSelectedPayment,
    this.language,
    this.showPaymentDetails = true,
    this.preloadPayload = true,
    this.isAutoDebit = false,
    this.noForms,
    this.hasSessionLoaded = false,
    this.isSessionLoading = false,
    this.failPaymentValidation = false,
    this.paymentOptionsDisplayMode,
    Map<FormsOfPayment, bool>? formsOfPaymentChecked,
    Map<PGCode, bool>? pgCodesChecked,
    this.useCustomText = false,
    this.showMerchantWidget = false,
    this.apiTransactionDetails,
    this.sessionErrorMessage,
  }) : formsOfPaymentChecked = formsOfPaymentChecked == null
           ? null
           : Map.unmodifiable(formsOfPaymentChecked),
       pgCodesChecked = pgCodesChecked == null ? null : Map.unmodifiable(pgCodesChecked);

  HomeScreenState copyWith({
    String? merchantId,
    String? apiKey,
    Object? sessionId = _unset,
    String? amount,
    String? currencyCode,
    String? phoneNumber,
    String? email,
    String? customerId,
    String? cardExpiryTime,
    String? paymentsListItemCount,
    String? defaultSelectedPayment,
    String? language,
    bool? showPaymentDetails,
    bool? noForms,
    bool? preloadPayload,
    bool? isAutoDebit,
    bool? hasSessionLoaded,
    bool? isSessionLoading,
    bool? failPaymentValidation,
    bool? useCustomText,
    bool? showMerchantWidget,
    PaymentOptionsDisplayMode? paymentOptionsDisplayMode,
    Map<FormsOfPayment, bool>? formsOfPaymentChecked,
    Map<PGCode, bool>? pgCodesChecked,
    Object? apiTransactionDetails = _unset,
    Object? sessionErrorMessage = _unset,
  }) {
    return HomeScreenState(
      merchantId: merchantId ?? this.merchantId,
      apiKey: apiKey ?? this.apiKey,
      sessionId: sessionId == _unset ? this.sessionId : sessionId as String?,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      customerId: customerId ?? this.customerId,
      cardExpiryTime: cardExpiryTime ?? this.cardExpiryTime,
      paymentsListItemCount: paymentsListItemCount ?? this.paymentsListItemCount,
      defaultSelectedPayment: defaultSelectedPayment ?? this.defaultSelectedPayment,
      language: language ?? this.language,
      showPaymentDetails: showPaymentDetails ?? this.showPaymentDetails,
      noForms: noForms ?? this.noForms,
      preloadPayload: preloadPayload ?? this.preloadPayload,
      isAutoDebit: isAutoDebit ?? this.isAutoDebit,
      failPaymentValidation: failPaymentValidation ?? this.failPaymentValidation,
      isSessionLoading: isSessionLoading ?? this.isSessionLoading,
      useCustomText: useCustomText ?? this.useCustomText,
      showMerchantWidget: showMerchantWidget ?? this.showMerchantWidget,
      hasSessionLoaded: hasSessionLoaded ?? this.hasSessionLoaded,
      paymentOptionsDisplayMode: paymentOptionsDisplayMode ?? this.paymentOptionsDisplayMode,
      formsOfPaymentChecked: formsOfPaymentChecked ?? this.formsOfPaymentChecked,
      pgCodesChecked: pgCodesChecked ?? this.pgCodesChecked,
      apiTransactionDetails: apiTransactionDetails == _unset
          ? this.apiTransactionDetails
          : apiTransactionDetails as String?,
      sessionErrorMessage: sessionErrorMessage == _unset
          ? this.sessionErrorMessage
          : sessionErrorMessage as String?,
    );
  }

  @override
  List<Object?> get props => [
    showPaymentDetails,
    merchantId,
    apiKey,
    amount,
    currencyCode,
    noForms,
    customerId,
    cardExpiryTime,
    paymentsListItemCount,
    defaultSelectedPayment,
    language,
    sessionId,
    preloadPayload,
    isAutoDebit,
    failPaymentValidation,
    isSessionLoading,
    useCustomText,
    showMerchantWidget,
    phoneNumber,
    email,
    hasSessionLoaded,
    paymentOptionsDisplayMode?.name,
    _formsOfPaymentEquality.hash(formsOfPaymentChecked),
    _pgCodeEquality.hash(pgCodesChecked),
    apiTransactionDetails,
    sessionErrorMessage,
  ];
}
