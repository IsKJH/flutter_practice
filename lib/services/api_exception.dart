import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? error;

  ApiException({
    required this.message,
    this.statusCode,
    this.error,
  });

  factory ApiException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: "연결 시간이 초과되었습니다",
          statusCode: dioError.response?.statusCode,
          error: "CONNECTION_TIMEOUT",
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: "요청 전송 시간이 초과되었습니다",
          statusCode: dioError.response?.statusCode,
          error: "SEND_TIMEOUT",
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "응답 수신 시간이 초과되었습니다",
          statusCode: dioError.response?.statusCode,
          error: "RECEIVE_TIMEOUT",
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: _getErrorMessage(dioError.response?.statusCode),
          statusCode: dioError.response?.statusCode,
          error: "BAD_RESPONSE",
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: "요청이 취소되었습니다",
          error: "REQUEST_CANCELLED",
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: "인터넷 연결을 확인해주세요",
          error: "CONNECTION_ERROR",
        );
      default:
        return ApiException(
          message: "알 수 없는 오류가 발생했습니다",
          error: "UNKNOWN_ERROR",
        );
    }
  }

  static String _getErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "잘못된 요청입니다";
      case 401:
        return "인증이 필요합니다";
      case 403:
        return "접근 권한이 없습니다";
      case 404:
        return "요청한 리소스를 찾을 수 없습니다";
      case 408:
        return "요청 시간이 초과되었습니다";
      case 429:
        return "너무 많은 요청을 보냈습니다";
      case 500:
        return "서버 내부 오류가 발생했습니다";
      case 502:
        return "게이트웨이 오류가 발생했습니다";
      case 503:
        return "서비스를 사용할 수 없습니다";
      case 504:
        return "게이트웨이 시간 초과가 발생했습니다";
      default:
        return "서버 오류가 발생했습니다 (코드: $statusCode)";
    }
  }

  @override
  String toString() {
    return 'ApiException: $message (StatusCode: $statusCode, Error: $error)';
  }
}