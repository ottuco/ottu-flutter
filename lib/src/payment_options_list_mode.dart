import 'package:json_annotation/json_annotation.dart';

enum PaymentOptionsListMode {
  @JsonValue("list") LIST,
  @JsonValue("bottom_sheet") BOTTOM_SHEET,
}