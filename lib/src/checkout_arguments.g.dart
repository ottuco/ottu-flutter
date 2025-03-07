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
      apiTransactionDetails: json['apiTransactionDetails'] as String?,
      formsOfPayment: (json['formsOfPayment'] as List<dynamic>)
          .map((e) => e as String)
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
      'apiTransactionDetails': instance.apiTransactionDetails,
      'formsOfPayment': instance.formsOfPayment,
      'theme': instance.theme,
    };
