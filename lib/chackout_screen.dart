import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

const _defaultCheckoutViewHeight = 400;
const _methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";
const _methodChannel = MethodChannel('com.ottu.sample/checkout');

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen(
      {super.key, required this.title, required this.checkoutArguments});

  final String title;
  final CheckoutArguments checkoutArguments;

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _counter = 0;

  final ValueNotifier<int> _checkoutHeight =
      ValueNotifier<int>(_defaultCheckoutViewHeight);

  final logger = Logger();

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
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
            //_checkoutHeight.value = height;
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Padding(
            padding: EdgeInsets.all(12.0),
            child: SizedBox(
              height: 140,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.lightBlueAccent),
                child: Center(
                  child: Text("First component", textAlign: TextAlign.center),
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ValueListenableBuilder<int>(
            builder: (BuildContext context, int height, Widget? child) {
              return SizedBox(
                  height: height.toDouble(),
                  //child: DecoratedBox(
                  //    decoration: BoxDecoration(color: Colors.grey[600]),
                  child: Stack(children: [
                    OttuCheckoutWidget(arguments: widget.checkoutArguments)
                  ]));
            },
            valueListenable: _checkoutHeight,
          ),
          //    ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              ElevatedButton(onPressed: () {}, child: const Text("Run Ottu")),
        ),
        const SizedBox(height: 80),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              "$_counter",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        SizedBox(height: 80),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
