import 'package:json_annotation/json_annotation.dart';

part 'api_transaction_details.g.dart';

@JsonSerializable(createToJson: false)
class ApiTransactionDetails {
  final String amount;
  @JsonKey(name: "customer_id")
  final String? customerId;
  @JsonKey(name: "customer_phone")
  final String? customerPhone;
  @JsonKey(name: "currency_code")
  final String currencyCode;

  ApiTransactionDetails(
      this.amount, this.customerId, this.customerPhone, this.currencyCode);

/*val language: Language,
val operation: ApiPaymentOperation?,
@Json(name = "payment_methods")
val paymentMethods: List<ApiPaymentMethod>,
@Json(name = "payment_services")
val paymentServices: List<ApiPaymentService>,
@Json(name = "flex_methods")
val paymentFlexMethods: List<ApiPaymentFlexMethod>,
val response: ApiTransactionResponse?,
val state: State,
val type: ApiTransactionType,
@Json(name = "is_amount_editable") val isAmountEditable: Boolean*/

  factory ApiTransactionDetails.fromJson(Map<String, dynamic> json) =>
      _$ApiTransactionDetailsFromJson(json);
}
