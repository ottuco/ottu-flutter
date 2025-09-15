// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_agreement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionAgreement _$TransactionAgreementFromJson(
        Map<String, dynamic> json) =>
    TransactionAgreement(
      id: json['id'] as String,
      amountVariability: json['amount_variability'] as String?,
      expiryDate: json['expiry_date'] as String?,
      cycleIntervalDays: (json['cycle_interval_days'] as num?)?.toInt(),
      frequency: json['frequency'] as String?,
      totalCycles: (json['total_cycles'] as num?)?.toInt(),
      type: json['type'] as String?,
    );

Map<String, dynamic> _$TransactionAgreementToJson(
        TransactionAgreement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount_variability': instance.amountVariability,
      'expiry_date': instance.expiryDate,
      'cycle_interval_days': instance.cycleIntervalDays,
      'frequency': instance.frequency,
      'total_cycles': instance.totalCycles,
      'type': instance.type,
    };
