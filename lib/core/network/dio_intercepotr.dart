import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import 'api_endpoints.dart';

class DioInterceptor extends Interceptor {
  final Ref _ref;

  // Serializes concurrent refresh attempts — only one refresh call runs at a time.
  static Completer<String?>? _refreshCompleter;

  DioInterceptor(this._ref);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final localStorage = _ref.read(localStorageServiceProvider);
      final token = await localStorage.getAuthToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {}

    options.headers['Accept-Language'] = 'sw';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    // Don't retry the refresh endpoint itself — would loop.
    if (err.requestOptions.path == ApiEndpoints.refresh) {
      await _clearAuth();
      handler.next(err);
      return;
    }

    // If a refresh is already in progress, wait for it then retry.
    if (_refreshCompleter != null) {
      final newToken = await _refreshCompleter!.future;
      if (newToken != null) {
        handler.resolve(await _retry(err.requestOptions, newToken));
      } else {
        handler.next(err);
      }
      return;
    }

    _refreshCompleter = Completer<String?>();
    try {
      final newToken = await _doRefresh();
      _refreshCompleter!.complete(newToken);

      if (newToken != null) {
        handler.resolve(await _retry(err.requestOptions, newToken));
      } else {
        handler.next(err);
      }
    } catch (e) {
      _refreshCompleter!.complete(null);
      handler.next(err);
    } finally {
      _refreshCompleter = null;
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  Future<String?> _doRefresh() async {
    try {
      final localStorage = _ref.read(localStorageServiceProvider);
      final refreshToken = await localStorage.getRefreshToken();
      if (refreshToken == null) {
        await _clearAuth();
        return null;
      }

      // Use a separate Dio instance to bypass this interceptor.
      final refreshDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
      final response = await refreshDio.post(
        ApiEndpoints.refresh,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data['data'] as Map<String, dynamic>;
      final newAccessToken = data['token'] as String;
      final newRefreshToken = data['refresh_token'] as String?;

      await localStorage.saveAuthToken(newAccessToken);
      if (newRefreshToken != null) {
        await localStorage.saveRefreshToken(newRefreshToken);
      }

      return newAccessToken;
    } catch (_) {
      await _clearAuth();
      return null;
    }
  }

  Future<Response> _retry(RequestOptions options, String token) {
    final retryDio = Dio(BaseOptions(baseUrl: ApiEndpoints.baseUrl));
    return retryDio.request(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {
          ...options.headers,
          'Authorization': 'Bearer $token',
        },
      ),
    );
  }

  Future<void> _clearAuth() async {
    try {
      final localStorage = _ref.read(localStorageServiceProvider);
      await localStorage.clearAuthData();
    } catch (_) {}
  }
}
