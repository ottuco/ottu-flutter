import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _checkoutViewType = 'OttuCheckoutWidget';
const _methodOnWidgetDetached = "METHOD_ON_WIDGET_DETACHED";
const _methodVerifyPayment = "METHOD_VERIFY_PAYMENT";
const _methodChannel = MethodChannel('com.ottu.sample/checkout');
const _methodChannelPaymentVerify = MethodChannel('com.ottu.sample/checkout/payment/verify');

typedef VerifyPaymentDelegate = Future<CardVerificationResult<void, String>> Function(
    String? payload);

class OttuCheckoutWidget extends StatefulWidget {
  final CheckoutArguments arguments;
  final VerifyPaymentDelegate? _verifyPayment;

  const OttuCheckoutWidget(
      {super.key, required this.arguments, VerifyPaymentDelegate? verifyPayment})
      : _verifyPayment = verifyPayment;

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
  void didChangeDependencies() {
    _methodChannelPaymentVerify.setMethodCallHandler((call) async {
      print("CheckoutWidget, method call: ${call.method}");
      switch (call.method) {
        case _methodVerifyPayment:
          {
            final result = await widget._verifyPayment?.call(call.arguments);
            print("CheckoutWidget, verifyPayment, result: ${result.runtimeType}");
            switch (result) {
              case Success():
                return "";
              case Failure(:final message):
                throw PlatformException(code: _methodVerifyPayment, message: message);
              case null:
                throw PlatformException(code: _methodVerifyPayment, message: "Unknown error");
            }
          }
      }
    });
    super.didChangeDependencies();
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
