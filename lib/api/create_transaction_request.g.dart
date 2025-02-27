// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_transaction_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTransactionRequest _$CreateTransactionRequestFromJson(
        Map<String, dynamic> json) =>
    CreateTransactionRequest(
      amount: json['amount'] as String,
      currencyCode: json['currency_code'] as String,
      pgCodes:
          (json['pg_codes'] as List<dynamic>).map((e) => e as String).toList(),
      type: json['type'] as String,
      customerId: json['customer_id'] as String?,
      customerPhone: json['customer_phone'] as String?,
      customerFirstName: json['customer_first_name'] as String?,
      customerLastName: json['customer_last_name'] as String?,
      customerEmail: json['customer_email'] as String?,
      billingAddress: json['billing_address'] == null
          ? null
          : BillingAddress.fromJson(
              json['billing_address'] as Map<String, dynamic>),
      cardAcceptanceCriteria: json['card_acceptance_criteria'] == null
          ? null
          : CardAcceptanceCriteria.fromJson(
              json['card_acceptance_criteria'] as Map<String, dynamic>),
      includeSdkSetupPreload: json['include_sdk_setup_preload'] as bool,
      language: json['language'] as String,
    );

Map<String, dynamic> _$CreateTransactionRequestToJson(
        CreateTransactionRequest instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'currency_code': instance.currencyCode,
      'pg_codes': instance.pgCodes,
      'type': instance.type,
      if (instance.customerId case final value?) 'customer_id': value,
      'customer_phone': instance.customerPhone,
      'customer_first_name': instance.customerFirstName,
      'customer_last_name': instance.customerLastName,
      'customer_email': instance.customerEmail,
      'billing_address': instance.billingAddress,
      'include_sdk_setup_preload': instance.includeSdkSetupPreload,
      'language': instance.language,
      if (instance.cardAcceptanceCriteria case final value?)
        'card_acceptance_criteria': value,
    };

CardAcceptanceCriteria _$CardAcceptanceCriteriaFromJson(
        Map<String, dynamic> json) =>
    CardAcceptanceCriteria(
      minExpiryTime: (json['min_expiry_time'] as num).toInt(),
    );

Map<String, dynamic> _$CardAcceptanceCriteriaToJson(
        CardAcceptanceCriteria instance) =>
    <String, dynamic>{
      'min_expiry_time': instance.minExpiryTime,
    };
