import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'session_response.g.dart';

@JsonSerializable(createToJson: false)
class SessionResponse {
  @JsonKey(name: "session_id")
  final String sessionId;
  @JsonKey(name: "sdk_setup_preload_payload", readValue: readValue)
  final String? transactionDetails;

  SessionResponse(this.sessionId, this.transactionDetails);

  factory SessionResponse.fromJson(Map<String, dynamic> json) => _$SessionResponseFromJson(json);

  static String? readValue(Map map, String key) {
    dynamic field = map[key];
    if (field is Map) {
      String jsonString = json.encode(field);
      return jsonString;
    } else {
      return null;
    }
  }
}
