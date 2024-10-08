// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_transaction_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiTransactionDetails _$ApiTransactionDetailsFromJson(
        Map<String, dynamic> json) =>
    ApiTransactionDetails(
      json['amount'] as String,
      json['customer_id'] as String?,
      json['customer_phone'] as String?,
      json['currency_code'] as String,
    );

Map<String, dynamic> _$ApiTransactionDetailsToJson(
    ApiTransactionDetails instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'customer_id': instance.customerId,
      'customer_phone': instance.customerPhone,
      'currency_code': instance.currencyCode,
    };
