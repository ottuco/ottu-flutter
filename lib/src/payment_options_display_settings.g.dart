// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_options_display_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentOptionsDisplaySettings _$PaymentOptionsDisplaySettingsFromJson(
        Map<String, dynamic> json) =>
    PaymentOptionsDisplaySettings(
      mode: $enumDecode(_$PaymentOptionsDisplayModeEnumMap, json['mode']),
      defaultSelectedPgCode: json['defaultSelectedPgCode'] as String?,
      visibleItemsCount: (json['visibleItemsCount'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentOptionsDisplaySettingsToJson(
        PaymentOptionsDisplaySettings instance) =>
    <String, dynamic>{
      'mode': _$PaymentOptionsDisplayModeEnumMap[instance.mode]!,
      'defaultSelectedPgCode': instance.defaultSelectedPgCode,
      'visibleItemsCount': instance.visibleItemsCount,
    };

const _$PaymentOptionsDisplayModeEnumMap = {
  PaymentOptionsDisplayMode.LIST: 'list',
  PaymentOptionsDisplayMode.BOTTOM_SHEET: 'bottom_sheet',
};
