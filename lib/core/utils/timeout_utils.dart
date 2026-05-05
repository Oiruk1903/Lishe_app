import 'dart:async';
import 'package:flutter/foundation.dart';

class TimeoutUtils {
  static const Duration minTimeout = Duration(seconds: 20);
  static const Duration maxTimeout = Duration(seconds: 50);
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Execute a future with timeout
  static Future<T> withTimeout<T>(
    Future<T> future, {
    Duration? timeout,
    String? operation,
  }) {
    final effectiveTimeout = timeout ?? defaultTimeout;

    return future.timeout(
      effectiveTimeout,
      onTimeout: () {
        debugPrint(
            'Operation "${operation ?? 'Unknown'}" timed out after ${effectiveTimeout.inSeconds}s');
        throw TimeoutException(
          'Operation "${operation ?? 'Unknown'}" timed out after ${effectiveTimeout.inSeconds}s',
          effectiveTimeout,
        );
      },
    );
  }

  /// Execute a future with timeout and fallback value
  static Future<T?> withTimeoutAndFallback<T>(
    Future<T> future, {
    Duration? timeout,
    T? fallback,
    String? operation,
  }) async {
    try {
      return await withTimeout<T>(future,
          timeout: timeout, operation: operation);
    } catch (e) {
      debugPrint('Operation "${operation ?? 'Unknown'}" failed: $e');
      return fallback;
    }
  }

  /// Create a timeout for authentication operations (shorter timeout)
  static Duration get authTimeout => const Duration(seconds: 20);

  /// Create a timeout for database operations (medium timeout)
  static Duration get databaseTimeout => const Duration(seconds: 30);

  /// Create a timeout for network operations (longer timeout)
  static Duration get networkTimeout => const Duration(seconds: 50);

  /// Execute a future with timeout and fallback value (non-nullable return)
  static Future<T> withTimeoutAndFallbackNonNull<T>(
    Future<T> future, {
    Duration? timeout,
    required T fallback,
    String? operation,
  }) async {
    try {
      return await withTimeout<T>(future,
          timeout: timeout, operation: operation);
    } catch (e) {
      debugPrint('Operation "${operation ?? 'Unknown'}" failed: $e');
      return fallback;
    }
  }
}
