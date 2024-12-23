import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/painting/text_style.dart' as ts;
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _defaultCheckoutViewHeight = 200;
const _methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";
const _methodChannel = MethodChannel('com.ottu.sample/checkout');

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key, required this.title, required this.checkoutArguments});

  final String title;
  final CheckoutArguments checkoutArguments;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ValueNotifier<int> _checkoutHeight = ValueNotifier<int>(_defaultCheckoutViewHeight);

  final logger = Logger();

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
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        SizedBox(height: 46),
        Text(
          "Customer Application",
          textAlign: TextAlign.center,
          style: ts.TextStyle(fontSize: 24),
        ),
        const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements")),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ValueListenableBuilder<int>(
            builder: (BuildContext context, int height, Widget? child) {
              //return OttuCheckoutWidget(arguments: widget.checkoutArguments);
              return SizedBox(
                  height: height.toDouble(),
                  child: OttuCheckoutWidget(arguments: widget.checkoutArguments),
              );
            },
            valueListenable: _checkoutHeight,
          ),
        ),
        const SizedBox(height: 20),
        const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
                "Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements, Some users UI elements,"
                    " Some users UI elements, Some users UI elements, Some users UI elements,"
                    " Some users UI elements, Some users UI elements, Some users UI elements")),
      ])), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
