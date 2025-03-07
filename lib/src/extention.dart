import 'dart:ui';

import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const String _merchantId = "merchantId";
const String _apiKey = "apiKey";
const String _sessionId = "sessionId";
const String _showPaymentDetails = "showPaymentDetails";

extension CheckoutArgumentsMapper on CheckoutArguments {
  Map<String, String> toMap() => {
        _merchantId: merchantId,
        _apiKey: apiKey,
        _sessionId: sessionId,
        _showPaymentDetails: showPaymentDetails.toString()
      };
}

extension HexColor on Color {
  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
