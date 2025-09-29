import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ottu_flutter_checkout_sample/feature/checkout/checkout_module.dart';
import 'package:ottu_flutter_checkout_sample/feature/home/home_module.dart';
import 'package:ottu_flutter_checkout_sample/feature/theme/theme_module.dart';
import 'package:provider/provider.dart';

import 'di/Module.dart';

const tag = "MyApp";

class ThemeModeNotifierHolder {
  ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.system);
}

final _service = GetIt.instance;

void main() {
  runApp(OttuApp(modules: [HomeModule(), ThemeModule(), CheckoutModule()]));
}

class OttuApp extends StatelessWidget {
  final modules = [];
  final routes = <RouteBase>[];
  ThemeModeNotifierHolder _themeModeNotifierHolder = ThemeModeNotifierHolder();

  OttuApp({required final List<Module> modules, super.key}) {
    modules.forEach((final module) => module.init(_service));
    modules.forEach((final module) => routes.addAll(module.router()));
  }

  @override
  Widget build(BuildContext context) {
    return Provider<ThemeModeNotifierHolder>(
      create: (context) => _themeModeNotifierHolder,
      child: ValueListenableBuilder(
        valueListenable: _themeModeNotifierHolder.themeModeNotifier,
        builder: (context, themeMode, _) {
          return MaterialApp.router(
            routerConfig: GoRouter(routes: routes),
            themeMode: themeMode,
            supportedLocales: [Locale('ar'), Locale('en')],
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
              scaffoldBackgroundColor: const Color(0xFF0D1120),
              cardColor: const Color(0xFFF4EDDB),
              textTheme: const TextTheme(
                displayLarge: TextStyle(color: Color(0xFFE7626C)),
                displaySmall: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
