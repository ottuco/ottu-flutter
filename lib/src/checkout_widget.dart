import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _checkoutViewType = 'OttuCheckoutWidget';
const _methodOnWidgetDetached = "METHOD_ON_WIDGET_DETACHED";
const _methodChannel = MethodChannel('com.ottu.sample/checkout');

class OttuCheckoutWidget extends StatefulWidget {
  final CheckoutArguments arguments;

  const OttuCheckoutWidget({super.key, required this.arguments});

  @override
  State<StatefulWidget> createState() => _OttuCheckoutWidgetState();
}

class _OttuCheckoutWidgetState extends State<OttuCheckoutWidget> {
  static const StandardMessageCodec _decoder = StandardMessageCodec();

  @override
  void dispose() {
    print("OttuCheckoutWidget.dispose()");
    _methodChannel.invokeMethod(_methodOnWidgetDetached);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final argsMap = widget.arguments.toJson();
    final jsonArg = json.encode(argsMap);
    final args = {"args": jsonArg};
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
          viewType: _checkoutViewType, creationParams: args, creationParamsCodec: _decoder);
    } else {
      return UiKitView(
          viewType: _checkoutViewType, creationParams: args, creationParamsCodec: _decoder);
    }
  }
}
