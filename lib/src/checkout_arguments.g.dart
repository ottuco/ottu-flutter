// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_arguments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutArguments _$CheckoutArgumentsFromJson(Map<String, dynamic> json) =>
    CheckoutArguments(
      merchantId: json['merchantId'] as String,
      apiKey: json['apiKey'] as String,
      sessionId: json['sessionId'] as String,
      amount: (json['amount'] as num).toDouble(),
      showPaymentDetails: json['showPaymentDetails'] as bool,
      paymentOptionsDisplaySettings: PaymentOptionsDisplaySettings.fromJson(
          json['paymentOptionsDisplaySettings'] as Map<String, dynamic>),
      apiTransactionDetails: json['apiTransactionDetails'] as String?,
      formsOfPayment: (json['formsOfPayment'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$FormsOfPaymentEnumMap, e))
          .toList(),
      theme: json['theme'] == null
          ? null
          : CheckoutTheme.fromJson(json['theme'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckoutArgumentsToJson(CheckoutArguments instance) =>
    <String, dynamic>{
      'merchantId': instance.merchantId,
      'apiKey': instance.apiKey,
      'sessionId': instance.sessionId,
      'amount': instance.amount,
      'showPaymentDetails': instance.showPaymentDetails,
      'paymentOptionsDisplaySettings': instance.paymentOptionsDisplaySettings,
      'apiTransactionDetails': instance.apiTransactionDetails,
      'formsOfPayment': instance.formsOfPayment
          ?.map((e) => _$FormsOfPaymentEnumMap[e]!)
          .toList(),
      'theme': instance.theme,
    };

const _$FormsOfPaymentEnumMap = {
  FormsOfPayment.redirect: 'redirect',
  FormsOfPayment.flex: 'flex_methods',
  FormsOfPayment.stcPay: 'stc_pay',
  FormsOfPayment.tokenPay: 'token_pay',
  FormsOfPayment.cardOnSite: 'card_onsite',
  FormsOfPayment.googlePay: 'google_pay',
  FormsOfPayment.applePay: 'apple_pay',
};
