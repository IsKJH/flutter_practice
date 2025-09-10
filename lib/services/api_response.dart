class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;
  final String? error;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.error,
  });

  factory ApiResponse.success({
    required T data,
    String message = 'Success',
    int? statusCode,
  }) {
    return ApiResponse(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    String? error,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      statusCode: statusCode,
      error: error,
    );
  }
}