import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/chackout_screen.dart';
import 'package:ottu_flutter_checkout_sample/home_screen.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/main.dart';
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_screen.dart';
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_screen_cubit.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
              create: (_) => HomeScreenCubit(
                  navigator: GoRouter.of(context),
                  themeModeNotifier: context.watch<ThemeModeNotifierHolder>()),
              child: const HomeScreen(),
            )),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => WillPopScope(
        //canPop: _canPop(context),
        //onPopInvokedWithResult: (bool didPop, dynamic result) =>
        //   _onPopInvoked(context, didPop, result),
        onWillPop: () async => _canPop(context),
        child:
            CheckoutScreen(title: "Checkout", checkoutArguments: state.extra as CheckoutArguments),
      ),
    ),
    GoRoute(
        path: '/theme_customization',
        builder: (context, state) => BlocProvider(
              create: (_) => ThemeCustomizationScreenCubit(
                  navigator: GoRouter.of(context), theme: state.extra as CheckoutTheme?),
              child: const ThemeCustomizationScreen(),
            ))
  ],
);

_onPopInvoked(BuildContext context, bool didPop, dynamic result) {
  print("_onPopInvoked: $didPop, result: $result");
}

Future<bool> _canPop(BuildContext context) async {
  final canPopSwipe = !(Navigator.of(context).userGestureInProgress);
  print("canPop: $canPopSwipe");
  return canPopSwipe;
}
