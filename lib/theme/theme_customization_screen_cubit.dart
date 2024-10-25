import 'dart:ui' as ui;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart' as ch;
import 'package:ottu_flutter_checkout_sample/theme/theme_customization_state.dart';

class ThemeCustomizationScreenCubit extends Cubit<ThemeCustomizationState> {
  final GoRouter _navigator;
  final _logger = Logger();

  ThemeCustomizationScreenCubit({required GoRouter navigator, required ch.CheckoutTheme theme})
      : _navigator = navigator,
        super(ThemeCustomizationState(theme: theme));

  void onThemeCustomization() async {
    _logger.d("onThemeCustomization");
    _navigator.push("/theme_customization");
  }

  void onSave() async {
    _logger.d("onSave, theme: ${state.theme}");
    _navigator.pop(state.theme);
  }

  void onThemeChanged(ui.Color color) async {
    _logger.d("onThemeChanged, color: $color");

    emit(state.copyWith(
        theme: state.theme.copyWith(titleText: ch.TextStyle(textColor: ch.ColorState(color: color)))));
  }

  int hexOfRGBA(int r, int g, int b, {double opacity = 1}) {
    r = (r < 0) ? -r : r;
    g = (g < 0) ? -g : g;
    b = (b < 0) ? -b : b;
    opacity = (opacity < 0) ? -opacity : opacity;
    opacity = (opacity > 1) ? 255 : opacity * 255;
    r = (r > 255) ? 255 : r;
    g = (g > 255) ? 255 : g;
    b = (b > 255) ? 255 : b;
    int a = opacity.toInt();
    return int.parse(
        '0x${a.toRadixString(16)}${r.toRadixString(16)}${g.toRadixString(16)}${b.toRadixString(16)}');
  }
}
