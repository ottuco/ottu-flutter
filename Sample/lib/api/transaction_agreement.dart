import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_agreement.g.dart';

@JsonSerializable()
final class TransactionAgreement {
  final String id;
  @JsonKey(name: "amount_variability")
  final String? amountVariability;
  @JsonKey(name: "expiry_date")
  final String? expiryDate;
  @JsonKey(name: "cycle_interval_days")
  final int? cycleIntervalDays;
  final String? frequency;
  @JsonKey(name: "total_cycles")
  final int? totalCycles;
  final String? type;

  TransactionAgreement(
      {required this.id,
      this.amountVariability,
      this.expiryDate,
      this.cycleIntervalDays,
      this.frequency,
      this.totalCycles,
      this.type});

  factory TransactionAgreement.fromJson(Map<String, dynamic> json) =>
      _$TransactionAgreementFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionAgreementToJson(this);

  factory TransactionAgreement.defaultAgreement() {
    final DateTime now = DateTime.now();
    final String timeStamp = DateFormat('dd_mm_yyyy_hh_mm_ss').format(now);
    return TransactionAgreement(
      id: timeStamp,
      amountVariability: "fixed",
      expiryDate: "11/12/2100",
      cycleIntervalDays: 3,
      frequency: "monthly",
      totalCycles: 999,
      type: "recurring",
    );
  }
}
