import 'package:json_annotation/json_annotation.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

part 'checkout_arguments.g.dart';

@JsonSerializable()
final class CheckoutArguments {
  final String merchantId;
  final String apiKey;
  final String sessionId;
  final double amount;
  final bool showPaymentDetails;
  final PaymentOptionsDisplaySettings paymentOptionsDisplaySettings;
  @JsonKey(name: "apiTransactionDetails")
  String? setupPreload;
  final List<FormsOfPayment>? formsOfPayment;
  final CheckoutTheme? theme;
  final PayButtonText? payButtonText;

  CheckoutArguments({
    required this.merchantId,
    required this.apiKey,
    required this.sessionId,
    required this.amount,
    required this.showPaymentDetails,
    required this.paymentOptionsDisplaySettings,
    this.setupPreload,
    this.formsOfPayment,
    this.theme,
    this.payButtonText,
  });

  factory CheckoutArguments.fromJson(Map<String, dynamic> json) =>
      _$CheckoutArgumentsFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutArgumentsToJson(this);
}
