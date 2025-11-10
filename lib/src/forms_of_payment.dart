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
  applePay;
}

extension FormOfPaymentCode on FormsOfPayment{
  String code() =>
      switch(this){
        FormsOfPayment.redirect => "redirect",
        FormsOfPayment.flex => "flex_methods",
        FormsOfPayment.stcPay => "stc_pay",
        FormsOfPayment.tokenPay => "token_pay",
        FormsOfPayment.cardOnSite => "card_onsite",
        FormsOfPayment.googlePay => "google_pay",
        FormsOfPayment.applePay => "apple_pay",
      };
}
