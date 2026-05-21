import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_endpoints.dart';
import 'dio_intercepotr.dart';

final dioClientProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,  // https://api.lishe.tz — /v1/* is in each path constant
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Content-Type': 'application/json'},
  );
  final dio = Dio(options);
  dio.interceptors.add(DioInterceptor(ref));
  return dio;
});
