import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../services/api_response.dart';
import '../services/api_exception.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio _dio;

  // Base URL - 환경에 따라 변경
  static const String _baseUrl = 'https://your-api-base-url.com/api';

  factory ApiClient() => _instance;

  ApiClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // 토큰이 필요한 경우 여기서 추가
        // final token = await _getAuthToken();
        // if (token != null) {
        //   options.headers['Authorization'] = 'Bearer $token';
        // }

        if (kDebugMode) {
          print('🔵 REQUEST[${options.method}] => PATH: ${options.path}');
          print('🔵 Headers: ${options.headers}');
          if (options.data != null) {
            print('🔵 Data: ${options.data}');
          }
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          print(
              '🟢 RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          print('🟢 Data: ${response.data}');
        }
        handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          print(
              '🔴 ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          print('🔴 Message: ${error.message}');
        }
        handler.next(error);
      },
    ));
  }

  // GET 요청
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      T? data;
      if (fromJson != null && response.data != null) {
        data = fromJson(response.data);
      } else {
        data = response.data;
      }

      return ApiResponse.success(
        data: data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        error: apiException.error,
      );
    } catch (e) {
      return ApiResponse.error(
        message: '알 수 없는 오류가 발생했습니다',
        error: e.toString(),
      );
    }
  }

  // POST 요청
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      T? responseData;
      if (fromJson != null && response.data != null) {
        responseData = fromJson(response.data);
      } else {
        responseData = response.data;
      }

      return ApiResponse.success(
        data: responseData as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        error: apiException.error,
      );
    } catch (e) {
      return ApiResponse.error(
        message: '알 수 없는 오류가 발생했습니다',
        error: e.toString(),
      );
    }
  }

  // PUT 요청
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      T? responseData;
      if (fromJson != null && response.data != null) {
        responseData = fromJson(response.data);
      } else {
        responseData = response.data;
      }

      return ApiResponse.success(
        data: responseData as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        error: apiException.error,
      );
    } catch (e) {
      return ApiResponse.error(
        message: '알 수 없는 오류가 발생했습니다',
        error: e.toString(),
      );
    }
  }

  // DELETE 요청
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      T? responseData;
      if (fromJson != null && response.data != null) {
        responseData = fromJson(response.data);
      } else {
        responseData = response.data;
      }

      return ApiResponse.success(
        data: responseData as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        error: apiException.error,
      );
    } catch (e) {
      return ApiResponse.error(
        message: '알 수 없는 오류가 발생했습니다',
        error: e.toString(),
      );
    }
  }

  // 파일 업로드
  Future<ApiResponse<T>> uploadFile<T>(
    String path,
    FormData formData, {
    Options? options,
    ProgressCallback? onSendProgress,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: formData,
        options: options,
        onSendProgress: onSendProgress,
      );

      T? data;
      if (fromJson != null && response.data != null) {
        data = fromJson(response.data);
      } else {
        data = response.data;
      }

      return ApiResponse.success(
        data: data as T,
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        error: apiException.error,
      );
    } catch (e) {
      return ApiResponse.error(
        message: '알 수 없는 오류가 발생했습니다',
        error: e.toString(),
      );
    }
  }

  // 파일 다운로드
  Future<ApiResponse<String>> downloadFile(
    String path,
    String savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      await _dio.download(
        path,
        savePath,
        queryParameters: queryParameters,
        options: options,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse.success(
        data: savePath,
        message: '파일 다운로드가 완료되었습니다',
      );
    } on DioException catch (e) {
      final apiException = ApiException.fromDioError(e);
      return ApiResponse.error(
        message: apiException.message,
        statusCode: apiException.statusCode,
        error: apiException.error,
      );
    } catch (e) {
      return ApiResponse.error(
        message: '파일 다운로드 중 오류가 발생했습니다',
        error: e.toString(),
      );
    }
  }

  // 토큰 설정 (로그인 후 호출)
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // 토큰 제거 (로그아웃 시 호출)
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Base URL 변경
  void setBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  // Dio 인스턴스 직접 접근 (고급 사용자용)
  Dio get dio => _dio;
}
