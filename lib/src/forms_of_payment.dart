import 'package:json_annotation/json_annotation.dart';

enum FormsOfPayment {
  @JsonValue("redirect")
  redirect,
  @JsonValue("flex_methods")
  flex,
  @JsonValue("stc_pay")
  stcPay,
  @JsonValue("token_pay")
  tokenPay,
  @JsonValue("card_onsite")
  cardOnSite,
  @JsonValue("google_pay")
  googlePay,
  @JsonValue("apple_pay")
  applePay,
}
