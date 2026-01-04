import 'package:dio/dio.dart';
import '../error/exceptions.dart';
import '../utils/logger.dart';

/// API client wrapper using Dio
class ApiClient with LoggerMixin {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    Duration? sendTimeout,
    Map<String, String>? headers,
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           connectTimeout: connectTimeout ?? const Duration(seconds: 30),
           receiveTimeout: receiveTimeout ?? const Duration(seconds: 30),
           sendTimeout: sendTimeout ?? const Duration(seconds: 30),
           headers: {'Content-Type': 'application/json', 'Accept': 'application/json', ...?headers},
         ),
       ) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          NetworkLogger.logRequest(
            options.method,
            options.uri.toString(),
            headers: options.headers,
            body: options.data,
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          NetworkLogger.logResponse(
            response.requestOptions.method,
            response.requestOptions.uri.toString(),
            response.statusCode ?? 0,
            body: response.data,
          );
          handler.next(response);
        },
        onError: (error, handler) {
          NetworkLogger.logError(error.requestOptions.method, error.requestOptions.uri.toString(), error);

          final networkException = _handleDioError(error);
          handler.reject(
            DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: networkException,
            ),
          );
        },
      ),
    );
  }

  /// Handles Dio errors and converts them to NetworkException
  NetworkException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('Connection timeout');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return NetworkException('Server error: ${error.response?.statusMessage ?? 'Unknown error'}', statusCode);

      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled');

      case DioExceptionType.connectionError:
        return const NetworkException('No internet connection');

      case DioExceptionType.badCertificate:
        return const NetworkException('Certificate verification failed');

      case DioExceptionType.unknown:
        return NetworkException('Network error: ${error.message}');
    }
  }

  /// GET request
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.put<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.delete<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PATCH request
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.patch<T>(path, data: data, queryParameters: queryParameters, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Downloads a file
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Uploads a file
  Future<Response<T>> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    Options? options,
  }) async {
    try {
      return await _dio.post<T>(path, data: formData, onSendProgress: onSendProgress, options: options);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    if (error.error is AppException) {
      return error.error as AppException;
    }
    return _handleDioError(error);
  }

  /// Closes the client and cleans up resources
  void close() {
    _dio.close();
  }
}
