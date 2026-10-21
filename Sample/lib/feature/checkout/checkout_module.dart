import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/di/Module.dart';
import 'package:ottu_flutter_checkout_sample/feature/checkout/checkout_screen.dart';
import 'package:ottu_flutter_checkout_sample/feature/checkout/merchant_nested_widget.dart';

final class CheckoutModule implements Module {
  final _logger = Logger();
  @override
  void init(GetIt service) {}

  @override
  List<RouteBase> router() {
    return [
      GoRoute(
        path: '/checkout',
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final args = extra["args"] as CheckoutArguments;
          final failPaymentValidation = extra["failPaymentValidation"] as bool;
          final merchantWidgetRoute = extra["merchantWidgetRoute"] as String?;
          return PopScope(
            onPopInvokedWithResult: (didPop, _) {
              final canPopSwipe = !Navigator.of(context).userGestureInProgress;
              _logger.d("canPop: $canPopSwipe, didPop: $didPop");
            },
            child: CheckoutScreen(
              title: "Checkout",
              checkoutArguments: args,
              failPaymentValidation: failPaymentValidation,
              onCheckoutCompleted: extra["onCheckoutCompleted"] as VoidCallback,
              merchantWidgetRoute: merchantWidgetRoute,
            ),
          );
        },
        onExit: (context, state) async {
          _logger.d("router, /checkout, exit");
          return true;
        },
      ),

      // Native checkout engines start here with their own Dart state.
      // Keep this route available independently of the main app checkbox.
      GoRoute(
        path: '/merchantNestedWidget',
        builder: (context, state) {
          return MerchantNestedWidget();
        },
        onExit: (context, state) async {
          _logger.d("router, /merchantNestedWidget, exit");
          return true;
        },
      ),
    ];
  }
}
