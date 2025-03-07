import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _checkoutViewType = 'OttuCheckoutWidget';

final _logger = Logger();

class OttuCheckoutWidget extends StatelessWidget {
  static const StandardMessageCodec _decoder = StandardMessageCodec();
  final CheckoutArguments arguments;

  const OttuCheckoutWidget({super.key, required this.arguments});

  @override
  Widget build(BuildContext context) {
    final argsMap = arguments.toJson();
    final jsonArg = json.encode(argsMap);
    final args = {"args": jsonArg};
    _logger.d("build, args: $args");
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
          viewType: _checkoutViewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: args,
          creationParamsCodec: _decoder);
    } else {
      return UiKitView(
          viewType: _checkoutViewType,
          onPlatformViewCreated: _onPlatformViewCreated,
          creationParams: args,
          creationParamsCodec: _decoder);
    }
  }

  _onPlatformViewCreated(int id) {
    _logger.d("onPlatformViewCreated, with id: $id");
  }
}
