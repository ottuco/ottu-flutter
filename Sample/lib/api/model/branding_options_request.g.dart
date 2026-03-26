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
  stc: json['stc'] == null
      ? null
      : BrandingOption.fromJson(json['stc'] as Map<String, dynamic>),
  cod: json['cod'] == null
      ? null
      : BrandingOption.fromJson(json['cod'] as Map<String, dynamic>),
  mpgs: json['mpgs-testing'] == null
      ? null
      : BrandingOption.fromJson(json['mpgs-testing'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BrandingPaymentMethodsToJson(
  BrandingPaymentMethods instance,
) => <String, dynamic>{
  'knet-staging': instance.knetStaging,
  'stc': instance.stc,
  'cod': instance.cod,
  'mpgs-testing': instance.mpgs,
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
