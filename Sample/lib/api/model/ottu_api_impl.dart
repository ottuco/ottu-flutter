import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:ottu_flutter_checkout_sample/api/model/create_transaction_request.dart';
import 'package:ottu_flutter_checkout_sample/api/model/result.dart';
import 'package:ottu_flutter_checkout_sample/api/model/session_response.dart';
import 'package:ottu_flutter_checkout_sample/api/ottu_api.dart';

const _tag = "OttuApiImpl";

final class OttuApiImpl implements OttuApi {
  final Dio _dio = Dio();
  final _logger = Logger();

  OttuApiImpl() {
    _dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
  }

  @override
  Future<Result<SessionResponse>> getSessionId({
    required String merchantId,
    required CreateTransactionRequest request,
    required String apiKey,
    required String language,
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
        return Result.error(NothingFound());
      }
    } on DioException catch (e) {
      if (e.response != null) {
        _logger.e("getSessionId, error ${e.response?.data}", error: e);
        print(
          "getSessionId, error ${e.response?.headers}\nData:${e.response?.data}\noptions: ${e.response?.requestOptions}",
        );
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        _logger.e("getSessionId, logger error ${e.message}", error: e);
        print("getSessionId, error no response ${e.requestOptions}\nmessage: ${e.message}");
      }

      return Result.error(e);
    } on Exception catch (ex) {
      _logger.e("getSessionId, error", error: ex);
      return Result.error(ex);
    }
  }
}

class NothingFound implements Exception {}
