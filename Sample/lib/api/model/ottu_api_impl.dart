import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout_sample/api/model/api_error.dart';
import 'package:ottu_flutter_checkout_sample/api/model/create_transaction_request.dart';
import 'package:ottu_flutter_checkout_sample/api/model/result.dart';
import 'package:ottu_flutter_checkout_sample/api/model/session_response.dart';
import 'package:ottu_flutter_checkout_sample/api/ottu_api.dart';

final class OttuApiImpl implements OttuApi {
  final Dio _dio = Dio();
  final _logger = Logger();

  OttuApiImpl() {
    _dio.interceptors.add(
      LogInterceptor(responseBody: false, requestBody: false),
    );
  }

  @override
  Future<Result<SessionResponse>> getSessionId({
    required String merchantId,
    required String apiKey,
    required String language,
    required CreateTransactionRequest request,
  }) async {
    try {
      final response = await _dio.post(
        'https://$merchantId/b/checkout/v1/pymt-txn',
        data: request.toJson(),
        options: Options(
          headers: {
            Headers.contentTypeHeader: Headers.jsonContentType,
            "Authorization": "Api-Key $apiKey",
            "Accept-Language": language,
          },
        ),
      );

      if (response.data != null) {
        final sessionResponse = SessionResponse.fromJson(response.data);

        return Result.ok(sessionResponse);
      } else {
        return Result.error(const EmptySessionResponseError());
      }
    } on DioException catch (e) {
      final error = ApiError.fromDioException(e);
      _logger.e("getSessionId failed: ${error.message}", error: e);
      return Result.error(error);
    } on Exception catch (ex) {
      _logger.e("getSessionId, error", error: ex);
      return Result.error(ex);
    }
  }
}
