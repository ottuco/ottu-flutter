// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billing_address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


BillingAddress _$BillingAddressFromJson(Map<String, dynamic> json) =>
    BillingAddress(
      country: json['country'] as String?,
      city: json['city'] as String?,
      line1: json['line1'] as String?,
    );

Map<String, dynamic> _$BillingAddressToJson(BillingAddress instance) =>
    <String, dynamic>{
      'country': instance.country,
      'city': instance.city,
      'line1': instance.line1,
    };
