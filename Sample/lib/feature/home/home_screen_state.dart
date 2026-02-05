import 'package:equatable/equatable.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/api/model/pg_codes.dart';

const _default_payments_list__item_count = 5;

final class HomeScreenState extends Equatable {
  final String merchantId;
  final String apiKey;
  final String? sessionId;
  final String? amount;
  final String? currencyCode;
  final String? phoneNumber;
  final String? customerId;
  final String? cardExpiryTime;
  final String paymentsListItemCount;
  final String? defaultSelectedPayment;
  final bool showPaymentDetails;
  final bool? noForms;
  final bool? preloadPayload;
  final bool? isAutoDebit;
  final bool hasSessionLoaded;
  final bool? failPaymentValidation;
  final PaymentOptionsDisplayMode? paymentOptionsDisplayMode;
  final Map<FormsOfPayment, bool>? formsOfPaymentChecked;
  final Map<PGCode, bool>? pgCodesChecked;

  const HomeScreenState({
    required this.merchantId,
    required this.apiKey,
    this.sessionId,
    this.amount,
    this.currencyCode,
    this.phoneNumber,
    this.customerId,
    this.cardExpiryTime,
    this.paymentsListItemCount = "$_default_payments_list__item_count",
    this.defaultSelectedPayment,
    this.showPaymentDetails = true,
    this.preloadPayload = true,
    this.isAutoDebit = false,
    this.noForms,
    this.hasSessionLoaded = false,
    this.failPaymentValidation = false,
    this.paymentOptionsDisplayMode,
    this.formsOfPaymentChecked,
    this.pgCodesChecked,
  });

  HomeScreenState copyWith({
    String? merchantId,
    String? apiKey,
    String? sessionId,
    String? amount,
    String? currencyCode,
    String? phoneNumber,
    String? customerId,
    String? cardExpiryTime,
    String? paymentsListItemCount,
    String? defaultSelectedPayment,
    bool? showPaymentDetails,
    bool? noForms,
    bool? preloadPayload,
    bool? isAutoDebit,
    bool? hasSessionLoaded,
    bool? failPaymentValidation,
    PaymentOptionsDisplayMode? paymentOptionsDisplayMode,
    Map<FormsOfPayment, bool>? formsOfPaymentChecked,
    Map<PGCode, bool>? pgCodesChecked,
  }) {
    return HomeScreenState(
      merchantId: merchantId ?? this.merchantId,
      apiKey: apiKey ?? this.apiKey,
      sessionId: sessionId ?? this.sessionId,
      amount: amount ?? this.amount,
      currencyCode: currencyCode ?? this.currencyCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      customerId: customerId ?? this.customerId,
      cardExpiryTime: cardExpiryTime ?? this.cardExpiryTime,
      paymentsListItemCount: paymentsListItemCount ?? this.paymentsListItemCount,
      defaultSelectedPayment: defaultSelectedPayment ?? this.defaultSelectedPayment,
      showPaymentDetails: showPaymentDetails ?? this.showPaymentDetails,
      noForms: noForms ?? this.noForms,
      preloadPayload: preloadPayload ?? this.preloadPayload,
      isAutoDebit: isAutoDebit ?? this.isAutoDebit,
      failPaymentValidation: failPaymentValidation ?? this.failPaymentValidation,
      hasSessionLoaded: hasSessionLoaded ?? this.hasSessionLoaded,
      paymentOptionsDisplayMode: paymentOptionsDisplayMode ?? this.paymentOptionsDisplayMode,
      formsOfPaymentChecked: formsOfPaymentChecked ?? this.formsOfPaymentChecked,
      pgCodesChecked: pgCodesChecked ?? this.pgCodesChecked,
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
    sessionId,
    preloadPayload,
    isAutoDebit,
    failPaymentValidation,
    phoneNumber,
    hasSessionLoaded,
    paymentOptionsDisplayMode?.name,
    formsOfPaymentChecked.hashCode,
    pgCodesChecked.hashCode,
  ];
}
