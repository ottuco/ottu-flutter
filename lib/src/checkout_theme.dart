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
  final TextStyle? mainTitle;
  final TextStyle? selectPaymentMethodHeader;
  final TextStyle? title;
  final TextStyle? subtitle;
  final TextStyle? feesTitle;
  final TextStyle? feesSubtitle;
  final TextStyle? dataLabel;
  final TextStyle? dataValue;
  final TextStyle? errorMessage;

  final TextFieldStyle? inputTextField;

  final ButtonComponent? button;
  final RippleColor? backButton;
  final ButtonComponent? selectorButton;
  final SwitchComponent? switchControl;
  final Margins? margins;

  final ColorState? backgroundColor;
  final ColorState? modalBackgroundColor;
  final ColorState? selectPaymentItemTitleBackgroundColor;
  final ColorState? paymentItemBackgroundColor;
  final ColorState? paymentItemDescriptionTextColor;
  final ColorState? paymentItemBorderColor;
  final double? paymentItemBorderWidth;
  final double? paymentItemCornerRadius;
  final ColorState? selectorIconColor;
  final ColorState? savePhoneNumberIconColor;

  CheckoutTheme({
    this.uiMode = CustomerUiMode.auto,
    this.title,
    this.mainTitle,
    this.selectPaymentMethodHeader,
    this.subtitle,
    this.feesTitle,
    this.feesSubtitle,
    this.dataLabel,
    this.dataValue,
    this.errorMessage,
    this.inputTextField,
    this.button,
    this.backButton,
    this.selectorButton,
    this.switchControl,
    this.margins,
    this.backgroundColor,
    this.modalBackgroundColor,
    this.selectPaymentItemTitleBackgroundColor,
    this.paymentItemBackgroundColor,
    this.paymentItemDescriptionTextColor,
    this.paymentItemBorderColor,
    this.paymentItemBorderWidth,
    this.paymentItemCornerRadius,
    this.selectorIconColor,
    this.savePhoneNumberIconColor,
  });

  CheckoutTheme copyWith({
    CustomerUiMode? uiMode,
    TextStyle? titleText,
    TextStyle? mainTitleText,
    TextStyle? selectPaymentMethodHeaderText,
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
    ColorState? selectPaymentMethodHeaderBackgroundColor,
    ColorState? paymentItemBackgroundColor,
    ColorState? paymentItemDescriptionTextColor,
    ColorState? paymentItemBorderColor,
    double? paymentItemBorderWidth,
    double? paymentItemCornerRadius,
    ColorState? selectorIconColor,
    ColorState? savePhoneNumberIconColor,
  }) {
    return CheckoutTheme(
      uiMode: uiMode ?? this.uiMode,
      title: titleText ?? this.title,
      mainTitle: mainTitleText ?? this.mainTitle,
      selectPaymentMethodHeader:
      selectPaymentMethodHeaderText ?? this.selectPaymentMethodHeader,
      subtitle: subtitleText ?? this.subtitle,
      feesTitle: feesTitleText ?? this.feesTitle,
      feesSubtitle: feesSubtitleText ?? this.feesSubtitle,
      dataLabel: dataLabelText ?? this.dataLabel,
      dataValue: dataValueText ?? this.dataValue,
      errorMessage: errorMessageText ?? this.errorMessage,
      inputTextField: inputTextField ?? this.inputTextField,
      button: button ?? this.button,
      backButton: backButton ?? this.backButton,
      selectorButton: selectorButton ?? this.selectorButton,
      switchControl: switchControl ?? this.switchControl,
      margins: margins ?? this.margins,
      backgroundColor: sdkBackgroundColor ?? this.backgroundColor,
      modalBackgroundColor: modalBackgroundColor ?? this.modalBackgroundColor,
      selectPaymentItemTitleBackgroundColor:
      selectPaymentMethodHeaderBackgroundColor ?? this.selectPaymentItemTitleBackgroundColor,
      paymentItemBackgroundColor: paymentItemBackgroundColor ?? this.paymentItemBackgroundColor,
      paymentItemDescriptionTextColor:
      paymentItemDescriptionTextColor ?? this.paymentItemDescriptionTextColor,
      paymentItemBorderColor: paymentItemBorderColor ?? this.paymentItemBorderColor,
      paymentItemBorderWidth: paymentItemBorderWidth ?? this.paymentItemBorderWidth,
      paymentItemCornerRadius: paymentItemCornerRadius ?? this.paymentItemCornerRadius,
      selectorIconColor: selectorIconColor ?? this.selectorIconColor,
      savePhoneNumberIconColor: savePhoneNumberIconColor ?? this.savePhoneNumberIconColor,
    );
  }

  @override
  List<Object?> get props =>
      [
        uiMode,
        title,
        mainTitle,
        selectPaymentMethodHeader,
        subtitle,
        feesTitle,
        feesSubtitle,
        dataLabel,
        dataValue,
        errorMessage,
        inputTextField,
        button,
        backButton,
        selectorButton,
        switchControl,
        margins,
        backgroundColor,
        modalBackgroundColor,
        selectPaymentItemTitleBackgroundColor,
        paymentItemBackgroundColor,
        paymentItemDescriptionTextColor,
        paymentItemBorderColor,
        paymentItemBorderWidth,
        paymentItemCornerRadius,
        selectorIconColor,
        savePhoneNumberIconColor,
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
    return ColorState(
      color: color ?? this.color,
      colorDisabled: this.colorDisabled ?? colorDisabled,
    );
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

  RippleColor copyWith({Color? color, Color? rippleColor, Color? colorDisabled}) {
    return RippleColor(
      color: color ?? this.color,
      rippleColor: rippleColor ?? this.rippleColor,
      colorDisabled: colorDisabled ?? this.colorDisabled,
    );
  }

  factory RippleColor.fromJson(Map<String, dynamic> json) => _$RippleColorFromJson(json);

  Map<String, dynamic> toJson() => _$RippleColorToJson(this);
}

@JsonSerializable()
final class TextStyle {
  final ColorState? textColor;
  final String? fontFamily;
  final int? fontSize;

  TextStyle({this.textColor, this.fontFamily, this.fontSize});

  factory TextStyle.fromJson(Map<String, dynamic> json) => _$TextStyleFromJson(json);

  Map<String, dynamic> toJson() => _$TextStyleToJson(this);

  TextStyle copyWith({ColorState? textColor, String? fontFamily, int? fontSize}) =>
      TextStyle(
        textColor: textColor ?? this.textColor,
        fontFamily: fontFamily ?? this.fontFamily,
        fontSize: fontSize ?? this.fontSize,
      );
}

@JsonSerializable()
final class TextFieldStyle {
  final ColorState? background;
  final ColorState? primaryColor;
  final ColorState? focusedColor;

  final TextStyle? text;
  final TextStyle? error;

  TextFieldStyle({this.background, this.primaryColor, this.focusedColor, this.text, this.error});

  TextFieldStyle copyWith({
    ColorState? background,
    ColorState? primaryColor,
    ColorState? focusedColor,
    TextStyle? text,
    TextStyle? error,
  }) {
    return TextFieldStyle(
      background: background ?? this.background,
      primaryColor: primaryColor ?? this.primaryColor,
      focusedColor: focusedColor ?? this.focusedColor,
      text: text ?? this.text,
      error: error ?? this.error,
    );
  }

  factory TextFieldStyle.fromJson(Map<String, dynamic> json) => _$TextFieldStyleFromJson(json);

  Map<String, dynamic> toJson() => _$TextFieldStyleToJson(this);
}

@JsonSerializable()
class ButtonComponent {
  final RippleColor? rippleColor;
  final String? fontFamily;
  final ColorState? textColor;
  final ColorState? borderColor;
  final double? borderWidth;
  final double? cornerRadius;

  ButtonComponent({
    this.rippleColor,
    this.fontFamily,
    this.textColor,
    this.borderColor,
    this.borderWidth,
    this.cornerRadius,
  });

  ButtonComponent copyWith({
    RippleColor? rippleColor,
    String? fontFamily,
    ColorState? textColor,
    ColorState? borderColor,
    double? borderWidth,
    double? cornerRadius,
  }) {
    return ButtonComponent(
      rippleColor: rippleColor ?? this.rippleColor,
      textColor: textColor ?? this.textColor,
      fontFamily: fontFamily ?? this.fontFamily,
      borderColor: borderColor ?? this.borderColor,
      borderWidth: borderWidth ?? this.borderWidth,
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
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

  SwitchComponent({
    this.checkedThumbTintColor,
    this.uncheckedThumbTintColor,
    this.checkedTrackTintColor,
    this.uncheckedTrackTintColor,
    this.checkedTrackDecorationColor,
    this.uncheckedTrackDecorationColor,
  });

  SwitchComponent copyWith({
    Color? checkedThumbTintColor,
    Color? uncheckedThumbTintColor,
    Color? checkedTrackTintColor,
    Color? uncheckedTrackTintColor,
    Color? checkedTrackDecorationColor,
    Color? uncheckedTrackDecorationColor,
  }) {
    return SwitchComponent(
      checkedThumbTintColor: checkedThumbTintColor ?? this.checkedThumbTintColor,
      uncheckedThumbTintColor: uncheckedThumbTintColor ?? this.uncheckedThumbTintColor,
      checkedTrackTintColor: checkedTrackTintColor ?? this.checkedTrackTintColor,
      uncheckedTrackTintColor: uncheckedTrackTintColor ?? this.uncheckedTrackTintColor,
      checkedTrackDecorationColor: checkedTrackDecorationColor ?? this.checkedTrackDecorationColor,
      uncheckedTrackDecorationColor:
      uncheckedTrackDecorationColor ?? this.uncheckedTrackDecorationColor,
    );
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
