import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';
import 'package:ottu_flutter_checkout_sample/di/Module.dart';
import 'package:ottu_flutter_checkout_sample/feature/theme/theme_customization_screen.dart';
import 'package:ottu_flutter_checkout_sample/feature/theme/theme_customization_screen_cubit.dart';
import 'package:ottu_flutter_checkout_sample/main.dart';

final class ThemeModule implements Module {
  @override
  void init(GetIt service) {}

  @override
  List<RouteBase> router() {
    return [
      GoRoute(
        path: '/theme_customization',
        builder: (context, state) => BlocProvider(
          create: (_) => ThemeCustomizationScreenCubit(
            navigator: GoRouter.of(context),
            theme: state.extra as CheckoutTheme?,
            themeModeNotifier: context.watch<ThemeModeNotifierHolder>(),
          ),
          child: const ThemeCustomizationScreen(),
        ),
      ),
    ];
  }
}
