import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'cache_service.dart';

/// Performance monitoring service for tracking app metrics
class PerformanceMonitoringService {
  static final PerformanceMonitoringService _instance =
      PerformanceMonitoringService._internal();
  factory PerformanceMonitoringService() => _instance;
  PerformanceMonitoringService._internal();

  final CacheService _cacheService = CacheService();
  final Map<String, Stopwatch> _timers = {};
  final Map<String, List<int>> _metrics = {};
  final Map<String, int> _counters = {};

  static const String _metricsPrefix = 'perf_metrics_';
  static const String _countersPrefix = 'perf_counters_';

  /// Start timing an operation
  void startTimer(String operation) {
    _timers[operation] = Stopwatch()..start();
  }

  /// End timing an operation and record the duration
  void endTimer(String operation) {
    final timer = _timers[operation];
    if (timer != null && timer.isRunning) {
      timer.stop();
      final duration = timer.elapsedMilliseconds;

      _recordMetric('${operation}_duration', duration);

      if (kDebugMode) {
        developer.log('Performance: $operation took ${duration}ms');
      }

      _timers.remove(operation);
    }
  }

  /// Record a metric value
  void recordMetric(String name, int value) {
    _recordMetric(name, value);
  }

  /// Increment a counter
  void incrementCounter(String name, {int increment = 1}) {
    _counters[name] = (_counters[name] ?? 0) + increment;
    _saveCounter(name);
  }

  /// Record app startup time
  void recordStartupTime(Duration startupTime) {
    recordMetric('app_startup_time', startupTime.inMilliseconds);
  }

  /// Record feature loading time
  void recordFeatureLoadTime(String feature, Duration loadTime) {
    recordMetric('${feature}_load_time', loadTime.inMilliseconds);
  }

  /// Record cache hit/miss
  void recordCacheHit(String cacheKey, bool isHit) {
    incrementCounter('${cacheKey}_cache_${isHit ? 'hits' : 'misses'}');
  }

  /// Record memory usage
  Future<void> recordMemoryUsage() async {
    try {
      // MemoryPressure is not available in Flutter, so we'll skip this for now
      // In a real implementation, you might use device_info_plus or similar
      recordMetric(
          'memory_check_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error getting memory usage: $e');
      }
    }
  }

  /// Get performance metrics for a specific operation
  Map<String, dynamic> getMetricsForOperation(String operation) {
    final metrics = <String, dynamic>{};

    // Duration metrics
    final durationKey = '${operation}_duration';
    final durations = _metrics[durationKey] ?? [];
    if (durations.isNotEmpty) {
      metrics['averageDuration'] =
          durations.reduce((a, b) => a + b) / durations.length;
      metrics['minDuration'] = durations.reduce((a, b) => a < b ? a : b);
      metrics['maxDuration'] = durations.reduce((a, b) => a > b ? a : b);
      metrics['totalOperations'] = durations.length;
    }

    // Cache metrics
    final hits = _counters['${operation}_cache_hits'] ?? 0;
    final misses = _counters['${operation}_cache_misses'] ?? 0;
    final total = hits + misses;

    if (total > 0) {
      metrics['cacheHitRate'] = hits / total;
      metrics['cacheHits'] = hits;
      metrics['cacheMisses'] = misses;
    }

    return metrics;
  }

  /// Get all performance metrics
  Map<String, dynamic> getAllMetrics() {
    final allMetrics = <String, dynamic>{};

    // Collect all operation metrics
    final operations =
        _metrics.keys.map((key) => key.replaceAll('_duration', '')).toSet();

    for (final operation in operations) {
      allMetrics[operation] = getMetricsForOperation(operation);
    }

    // Add global metrics
    allMetrics['counters'] = Map.from(_counters);
    allMetrics['lastUpdated'] = DateTime.now().toIso8601String();

    return allMetrics;
  }

  /// Get performance summary
  Map<String, dynamic> getPerformanceSummary() {
    final summary = <String, dynamic>{};

    // App startup metrics
    final startupTimes = _metrics['app_startup_time'] ?? [];
    if (startupTimes.isNotEmpty) {
      summary['startupTime'] = startupTimes.last;
      summary['averageStartupTime'] =
          startupTimes.reduce((a, b) => a + b) / startupTimes.length;
    }

    // Feature loading metrics
    final features = <Map<String, dynamic>>[];
    for (final key in _metrics.keys) {
      if (key.endsWith('_load_time')) {
        final feature = key.replaceAll('_load_time', '');
        final times = _metrics[key] ?? [];
        if (times.isNotEmpty) {
          features.add({
            'name': feature,
            'averageLoadTime': times.reduce((a, b) => a + b) / times.length,
            'lastLoadTime': times.last,
            'loadCount': times.length,
          });
        }
      }
    }

    summary['features'] = features;

    // Cache performance
    final cacheMetrics = <String, dynamic>{};
    for (final key in _counters.keys) {
      if (key.contains('cache_')) {
        cacheMetrics[key] = _counters[key];
      }
    }
    summary['cachePerformance'] = cacheMetrics;

    return summary;
  }

  /// Clear all metrics
  void clearMetrics() {
    _timers.clear();
    _metrics.clear();
    _counters.clear();
  }

  /// Export metrics to JSON
  String exportMetrics() {
    final metrics = getAllMetrics();
    return _encodeJson(metrics);
  }

  /// Load metrics from cache
  Future<void> loadPersistedMetrics() async {
    try {
      // Load metrics summary
      final summary = await _cacheService.get('performance_metrics_summary');
      if (summary != null) {
        // In a real implementation, you would parse the summary back into metrics
        // For now, we'll just log that metrics were loaded
        if (kDebugMode) {
          developer.log('Loaded persisted metrics from cache');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error loading persisted metrics: $e');
      }
    }
  }

  /// Persist metrics to cache
  Future<void> persistMetrics() async {
    try {
      // Save metrics
      for (final entry in _metrics.entries) {
        await _cacheService.set(
            '${_metricsPrefix}${entry.key}', entry.value.toString());
      }

      // Save counters
      for (final entry in _counters.entries) {
        await _cacheService.set(
            '${_countersPrefix}${entry.key}', entry.value.toString());
      }

      // Save metrics summary
      final summary = getAllMetrics();
      await _cacheService.set(
          'performance_metrics_summary', _encodeJson(summary));
    } catch (e) {
      if (kDebugMode) {
        developer.log('Error persisting metrics: $e');
      }
    }
  }

  /// Check if performance is degrading
  bool isPerformanceDegrading(String operation, {double threshold = 1.5}) {
    final durations = _metrics['${operation}_duration'] ?? [];
    if (durations.length < 10) return false; // Not enough data

    final recent = durations.take(5).toList();
    final older = durations.skip(5).take(5).toList();

    if (recent.isEmpty || older.isEmpty) return false;

    final recentAverage = recent.reduce((a, b) => a + b) / recent.length;
    final olderAverage = older.reduce((a, b) => a + b) / older.length;

    return recentAverage > olderAverage * threshold;
  }

  /// Get performance recommendations
  List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];

    // Check startup time
    final startupTimes = _metrics['app_startup_time'] ?? [];
    if (startupTimes.isNotEmpty && startupTimes.last > 3000) {
      recommendations.add(
          'App startup time is high (>3s). Consider optimizing initialization.');
    }

    // Check cache hit rates
    for (final key in _counters.keys) {
      if (key.endsWith('_cache_hits')) {
        final operation = key.replaceAll('_cache_hits', '');
        final hits = _counters[key] ?? 0;
        final misses = _counters['${operation}_cache_misses'] ?? 0;
        final total = hits + misses;

        if (total > 10) {
          final hitRate = hits / total;
          if (hitRate < 0.7) {
            recommendations.add(
                'Cache hit rate for $operation is low (${(hitRate * 100).toStringAsFixed(1)}%). Consider adjusting cache strategy.');
          }
        }
      }
    }

    // Check for slow operations
    for (final key in _metrics.keys) {
      if (key.endsWith('_duration')) {
        final operation = key.replaceAll('_duration', '');
        final durations = _metrics[key] ?? [];

        if (durations.isNotEmpty) {
          final average = durations.reduce((a, b) => a + b) / durations.length;
          if (average > 1000) {
            recommendations.add(
                'Operation $operation is slow (avg: ${average.toStringAsFixed(0)}ms). Consider optimization.');
          }
        }
      }
    }

    return recommendations;
  }

  void _recordMetric(String name, int value) {
    _metrics[name] ??= [];
    _metrics[name]!.add(value);

    // Keep only last 100 values to prevent memory bloat
    if (_metrics[name]!.length > 100) {
      _metrics[name] = _metrics[name]!.takeLast(100).toList();
    }
  }

  void _saveCounter(String name) {
    _cacheService.set('${_countersPrefix}$name', _counters[name]!.toString());
  }

  String _encodeJson(Map<String, dynamic> data) {
    // Simple JSON encoding - in production, use dart:convert
    final buffer = StringBuffer();
    buffer.write('{');

    bool first = true;
    for (final entry in data.entries) {
      if (!first) buffer.write(',');
      first = false;

      buffer.write('"${entry.key}":');
      if (entry.value is String) {
        buffer.write('"${entry.value}"');
      } else if (entry.value is Map) {
        buffer.write(_encodeJson(Map<String, dynamic>.from(entry.value)));
      } else if (entry.value is List) {
        buffer.write('[');
        buffer.write(entry.value
            .map((e) => e is String ? '"$e"' : e.toString())
            .join(','));
        buffer.write(']');
      } else {
        buffer.write(entry.value.toString());
      }
    }

    buffer.write('}');
    return buffer.toString();
  }
}

/// Extension for List to take last N elements
extension ListExtensions<T> on List<T> {
  List<T> takeLast(int n) {
    if (n >= length) return this;
    return sublist(length - n);
  }
}
