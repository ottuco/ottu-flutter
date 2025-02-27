import 'package:json_annotation/json_annotation.dart';
import 'package:ottu_flutter_checkout_sample/api/billing_address.dart';

part 'create_transaction_request.g.dart';

@JsonSerializable()
class CreateTransactionRequest {
  final String amount;
  @JsonKey(name: "currency_code")
  final String currencyCode;
  @JsonKey(name: "pg_codes")
  final List<String> pgCodes;
  final String type;
  @JsonKey(name: "customer_id", includeIfNull: false)
  final String? customerId;
  @JsonKey(name: "customer_phone")
  final String? customerPhone;
  @JsonKey(name: "customer_first_name")
  final String? customerFirstName;
  @JsonKey(name: "customer_last_name")
  final String? customerLastName;
  @JsonKey(name: "customer_email")
  final String? customerEmail;
  @JsonKey(name: "billing_address")
  final BillingAddress? billingAddress;
  @JsonKey(name: "include_sdk_setup_preload")
  final bool includeSdkSetupPreload;
  final String language;
  @JsonKey(name: "card_acceptance_criteria", includeIfNull: false)
  final CardAcceptanceCriteria? cardAcceptanceCriteria;

  CreateTransactionRequest(
      {required this.amount,
      required this.currencyCode,
      required this.pgCodes,
      required this.type,
      this.customerId,
      this.customerPhone,
      this.customerFirstName,
      this.customerLastName,
      this.customerEmail,
      this.billingAddress,
      this.cardAcceptanceCriteria,
      required this.includeSdkSetupPreload,
      required this.language});

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTransactionRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateTransactionRequestToJson(this);
}

@JsonSerializable()
class CardAcceptanceCriteria {
  @JsonKey(name: "min_expiry_time")
  final int minExpiryTime;

  CardAcceptanceCriteria({required this.minExpiryTime});

  factory CardAcceptanceCriteria.fromJson(Map<String, dynamic> json) =>
      _$CardAcceptanceCriteriaFromJson(json);

  Map<String, dynamic> toJson() => _$CardAcceptanceCriteriaToJson(this);
}
