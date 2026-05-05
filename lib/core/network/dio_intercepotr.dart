import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';

class DioInterceptor extends Interceptor {
  final Ref _ref;

  DioInterceptor(this._ref);

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add auth token (mock implementation for simplified setup)
    try {
      final localStorage = _ref.read(localStorageServiceProvider);
      final token = await localStorage.getAuthToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      // LocalStorageService not available, continue without auth
    }

    // Add default language header
    options.headers['Accept-Language'] = 'sw';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Token expired or invalid - clear auth data
      try {
        final localStorage = _ref.read(localStorageServiceProvider);
        await localStorage.clearAuthData();
      } catch (e) {
        // LocalStorageService not available
      }
    }

    handler.next(err);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Log response (only in debug mode)
    handler.next(response);
  }
}
