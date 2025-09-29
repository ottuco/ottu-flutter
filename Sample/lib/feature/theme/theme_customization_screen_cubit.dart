import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart' as ch;
import 'package:ottu_flutter_checkout_sample/feature/theme/theme_customization_state.dart';

class ThemeCustomizationScreenCubit extends Cubit<ThemeCustomizationState> {
  final GoRouter _navigator;
  final _logger = Logger();

  ThemeCustomizationScreenCubit({required GoRouter navigator, required ch.CheckoutTheme? theme})
    : _navigator = navigator,
      super(ThemeCustomizationState(theme: theme));

  void onSave() async {
    _logger.d("onSave, theme: ${state.theme}");
    _navigator.pop(state.theme);
  }

  void onThemeChanged(ch.CheckoutTheme theme) async {
    _logger.d("onThemeChanged, theme: $theme");

    emit(state.copyWith(theme: theme));
  }
}
