import 'package:ottu_flutter_checkout_sample/api/model/create_transaction_request.dart';
import 'package:ottu_flutter_checkout_sample/api/model/result.dart';
import 'package:ottu_flutter_checkout_sample/api/model/session_response.dart';

abstract interface class OttuApi {
  Future<Result<SessionResponse>> getSessionId({
    required String merchantId,
    required CreateTransactionRequest request,
    required String apiKey,
    required String language,
  });
}
