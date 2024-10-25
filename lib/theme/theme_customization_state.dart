import 'package:equatable/equatable.dart';
import 'package:ottu_flutter_checkout/ottu_flutter_checkout.dart';

final class ThemeCustomizationState extends Equatable {
  final CheckoutTheme theme;

  const ThemeCustomizationState({required this.theme});

  ThemeCustomizationState copyWith({
    CheckoutTheme? theme,
  }) {
    return ThemeCustomizationState(
      theme: theme ?? this.theme,
    );
  }

  @override
  List<Object?> get props => [
        theme.hashCode,
      ];
}
