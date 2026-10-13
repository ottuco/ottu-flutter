import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _checkoutViewType = 'OttuCheckoutWidget';
const _methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";
const _methodOnWidgetDetached = "METHOD_ON_WIDGET_DETACHED";
const _methodVerifyPayment = "METHOD_VERIFY_PAYMENT";
const _methodPaymentSuccessResult = "METHOD_PAYMENT_SUCCESS_RESULT";
const _methodPaymentErrorResult = "METHOD_PAYMENT_ERROR_RESULT";
const _methodPaymentCancelResult = "METHOD_PAYMENT_CANCEL_RESULT";
const _methodChannel = MethodChannel('com.ottu.flutter/checkout');

const _defaultCheckoutViewHeight = 200;

typedef VerifyPaymentDelegate = Future<CardVerificationResult<void, String>> Function(
    String? payload);

class OttuCheckoutWidget extends StatefulWidget {
  final CheckoutArguments arguments;

  /// Optional initial route for the merchant view in a separate Flutter engine.
  ///
  /// Omit this or pass null/empty to create checkout without a merchant view.
  /// The host app must register any supplied route in the nested engine.
  /// This is applied when the native checkout view is created.
  final String? merchantWidgetRoute;
  final VerifyPaymentDelegate? _verifyPayment;
  final Function(String message)? _successCallback;
  final Function(String message)? _cancelCallback;
  final Function(String message)? _errorCallback;

  /// Creates an embedded native Ottu checkout view for Android or iOS.
  ///
  /// [arguments] supplies the merchant credentials, checkout session, amount,
  /// payment options, and appearance settings used to create the native view.
  /// The widget adjusts its height to match the native checkout content.
  ///
  /// [merchantWidgetRoute] optionally embeds merchant Flutter content inside
  /// checkout using a separate Flutter engine. The host app must register this
  /// route in that engine and wrap its content in [NestedWrapperWidget]. The
  /// nested engine has its own Dart state. Omitting the route, passing `null`,
  /// or passing an empty string skips both the merchant view and nested engine.
  /// Supplied routes are not checked for availability automatically.
  ///
  /// [verifyPayment] asynchronously validates the nullable payload supplied by
  /// the native SDK. Return [CardVerificationResult.success] to approve or
  /// [CardVerificationResult.failure] with a message to reject verification.
  /// If the native SDK requests verification and no callback is supplied, the
  /// request fails with an "Unknown error" message.
  ///
  /// [successCallback], [cancelCallback], and [errorCallback] receive the native
  /// SDK's message when payment succeeds, is cancelled, or reports an error,
  /// respectively. Each callback is optional; omitted callbacks are ignored.
  ///
  /// [arguments] and [merchantWidgetRoute] are passed when the native view is
  /// created. To apply different creation settings, recreate the widget with a
  /// different [key]. Unsupported platforms render an empty widget.
  const OttuCheckoutWidget({
    super.key,
    required this.arguments,
    this.merchantWidgetRoute,
    VerifyPaymentDelegate? verifyPayment,
    Function(String message)? successCallback,
    Function(String message)? cancelCallback,
    Function(String message)? errorCallback,
  })  : _verifyPayment = verifyPayment,
        _successCallback = successCallback,
        _cancelCallback = cancelCallback,
        _errorCallback = errorCallback;

  @override
  State<StatefulWidget> createState() => _OttuCheckoutWidgetState();
}

class _OttuCheckoutWidgetState extends State<OttuCheckoutWidget> {
  static const StandardMessageCodec _decoder = StandardMessageCodec();
  final ValueNotifier<int> _checkoutHeight = ValueNotifier<int>(_defaultCheckoutViewHeight);

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print("OttuCheckoutWidget.initState()");
    }
    _methodChannel.setMethodCallHandler(_handleChannelMethod);
  }

  @override
  void dispose() {
    if (kDebugMode) {
      print("OttuCheckoutWidget.dispose()");
    }
    _methodChannel.setMethodCallHandler(null);
    _methodChannel.invokeMethod(_methodOnWidgetDetached);
    super.dispose();
  }

  Future<dynamic> _handleChannelMethod(call) async {
    switch (call.method) {
      case _methodCheckoutHeight:
        {
          int height = call.arguments as int;
          _checkoutHeight.value = height;
        }
      case _methodPaymentSuccessResult:
        {
          String message = call.arguments as String;
          widget._successCallback?.call(message);
        }

      case _methodPaymentCancelResult:
        {
          String message = call.arguments as String;
          widget._cancelCallback?.call(message);
        }

      case _methodPaymentErrorResult:
        {
          String message = call.arguments as String;
          widget._errorCallback?.call(message);
        }
      case _methodVerifyPayment:
        {
          final result = await widget._verifyPayment?.call(call.arguments);
          if (kDebugMode) {
            print("CheckoutWidget, verifyPayment, result: ${result.runtimeType}");
          }
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
  }

  @override
  Widget build(BuildContext context) {
    final argsMap = widget.arguments.toJson();
    final jsonArg = json.encode(argsMap);
    final args = {"args": jsonArg, "merchantWidgetRoute": widget.merchantWidgetRoute};
    return ValueListenableBuilder<int>(
        valueListenable: _checkoutHeight,
        builder: (BuildContext context, int height, Widget? child) {
          return SizedBox(
              height: height.toDouble(),
              child: defaultTargetPlatform == TargetPlatform.android
                  ? AndroidView(
                      viewType: _checkoutViewType,
                      creationParams: args,
                      creationParamsCodec: _decoder)
                  : defaultTargetPlatform == TargetPlatform.iOS
                      ? UiKitView(
                          viewType: _checkoutViewType,
                          creationParams: args,
                          creationParamsCodec: _decoder)
                      : SizedBox.shrink());
        });
  }
}
