import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/painting/text_style.dart' as ts;
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _defaultCheckoutViewHeight = 200;
const _methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";
const _methodPaymentSuccessResult = "METHOD_PAYMENT_SUCCESS_RESULT";
const _methodPaymentErrorResult = "METHOD_PAYMENT_ERROR_RESULT";
const _methodPaymentCancelResult = "METHOD_PAYMENT_CANCEL_RESULT";
const _methodChannel = MethodChannel('com.ottu.sample/checkout');

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({
    super.key,
    required this.title,
    required this.checkoutArguments,
    required this.failPaymentValidation,
  });

  final String title;
  final CheckoutArguments checkoutArguments;
  final bool failPaymentValidation;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ValueNotifier<int> _checkoutHeight = ValueNotifier<int>(_defaultCheckoutViewHeight);
  final ValueNotifier<(String, String)> _checkoutMessage =
      ValueNotifier<(String, String)>(("", ""));

  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _checkoutMessage.addListener(_showMessageDialog);
  }

  @override
  void dispose() {
    super.dispose();
    _checkoutMessage.removeListener(_showMessageDialog);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _methodChannel.setMethodCallHandler((call) async {
      switch (call.method) {
        case _methodCheckoutHeight:
          {
            int height = call.arguments as int;
            logger.d("didChangeDependencies, height: $height");
            _checkoutHeight.value = height;
          }
        case _methodPaymentSuccessResult:
          {
            String message = call.arguments as String;
            logger.d("didChangeDependencies, success: $message");
            _checkoutMessage.value = ("Success", message);
          }

        case _methodPaymentCancelResult:
          {
            String message = call.arguments as String;
            logger.d("didChangeDependencies, cancel: $message");
            _checkoutMessage.value = ("Cancel", message);
          }

        case _methodPaymentErrorResult:
          {
            String message = call.arguments as String;
            logger.d("didChangeDependencies, error: $message");
            _checkoutMessage.value = ("Error", message);
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 46),
            Text(
              "Customer Application",
              textAlign: TextAlign.center,
              style: ts.TextStyle(fontSize: 24),
            ),
            //Start of Merchant content
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements",
              ),
            ),
            //End of Merchant content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ValueListenableBuilder<int>(
                builder: (BuildContext context, int height, Widget? child) {
                  return SizedBox(
                    height: height.toDouble(),
                    child: OttuCheckoutWidget(
                      arguments: widget.checkoutArguments,
                      verifyPayment: _verifyPayment,
                    ),
                  );
                },
                valueListenable: _checkoutHeight,
              ),
            ),
            const SizedBox(height: 20),
            //Start of Merchant content
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                "Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements,"
                " Some users UI elements, Some users UI elements, Some users UI elements,"
                " Some users UI elements, Some users UI elements, Some users UI elements",
              ),
            ),
            //End of Merchant content
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<CardVerificationResult<void, String>> _verifyPayment(String? payload) async {
    logger.d("verifyPayment, payload: $payload");

    //merchant Api call for payload validation
    return Future.delayed(Duration(seconds: 2)).then((_) {
      logger.d("verifyPayment, fail verification: ${widget.failPaymentValidation}");
      return widget.failPaymentValidation
          ? CardVerificationResult.failure(
              "Cannot pay your order.\nPlease, check purchase information",
            )
          : CardVerificationResult.success();
    });
  }

  Future<void> _showMessageDialog() async {
    if (_checkoutMessage.value.$1.isNotEmpty) {
      showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(_checkoutMessage.value.$1),
            content: SingleChildScrollView(child: Text(_checkoutMessage.value.$2)),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
