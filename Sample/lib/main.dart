import 'package:flutter/material.dart';
import 'package:ottu_flutter_checkout_sample/router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const tag = "MyApp";

class ThemeModeNotifierHolder {
  ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeModeNotifierHolder _themeModeNotifierHolder = ThemeModeNotifierHolder();

  @override
  Widget build(BuildContext context) {
    return Provider<ThemeModeNotifierHolder>(
        create: (context) => _themeModeNotifierHolder,
        child: ValueListenableBuilder(
            valueListenable: _themeModeNotifierHolder.themeModeNotifier,
            builder: (context, themeMode, _) {
              return MaterialApp.router(
                routerConfig: router,
                themeMode: themeMode,
                supportedLocales: [
                  Locale('ar'),
                  Locale('en'),
                ],
                localizationsDelegates: const [
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
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
            }));
  }
}
