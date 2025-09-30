import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart' as ch;
import 'package:ottu_flutter_checkout_sample/feature/theme/theme_customization_state.dart';
import 'package:ottu_flutter_checkout_sample/main.dart';

class ThemeCustomizationScreenCubit extends Cubit<ThemeCustomizationState> {
  final GoRouter _navigator;
  final _logger = Logger();
  final ThemeModeNotifierHolder _themeModeNotifier;

  ThemeCustomizationScreenCubit({
    required GoRouter navigator,
    required ch.CheckoutTheme? theme,
    required ThemeModeNotifierHolder themeModeNotifier,
  }) : _navigator = navigator,
       _themeModeNotifier = themeModeNotifier,
       super(ThemeCustomizationState(theme: theme ?? themeModeNotifier.themeNotifier.value));

  void onSave() async {
    _logger.d("onSave, theme: ${state.theme}");
    _navigator.pop(state.theme);
  }

  void onThemeChanged(ch.CheckoutTheme theme) async {
    _logger.d("onThemeChanged, theme: $theme");

    emit(state.copyWith(theme: theme));
  }
}
