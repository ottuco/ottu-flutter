import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottu_sample/checkout_view_controller.dart';

typedef CheckoutViewCreatedCallback = void Function(
    CheckoutViewController controller);

class CheckoutWidget extends StatelessWidget {
  static const StandardMessageCodec _decoder = StandardMessageCodec();
  final CheckoutViewCreatedCallback? onCheckoutViewCreated;

  const CheckoutWidget({super.key, required this.onCheckoutViewCreated});

  @override
  Widget build(BuildContext context) {
    final Map<String, String> args = {"someInit": "initData"};
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
          viewType: 'CheckoutPlatformView',
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: args,
          creationParamsCodec: _decoder);
    }
    return UiKitView(
        viewType: 'CheckoutPlatformView',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: args,
        creationParamsCodec: _decoder);
  }

  _onPlatformViewCreated(int id) {
    onCheckoutViewCreated?.call(CheckoutViewController(id));
  }
}
