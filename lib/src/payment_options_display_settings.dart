import 'package:json_annotation/json_annotation.dart';
import 'package:ottu_flutter_checkout/src/payment_options_display_mode.dart';

part 'payment_options_display_settings.g.dart';

@JsonSerializable()
class PaymentOptionsDisplaySettings {
  final PaymentOptionsDisplayMode mode;
  final String? defaultSelectedPgCode;
  final int visibleItemsCount;

  PaymentOptionsDisplaySettings(
      {required this.mode, this.defaultSelectedPgCode, required this.visibleItemsCount});

  factory PaymentOptionsDisplaySettings.fromJson(Map<String, dynamic> json) =>
      _$PaymentOptionsDisplaySettingsFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentOptionsDisplaySettingsToJson(this);
}
