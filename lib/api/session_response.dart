import 'package:json_annotation/json_annotation.dart';
import 'package:ottu_flutter_checkout_sample/api/api_transaction_details.dart';

part 'session_response.g.dart';

@JsonSerializable(createToJson: false)
class SessionResponse {
  @JsonKey(name: "session_id")
  final String sessionId;
  @JsonKey(name: "sdk_setup_preload_payload")
  final ApiTransactionDetails? transactionDetails;

  SessionResponse(this.sessionId, this.transactionDetails);

  factory SessionResponse.fromJson(Map<String, dynamic> json) =>
      _$SessionResponseFromJson(json);
}
