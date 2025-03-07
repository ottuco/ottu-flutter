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
  String? apiTransactionDetails;
  final List<String>? formsOfPayment;
  final CheckoutTheme? theme;

  CheckoutArguments({required this.merchantId,
    required this.apiKey,
    required this.sessionId,
    required this.amount,
    required this.showPaymentDetails,
    required this.apiTransactionDetails,
    required this.formsOfPayment,
    this.theme});

  factory CheckoutArguments.fromJson(Map<String, dynamic> json) =>
      _$CheckoutArgumentsFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutArgumentsToJson(this);
}
