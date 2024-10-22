import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/chackout_screen.dart';
import 'package:ottu_flutter_checkout_sample/home_screen.dart';
import 'package:ottu_flutter_checkout_sample/home_screen_cubit.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(
        path: '/',
        builder: (context, state) => BlocProvider(
              create: (_) => HomeScreenCubit(navigator: GoRouter.of(context)),
              child: const HomeScreen(),
            )),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => CheckoutScreen(title: "Checkout", checkoutArguments: state.extra as CheckoutArguments),
    )
  ],
);
