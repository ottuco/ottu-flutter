import 'package:flutter/material.dart';
import 'package:ottu_flutter_checkout_sample/router.dart';

const tag = "MyApp";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(
          0xFF0D1120,
        ),
        cardColor: const Color(0xFFF4EDDB),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFFE7626C),
          ),
          displaySmall: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
