import 'package:json_annotation/json_annotation.dart';

part 'branding_options_request.g.dart';

@JsonSerializable()
class BrandingOptionsRequest {
  @JsonKey(name: "payment_methods")
  final BrandingPaymentMethods paymentMethods;

  BrandingOptionsRequest({required this.paymentMethods});

  factory BrandingOptionsRequest.fromJson(Map<String, dynamic> json) =>
      _$BrandingOptionsRequestFromJson(json);

  Map<String, dynamic> toJson() => _$BrandingOptionsRequestToJson(this);
}

@JsonSerializable()
class BrandingPaymentMethods {
  @JsonKey(name: "knet-staging", includeIfNull: false)
  final BrandingOption? knetStaging;
  @JsonKey(includeIfNull: false)
  final BrandingOption? stc;
  @JsonKey(includeIfNull: false)
  final BrandingOption? cod;
  @JsonKey(name: "mpgs-testing", includeIfNull: false)
  final BrandingOption? mpgs;

  BrandingPaymentMethods({this.knetStaging, this.stc, this.cod, this.mpgs});

  factory BrandingPaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$BrandingPaymentMethodsFromJson(json);

  Map<String, dynamic> toJson() => _$BrandingPaymentMethodsToJson(this);
}

@JsonSerializable()
class BrandingOption {
  final String text;
  final String color;
  @JsonKey(name: "font_weight")
  final int fontWeight;

  BrandingOption({required this.text, required this.color, required this.fontWeight});

  factory BrandingOption.fromJson(Map<String, dynamic> json) => _$BrandingOptionFromJson(json);

  Map<String, dynamic> toJson() => _$BrandingOptionToJson(this);
}
