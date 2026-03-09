import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart' as ts;
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/l10n/app_localizations.dart';

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
  final ValueNotifier<(String, String)> _checkoutMessage = ValueNotifier<(String, String)>((
    "",
    "",
  ));

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
              child: OttuCheckoutWidget(
                arguments: widget.checkoutArguments,
                verifyPayment: _verifyPayment,
                successCallback: (message) => _checkoutMessage.value = ("Success", message),
                cancelCallback: (message) => _checkoutMessage.value = ("Cancel", message),
                errorCallback: (message) => _checkoutMessage.value = ("Error", message),
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
          ? CardVerificationResult.failure(AppLocalizations.of(context)!.prepaymentFailureMessage)
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
