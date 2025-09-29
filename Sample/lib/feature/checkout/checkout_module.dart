import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/di/Module.dart';
import 'package:ottu_flutter_checkout_sample/feature/checkout/chackout_screen.dart';

final class CheckoutModule implements Module {
  final _logger = Logger();

  @override
  void init(GetIt service) {}

  @override
  List<RouteBase> router() {
    return [
      GoRoute(
        path: '/checkout',
        builder: (context, state) => PopScope(
          onPopInvokedWithResult: (didPop, result) => _canPop(context, didPop, result),
          child: CheckoutScreen(
            title: "Checkout",
            checkoutArguments: state.extra as CheckoutArguments,
          ),
        ),
        onExit: (BuildContext, GoRouterState) async {
          _logger.d("router, /checkout, exit");
          return true;
        },
      ),
    ];
  }
}

_onPopInvoked(BuildContext context, bool didPop, dynamic result) {
  print("_onPopInvoked: $didPop, result: $result");
}

_canPop(BuildContext context, bool didPop, Result) async {
  final canPopSwipe = !(Navigator.of(context).userGestureInProgress);
  print("canPop: $canPopSwipe, didPop: $didPop");
  return canPopSwipe;
}
