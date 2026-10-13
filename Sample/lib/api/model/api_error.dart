import 'package:dio/dio.dart';

sealed class ApiError implements Exception {
  const ApiError(this.message);

  final String message;

  static ApiError fromDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseMessage = _responseMessage(error.response?.data);
    if (statusCode != null) {
      return ApiResponseError(
        statusCode: statusCode,
        message:
            responseMessage ??
            'Session request failed with status code $statusCode.',
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiNetworkError(
          'The request timed out. Check your connection and try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiNetworkError(
          'Unable to reach the merchant host. Check the host and connection.',
        );
      case DioExceptionType.cancel:
        return const ApiNetworkError('The session request was cancelled.');
      case DioExceptionType.badCertificate:
        return const ApiNetworkError(
          'The merchant host returned an invalid certificate.',
        );
      case DioExceptionType.badResponse:
      case DioExceptionType.unknown:
        return ApiNetworkError(
          error.message ?? 'Unable to create a checkout session.',
        );
    }
  }

  static String? _responseMessage(Object? data) {
    if (data is Map) {
      final detail = data['detail'] ?? data['message'] ?? data['error'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail;
      }
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }

  @override
  String toString() => message;
}

final class ApiResponseError extends ApiError {
  const ApiResponseError({required this.statusCode, required String message})
    : super(message);

  final int statusCode;
}

final class ApiNetworkError extends ApiError {
  const ApiNetworkError(super.message);
}

final class EmptySessionResponseError extends ApiError {
  const EmptySessionResponseError()
    : super('The merchant returned an empty session response.');
}
