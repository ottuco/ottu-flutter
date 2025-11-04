import 'package:json_annotation/json_annotation.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout/src/forms_of_payment.dart';
import 'package:ottu_flutter_checkout/src/payment_options_display_settings.dart';

part 'checkout_arguments.g.dart';

@JsonSerializable()
final class CheckoutArguments {
  final String merchantId;
  final String apiKey;
  final String sessionId;
  final double amount;
  final bool showPaymentDetails;
  final PaymentOptionsDisplaySettings paymentOptionsDisplaySettings;
  String? apiTransactionDetails;
  final List<FormsOfPayment>? formsOfPayment;
  final CheckoutTheme? theme;

  CheckoutArguments(
      {required this.merchantId,
      required this.apiKey,
      required this.sessionId,
      required this.amount,
      required this.showPaymentDetails,
      required this.paymentOptionsDisplaySettings,
      this.apiTransactionDetails,
      this.formsOfPayment,
      this.theme});

  factory CheckoutArguments.fromJson(Map<String, dynamic> json) =>
      _$CheckoutArgumentsFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutArgumentsToJson(this);
}
