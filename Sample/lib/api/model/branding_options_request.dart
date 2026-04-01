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
  BrandingOption? knetStaging;
  @JsonKey(includeIfNull: false)
  BrandingOption? tabby;
  @JsonKey(includeIfNull: false)
  BrandingOption? tamara;
  @JsonKey(includeIfNull: false)
  BrandingOption? cod;
  @JsonKey(name: "mpgs-testing", includeIfNull: false)
  BrandingOption? mpgs;
  @JsonKey(name: "stc_pay", includeIfNull: false)
  BrandingOption? stcPay;
  @JsonKey(includeIfNull: false)
  BrandingOption? cs;
  @JsonKey(includeIfNull: false)
  BrandingOption? jamiawallet;
  @JsonKey(name: "nbk-mpgs", includeIfNull: false)
  BrandingOption? nbkMpgs;
  @JsonKey(name: "tap_pg", includeIfNull: false)
  BrandingOption? tapPg;
  @JsonKey(name: "ottu_sdk", includeIfNull: false)
  BrandingOption? ottuSdk;

  BrandingPaymentMethods({
    this.knetStaging,
    this.tabby,
    this.cod,
    this.mpgs,
    this.stcPay,
    this.cs,
    this.nbkMpgs,
    this.tapPg,
    this.ottuSdk,
  });

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
