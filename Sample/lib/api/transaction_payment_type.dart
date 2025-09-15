import 'package:json_annotation/json_annotation.dart';

@JsonEnum()
enum TransactionPaymentType {
  @JsonValue('one_off')
  oneOff,
  @JsonValue('auto_debit')
  autoDebit,
  @JsonValue('save_card')
  saveCard;
}
