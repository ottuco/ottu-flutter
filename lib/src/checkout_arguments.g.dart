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
      paymentOptionsListMode: $enumDecode(
          _$PaymentOptionsListModeEnumMap, json['paymentOptionsListMode']),
      paymentOptionsListCount: (json['paymentOptionsListCount'] as num).toInt(),
      defaultSelectedPgCode: json['defaultSelectedPgCode'] as String?,
      apiTransactionDetails: json['apiTransactionDetails'] as String?,
      formsOfPayment: (json['formsOfPayment'] as List<dynamic>?)
          ?.map((e) => e as String)
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
      'paymentOptionsListCount': instance.paymentOptionsListCount,
      'amount': instance.amount,
      'showPaymentDetails': instance.showPaymentDetails,
      'paymentOptionsListMode':
          _$PaymentOptionsListModeEnumMap[instance.paymentOptionsListMode]!,
      'defaultSelectedPgCode': instance.defaultSelectedPgCode,
      'apiTransactionDetails': instance.apiTransactionDetails,
      'formsOfPayment': instance.formsOfPayment,
      'theme': instance.theme,
    };

const _$PaymentOptionsListModeEnumMap = {
  PaymentOptionsListMode.LIST: 'list',
  PaymentOptionsListMode.BOTTOM_SHEET: 'list',
};
