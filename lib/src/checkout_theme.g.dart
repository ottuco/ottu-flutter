// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_theme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutTheme _$CheckoutThemeFromJson(Map<String, dynamic> json) =>
    CheckoutTheme(
      uiMode: json['uiMode'] == null
          ? CustomerUiMode.auto
          : const _UiModeJsonConverter().fromJson(json['uiMode'] as String),
      titleText: json['titleText'] == null
          ? null
          : TextStyle.fromJson(json['titleText'] as Map<String, dynamic>),
      mainTitleText: json['mainTitleText'] == null
          ? null
          : TextStyle.fromJson(json['mainTitleText'] as Map<String, dynamic>),
      selectPaymentMethodHeaderText: json['selectPaymentMethodHeaderText'] ==
              null
          ? null
          : TextStyle.fromJson(
              json['selectPaymentMethodHeaderText'] as Map<String, dynamic>),
      subtitleText: json['subtitleText'] == null
          ? null
          : TextStyle.fromJson(json['subtitleText'] as Map<String, dynamic>),
      feesTitleText: json['feesTitleText'] == null
          ? null
          : TextStyle.fromJson(json['feesTitleText'] as Map<String, dynamic>),
      feesSubtitleText: json['feesSubtitleText'] == null
          ? null
          : TextStyle.fromJson(
              json['feesSubtitleText'] as Map<String, dynamic>),
      dataLabelText: json['dataLabelText'] == null
          ? null
          : TextStyle.fromJson(json['dataLabelText'] as Map<String, dynamic>),
      dataValueText: json['dataValueText'] == null
          ? null
          : TextStyle.fromJson(json['dataValueText'] as Map<String, dynamic>),
      errorMessageText: json['errorMessageText'] == null
          ? null
          : TextStyle.fromJson(
              json['errorMessageText'] as Map<String, dynamic>),
      inputTextField: json['inputTextField'] == null
          ? null
          : TextFieldStyle.fromJson(
              json['inputTextField'] as Map<String, dynamic>),
      button: json['button'] == null
          ? null
          : ButtonComponent.fromJson(json['button'] as Map<String, dynamic>),
      backButton: json['backButton'] == null
          ? null
          : RippleColor.fromJson(json['backButton'] as Map<String, dynamic>),
      selectorButton: json['selectorButton'] == null
          ? null
          : ButtonComponent.fromJson(
              json['selectorButton'] as Map<String, dynamic>),
      switchControl: json['switchControl'] == null
          ? null
          : SwitchComponent.fromJson(
              json['switchControl'] as Map<String, dynamic>),
      margins: json['margins'] == null
          ? null
          : Margins.fromJson(json['margins'] as Map<String, dynamic>),
      sdkBackgroundColor: json['sdkBackgroundColor'] == null
          ? null
          : ColorState.fromJson(
              json['sdkBackgroundColor'] as Map<String, dynamic>),
      modalBackgroundColor: json['modalBackgroundColor'] == null
          ? null
          : ColorState.fromJson(
              json['modalBackgroundColor'] as Map<String, dynamic>),
      selectPaymentMethodHeaderBackgroundColor:
          json['selectPaymentMethodHeaderBackgroundColor'] == null
              ? null
              : ColorState.fromJson(
                  json['selectPaymentMethodHeaderBackgroundColor']
                      as Map<String, dynamic>),
      paymentItemBackgroundColor: json['paymentItemBackgroundColor'] == null
          ? null
          : ColorState.fromJson(
              json['paymentItemBackgroundColor'] as Map<String, dynamic>),
      selectorIconColor: json['selectorIconColor'] == null
          ? null
          : ColorState.fromJson(
              json['selectorIconColor'] as Map<String, dynamic>),
      savePhoneNumberIconColor: json['savePhoneNumberIconColor'] == null
          ? null
          : ColorState.fromJson(
              json['savePhoneNumberIconColor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckoutThemeToJson(CheckoutTheme instance) =>
    <String, dynamic>{
      'uiMode': const _UiModeJsonConverter().toJson(instance.uiMode),
      'mainTitleText': instance.mainTitleText,
      'selectPaymentMethodHeaderText': instance.selectPaymentMethodHeaderText,
      'titleText': instance.titleText,
      'subtitleText': instance.subtitleText,
      'feesTitleText': instance.feesTitleText,
      'feesSubtitleText': instance.feesSubtitleText,
      'dataLabelText': instance.dataLabelText,
      'dataValueText': instance.dataValueText,
      'errorMessageText': instance.errorMessageText,
      'inputTextField': instance.inputTextField,
      'button': instance.button,
      'backButton': instance.backButton,
      'selectorButton': instance.selectorButton,
      'switchControl': instance.switchControl,
      'margins': instance.margins,
      'sdkBackgroundColor': instance.sdkBackgroundColor,
      'modalBackgroundColor': instance.modalBackgroundColor,
      'selectPaymentMethodHeaderBackgroundColor':
          instance.selectPaymentMethodHeaderBackgroundColor,
      'paymentItemBackgroundColor': instance.paymentItemBackgroundColor,
      'selectorIconColor': instance.selectorIconColor,
      'savePhoneNumberIconColor': instance.savePhoneNumberIconColor,
    };

ColorState _$ColorStateFromJson(Map<String, dynamic> json) => ColorState(
      color: _$JsonConverterFromJson<String, Color>(
          json['color'], const _ColorJsonConverter().fromJson),
      colorDisabled: _$JsonConverterFromJson<String, Color>(
          json['colorDisabled'], const _ColorJsonConverter().fromJson),
    );

Map<String, dynamic> _$ColorStateToJson(ColorState instance) =>
    <String, dynamic>{
      'color': _$JsonConverterToJson<String, Color>(
          instance.color, const _ColorJsonConverter().toJson),
      'colorDisabled': _$JsonConverterToJson<String, Color>(
          instance.colorDisabled, const _ColorJsonConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

RippleColor _$RippleColorFromJson(Map<String, dynamic> json) => RippleColor(
      color: _$JsonConverterFromJson<String, Color>(
          json['color'], const _ColorJsonConverter().fromJson),
      rippleColor: _$JsonConverterFromJson<String, Color>(
          json['rippleColor'], const _ColorJsonConverter().fromJson),
      colorDisabled: _$JsonConverterFromJson<String, Color>(
          json['colorDisabled'], const _ColorJsonConverter().fromJson),
    );

Map<String, dynamic> _$RippleColorToJson(RippleColor instance) =>
    <String, dynamic>{
      'color': _$JsonConverterToJson<String, Color>(
          instance.color, const _ColorJsonConverter().toJson),
      'rippleColor': _$JsonConverterToJson<String, Color>(
          instance.rippleColor, const _ColorJsonConverter().toJson),
      'colorDisabled': _$JsonConverterToJson<String, Color>(
          instance.colorDisabled, const _ColorJsonConverter().toJson),
    };

TextStyle _$TextStyleFromJson(Map<String, dynamic> json) => TextStyle(
      textColor: json['textColor'] == null
          ? null
          : ColorState.fromJson(json['textColor'] as Map<String, dynamic>),
      fontFamily: json['fontFamily'] as String?,
      fontSize: (json['fontSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TextStyleToJson(TextStyle instance) => <String, dynamic>{
      'textColor': instance.textColor,
      'fontFamily': instance.fontFamily,
      'fontSize': instance.fontSize,
    };

TextFieldStyle _$TextFieldStyleFromJson(Map<String, dynamic> json) =>
    TextFieldStyle(
      background: json['background'] == null
          ? null
          : ColorState.fromJson(json['background'] as Map<String, dynamic>),
      primaryColor: json['primaryColor'] == null
          ? null
          : ColorState.fromJson(json['primaryColor'] as Map<String, dynamic>),
      focusedColor: json['focusedColor'] == null
          ? null
          : ColorState.fromJson(json['focusedColor'] as Map<String, dynamic>),
      text: json['text'] == null
          ? null
          : TextStyle.fromJson(json['text'] as Map<String, dynamic>),
      error: json['error'] == null
          ? null
          : TextStyle.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TextFieldStyleToJson(TextFieldStyle instance) =>
    <String, dynamic>{
      'background': instance.background,
      'primaryColor': instance.primaryColor,
      'focusedColor': instance.focusedColor,
      'text': instance.text,
      'error': instance.error,
    };

ButtonComponent _$ButtonComponentFromJson(Map<String, dynamic> json) =>
    ButtonComponent(
      rippleColor: json['rippleColor'] == null
          ? null
          : RippleColor.fromJson(json['rippleColor'] as Map<String, dynamic>),
      fontType: (json['fontType'] as num?)?.toInt(),
      textColor: json['textColor'] == null
          ? null
          : ColorState.fromJson(json['textColor'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ButtonComponentToJson(ButtonComponent instance) =>
    <String, dynamic>{
      'rippleColor': instance.rippleColor,
      'fontType': instance.fontType,
      'textColor': instance.textColor,
    };

SwitchComponent _$SwitchComponentFromJson(Map<String, dynamic> json) =>
    SwitchComponent(
      checkedThumbTintColor: _$JsonConverterFromJson<String, Color>(
          json['checkedThumbTintColor'], const _ColorJsonConverter().fromJson),
      uncheckedThumbTintColor: _$JsonConverterFromJson<String, Color>(
          json['uncheckedThumbTintColor'],
          const _ColorJsonConverter().fromJson),
      checkedTrackTintColor: _$JsonConverterFromJson<String, Color>(
          json['checkedTrackTintColor'], const _ColorJsonConverter().fromJson),
      uncheckedTrackTintColor: _$JsonConverterFromJson<String, Color>(
          json['uncheckedTrackTintColor'],
          const _ColorJsonConverter().fromJson),
      checkedTrackDecorationColor: _$JsonConverterFromJson<String, Color>(
          json['checkedTrackDecorationColor'],
          const _ColorJsonConverter().fromJson),
      uncheckedTrackDecorationColor: _$JsonConverterFromJson<String, Color>(
          json['uncheckedTrackDecorationColor'],
          const _ColorJsonConverter().fromJson),
    );

Map<String, dynamic> _$SwitchComponentToJson(SwitchComponent instance) =>
    <String, dynamic>{
      'checkedThumbTintColor': _$JsonConverterToJson<String, Color>(
          instance.checkedThumbTintColor, const _ColorJsonConverter().toJson),
      'uncheckedThumbTintColor': _$JsonConverterToJson<String, Color>(
          instance.uncheckedThumbTintColor, const _ColorJsonConverter().toJson),
      'checkedTrackTintColor': _$JsonConverterToJson<String, Color>(
          instance.checkedTrackTintColor, const _ColorJsonConverter().toJson),
      'uncheckedTrackTintColor': _$JsonConverterToJson<String, Color>(
          instance.uncheckedTrackTintColor, const _ColorJsonConverter().toJson),
      'checkedTrackDecorationColor': _$JsonConverterToJson<String, Color>(
          instance.checkedTrackDecorationColor,
          const _ColorJsonConverter().toJson),
      'uncheckedTrackDecorationColor': _$JsonConverterToJson<String, Color>(
          instance.uncheckedTrackDecorationColor,
          const _ColorJsonConverter().toJson),
    };

Margins _$MarginsFromJson(Map<String, dynamic> json) => Margins(
      left: (json['left'] as num?)?.toInt() ?? 0,
      top: (json['top'] as num?)?.toInt() ?? 0,
      right: (json['right'] as num?)?.toInt() ?? 0,
      bottom: (json['bottom'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$MarginsToJson(Margins instance) => <String, dynamic>{
      'left': instance.left,
      'top': instance.top,
      'right': instance.right,
      'bottom': instance.bottom,
    };
