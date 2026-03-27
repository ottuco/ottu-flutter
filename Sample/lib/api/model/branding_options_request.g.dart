// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branding_options_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandingOptionsRequest _$BrandingOptionsRequestFromJson(
  Map<String, dynamic> json,
) => BrandingOptionsRequest(
  paymentMethods: BrandingPaymentMethods.fromJson(
    json['payment_methods'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$BrandingOptionsRequestToJson(
  BrandingOptionsRequest instance,
) => <String, dynamic>{'payment_methods': instance.paymentMethods};

BrandingPaymentMethods _$BrandingPaymentMethodsFromJson(
  Map<String, dynamic> json,
) => BrandingPaymentMethods(
  knetStaging: json['knet-staging'] == null
      ? null
      : BrandingOption.fromJson(json['knet-staging'] as Map<String, dynamic>),
  tabby: json['tabby'] == null
      ? null
      : BrandingOption.fromJson(json['tabby'] as Map<String, dynamic>),
  cod: json['cod'] == null
      ? null
      : BrandingOption.fromJson(json['cod'] as Map<String, dynamic>),
  mpgs: json['mpgs-testing'] == null
      ? null
      : BrandingOption.fromJson(json['mpgs-testing'] as Map<String, dynamic>),
  stcPay: json['stc_pay'] == null
      ? null
      : BrandingOption.fromJson(json['stc_pay'] as Map<String, dynamic>),
  cs: json['cs'] == null
      ? null
      : BrandingOption.fromJson(json['cs'] as Map<String, dynamic>),
  nbkMpgs: json['nbk-mpgs'] == null
      ? null
      : BrandingOption.fromJson(json['nbk-mpgs'] as Map<String, dynamic>),
  tapPg: json['tap_pg'] == null
      ? null
      : BrandingOption.fromJson(json['tap_pg'] as Map<String, dynamic>),
  ottuSdk: json['ottu_sdk'] == null
      ? null
      : BrandingOption.fromJson(json['ottu_sdk'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BrandingPaymentMethodsToJson(
  BrandingPaymentMethods instance,
) => <String, dynamic>{
  'knet-staging': ?instance.knetStaging,
  'tabby': ?instance.tabby,
  'cod': ?instance.cod,
  'mpgs-testing': ?instance.mpgs,
  'stc_pay': ?instance.stcPay,
  'cs': ?instance.cs,
  'nbk-mpgs': ?instance.nbkMpgs,
  'tap_pg': ?instance.tapPg,
  'ottu_sdk': ?instance.ottuSdk,
};

BrandingOption _$BrandingOptionFromJson(Map<String, dynamic> json) =>
    BrandingOption(
      text: json['text'] as String,
      color: json['color'] as String,
      fontWeight: (json['font_weight'] as num).toInt(),
    );

Map<String, dynamic> _$BrandingOptionToJson(BrandingOption instance) =>
    <String, dynamic>{
      'text': instance.text,
      'color': instance.color,
      'font_weight': instance.fontWeight,
    };
