// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionResponse _$SessionResponseFromJson(Map<String, dynamic> json) =>
    SessionResponse(
      json['session_id'] as String,
      json['sdk_setup_preload_payload'] == null
          ? null
          : ApiTransactionDetails.fromJson(
              json['sdk_setup_preload_payload'] as Map<String, dynamic>),
    );