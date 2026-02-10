import 'package:json_annotation/json_annotation.dart';
part 'pay_button_text.g.dart';

/**
 * Data class holds localization for the PayButton
 */
@JsonSerializable()
final class PayButtonText {
  final String en;
  final String ar;

  PayButtonText({required this.en, required this.ar});

  factory PayButtonText.fromJson(Map<String, dynamic> json) =>
      _$PayButtonTextFromJson(json);

  Map<String, dynamic> toJson() => _$PayButtonTextToJson(this);
}
/*
  extention Language on PayButtonText {
  forLanguage(String language) =
switch (language) {
case "en" : en;
case "ar" : ar;
}
}*/
