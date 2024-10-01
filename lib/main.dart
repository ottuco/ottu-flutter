import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:ottu_sample/checkout_widget.dart';

const defaultCheckoutViewHeight = 400;
const methodCheckoutHeight = "METHOD_CHECKOUT_HEIGHT";
const tag = "MyApp";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Ottu'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  final ValueNotifier<int> _checkoutHeight =
      ValueNotifier<int>(defaultCheckoutViewHeight);

  static const MethodChannel _methodChannel =
      MethodChannel('com.ottu.sample/checkout');

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
        case methodCheckoutHeight:
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
                    CheckoutWidget(onCheckoutViewCreated: (controller) {})
                  ]));
            },
            valueListenable: _checkoutHeight,
          ),
          //    ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton(
              onPressed: () {
                //call plugin to add ottu fragment
                _runOttuSdk();
              },
              child: const Text("Run Ottu")),
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

  void _runOttuSdk() async {
    try {
      final int? result = await _methodChannel.invokeMethod('launchOttuSdk');
    } on PlatformException catch (e) {
      if (e.code == '911') {
        logger.w("Error while instantating Sdk");
      } else {
        logger.w("Unable to instantiate Sdk");
      }
    }
  }
}
