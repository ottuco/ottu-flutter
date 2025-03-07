import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ottu_flutter_checkout/src/extention.dart';

part 'checkout_theme.g.dart';

@JsonSerializable()
class CheckoutTheme extends Equatable {
  @_UiModeJsonConverter()
  final CustomerUiMode uiMode;
  final TextStyle? mainTitleText;
  final TextStyle? titleText;
  final TextStyle? subtitleText;
  final TextStyle? feesTitleText;
  final TextStyle? feesSubtitleText;
  final TextStyle? dataLabelText;
  final TextStyle? dataValueText;
  final TextStyle? errorMessageText;

  final TextFieldStyle? inputTextField;

  final ButtonComponent? button;
  final RippleColor? backButton;
  final ButtonComponent? selectorButton;
  final SwitchComponent? switchControl;
  final Margins? margins;

  final ColorState? sdkBackgroundColor;
  final ColorState? modalBackgroundColor;
  final ColorState? paymentItemBackgroundColor;
  final ColorState? selectorIconColor;
  final ColorState? savePhoneNumberIconColor;

  CheckoutTheme({this.uiMode = CustomerUiMode.auto,
    this.titleText,
    this.mainTitleText,
    this.subtitleText,
    this.feesTitleText,
    this.feesSubtitleText,
    this.dataLabelText,
    this.dataValueText,
    this.errorMessageText,
    this.inputTextField,
    this.button,
    this.backButton,
    this.selectorButton,
    this.switchControl,
    this.margins,
    this.sdkBackgroundColor,
    this.modalBackgroundColor,
    this.paymentItemBackgroundColor,
    this.selectorIconColor,
    this.savePhoneNumberIconColor});

  CheckoutTheme copyWith({CustomerUiMode? uiMode,
    TextStyle? titleText,
    TextStyle? mainTitleText,
    TextStyle? subtitleText,
    TextStyle? feesTitleText,
    TextStyle? feesSubtitleText,
    TextStyle? dataLabelText,
    TextStyle? dataValueText,
    TextStyle? errorMessageText,
    TextFieldStyle? inputTextField,
    ButtonComponent? button,
    RippleColor? backButton,
    ButtonComponent? selectorButton,
    SwitchComponent? switchControl,
    Margins? margins,
    ColorState? sdkBackgroundColor,
    ColorState? modalBackgroundColor,
    ColorState? paymentItemBackgroundColor,
    ColorState? selectorIconColor,
    ColorState? savePhoneNumberIconColor}) {
    return CheckoutTheme(
      uiMode: uiMode ?? this.uiMode,
      titleText: titleText ?? this.titleText,
      mainTitleText: mainTitleText ?? this.mainTitleText,
      subtitleText: subtitleText ?? this.subtitleText,
      feesTitleText: feesTitleText ?? this.feesTitleText,
      feesSubtitleText: feesSubtitleText ?? this.feesSubtitleText,
      dataLabelText: dataLabelText ?? this.dataLabelText,
      dataValueText: dataValueText ?? this.dataValueText,
      errorMessageText: errorMessageText ?? this.errorMessageText,
      inputTextField: inputTextField ?? this.inputTextField,
      button: button ?? this.button,
      backButton: backButton ?? this.backButton,
      selectorButton: selectorButton ?? this.selectorButton,
      switchControl: switchControl ?? this.switchControl,
      margins: margins ?? this.margins,
      sdkBackgroundColor: sdkBackgroundColor ?? this.sdkBackgroundColor,
      modalBackgroundColor: modalBackgroundColor ?? this.modalBackgroundColor,
      paymentItemBackgroundColor: paymentItemBackgroundColor ?? this.paymentItemBackgroundColor,
      selectorIconColor: selectorIconColor ?? this.selectorIconColor,
      savePhoneNumberIconColor: savePhoneNumberIconColor ?? this.savePhoneNumberIconColor,
    );
  }

  @override
  List<Object?> get props =>
      [
        uiMode,
        titleText,
        mainTitleText,
        subtitleText,
        feesTitleText,
        feesSubtitleText,
        dataLabelText,
        dataValueText,
        errorMessageText,
        inputTextField,
        button,
        backButton,
        selectorButton,
        switchControl,
        margins,
        sdkBackgroundColor,
        modalBackgroundColor,
        paymentItemBackgroundColor,
        selectorIconColor,
        savePhoneNumberIconColor
      ];

  factory CheckoutTheme.fromJson(Map<String, dynamic> json) => _$CheckoutThemeFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutThemeToJson(this);
}

class _ColorJsonConverter extends JsonConverter<Color, String> {
  const _ColorJsonConverter();

  @override
  Color fromJson(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  String toJson(Color color) {
    return color.toHex();
  }
}

class _UiModeJsonConverter extends JsonConverter<CustomerUiMode, String> {
  const _UiModeJsonConverter();

  @override
  CustomerUiMode fromJson(String uiModeString) => CustomerUiMode.of(uiModeString);

  @override
  String toJson(CustomerUiMode uiMode) => uiMode.name;
}

@JsonSerializable()
final class ColorState {
  @_ColorJsonConverter()
  final Color? color;
  @_ColorJsonConverter()
  final Color? colorDisabled;

  ColorState({this.color, this.colorDisabled});

  ColorState copyWith({Color? color, Color? colorDisabled}) {
    return ColorState(color: color ?? this.color,
        colorDisabled: this.colorDisabled ?? colorDisabled);
  }

  factory ColorState.fromJson(Map<String, dynamic> json) => _$ColorStateFromJson(json);

  Map<String, dynamic> toJson() => _$ColorStateToJson(this);
}

@JsonSerializable()
final class RippleColor {
  @_ColorJsonConverter()
  final Color? color;
  @_ColorJsonConverter()
  final Color? rippleColor;
  @_ColorJsonConverter()
  final Color? colorDisabled;

  RippleColor({this.color, this.rippleColor, this.colorDisabled});

  RippleColor copyWith({Color? color,
    Color? rippleColor,
    Color? colorDisabled}) {
    return RippleColor(
        color: color ?? this.color,
        rippleColor: rippleColor ?? this.rippleColor,
        colorDisabled: colorDisabled ?? this.colorDisabled);
  }

  factory RippleColor.fromJson(Map<String, dynamic> json) => _$RippleColorFromJson(json);

  Map<String, dynamic> toJson() => _$RippleColorToJson(this);


}

@JsonSerializable()
final class TextStyle {
  final ColorState? textColor;
  final int? fontType;

  TextStyle({this.textColor, this.fontType});

  factory TextStyle.fromJson(Map<String, dynamic> json) => _$TextStyleFromJson(json);

  Map<String, dynamic> toJson() => _$TextStyleToJson(this);
}

@JsonSerializable()
final class TextFieldStyle {
  final ColorState? background;
  final ColorState? primaryColor;
  final ColorState? focusedColor;

  final TextStyle? text;
  final TextStyle? error;

  TextFieldStyle({this.background, this.primaryColor, this.focusedColor, this.text, this.error});

  TextFieldStyle copyWith({ColorState? background,
    ColorState? primaryColor,
    ColorState? focusedColor,
    TextStyle? text,
    TextStyle? error}) {
    return TextFieldStyle(
        background: background ?? this.background,
        primaryColor: primaryColor ?? this.primaryColor,
        focusedColor: focusedColor ?? this.focusedColor,
        text: text ?? this.text,
        error: error ?? this.error);
  }

  factory TextFieldStyle.fromJson(Map<String, dynamic> json) => _$TextFieldStyleFromJson(json);

  Map<String, dynamic> toJson() => _$TextFieldStyleToJson(this);
}

@JsonSerializable()
class ButtonComponent {
  final RippleColor? rippleColor;
  final int? fontType;
  final ColorState? textColor;

  ButtonComponent({this.rippleColor, this.fontType, this.textColor});

  ButtonComponent copyWith({RippleColor? rippleColor, int? fontType, ColorState? textColor}) {
    return ButtonComponent(
        rippleColor: rippleColor ?? this.rippleColor,
        textColor: textColor ?? this.textColor,
        fontType: fontType ?? this.fontType);
  }

  factory ButtonComponent.fromJson(Map<String, dynamic> json) => _$ButtonComponentFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonComponentToJson(this);
}

@JsonSerializable()
class SwitchComponent {
  @_ColorJsonConverter()
  final Color? checkedThumbTintColor;
  @_ColorJsonConverter()
  final Color? uncheckedThumbTintColor;
  @_ColorJsonConverter()
  final Color? checkedTrackTintColor;
  @_ColorJsonConverter()
  final Color? uncheckedTrackTintColor;
  @_ColorJsonConverter()
  final Color? checkedTrackDecorationColor;
  @_ColorJsonConverter()
  final Color? uncheckedTrackDecorationColor;

  SwitchComponent({this.checkedThumbTintColor,
    this.uncheckedThumbTintColor,
    this.checkedTrackTintColor,
    this.uncheckedTrackTintColor,
    this.checkedTrackDecorationColor,
    this.uncheckedTrackDecorationColor});

  SwitchComponent copyWith({Color? checkedThumbTintColor,
    Color? uncheckedThumbTintColor,
    Color? checkedTrackTintColor,
    Color? uncheckedTrackTintColor,
    Color? checkedTrackDecorationColor,
    Color? uncheckedTrackDecorationColor}) {
    return SwitchComponent(
        checkedThumbTintColor: checkedThumbTintColor ?? this.checkedThumbTintColor,
        uncheckedThumbTintColor: uncheckedThumbTintColor ?? this.uncheckedThumbTintColor,
        checkedTrackTintColor: checkedTrackTintColor ?? this.checkedTrackTintColor,
        uncheckedTrackTintColor: uncheckedTrackTintColor ?? this.uncheckedTrackTintColor,
        checkedTrackDecorationColor:
        checkedTrackDecorationColor ?? this.checkedTrackDecorationColor,
        uncheckedTrackDecorationColor:
        uncheckedTrackDecorationColor ?? this.uncheckedTrackDecorationColor);
  }

  factory SwitchComponent.fromJson(Map<String, dynamic> json) => _$SwitchComponentFromJson(json);

  Map<String, dynamic> toJson() => _$SwitchComponentToJson(this);
}

@JsonSerializable()
class Margins {
  final int left;
  final int top;
  final int right;
  final int bottom;

  Margins({this.left = 0, this.top = 0, this.right = 0, this.bottom = 0});

  factory Margins.fromJson(Map<String, dynamic> json) => _$MarginsFromJson(json);

  Map<String, dynamic> toJson() => _$MarginsToJson(this);

  @override
  String toString() {
    return '\n   $top\n$left     $right\n   $bottom\n';
  }
}

enum CustomerUiMode {
  auto,
  light,
  dark;

  static CustomerUiMode of(String value) =>
      values.firstWhereOrNull((element) => element.name.toLowerCase() == value) ??
          CustomerUiMode.auto;

  ThemeMode toThemeMode() {
    switch (this) {
      case CustomerUiMode.light:
        return ThemeMode.light;
      case CustomerUiMode.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
