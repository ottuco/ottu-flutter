import 'package:json_annotation/json_annotation.dart';

part 'billing_address.g.dart';

@JsonSerializable()
class BillingAddress {
  final String? country;
  final String? city;
  final String? line1;

  BillingAddress({this.country, this.city, this.line1});

  factory BillingAddress.fromJson(Map<String, dynamic> json) =>
      _$BillingAddressFromJson(json);

  Map<String, dynamic> toJson() => _$BillingAddressToJson(this);
}
