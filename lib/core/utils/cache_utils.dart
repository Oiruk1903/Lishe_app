import 'dart:async';

/// Simple caching utility with TTL support
class CacheUtils {
  static final Map<String, _CacheEntry> _cache = {};

  static T? get<T>(String key) {
    final entry = _cache[key];
    if (entry == null) return null;

    if (entry.isExpired) {
      _cache.remove(key);
      return null;
    }

    return entry.value as T?;
  }

  static void set<T>(String key, T value, {Duration? ttl}) {
    _cache[key] = _CacheEntry(
      value: value,
      expiry: ttl != null ? DateTime.now().add(ttl) : null,
    );
  }

  static void invalidate(String key) {
    _cache.remove(key);
  }

  static void invalidateAll() {
    _cache.clear();
  }

  static void invalidatePattern(String pattern) {
    final regex = RegExp(pattern);
    _cache.removeWhere((key, _) => regex.hasMatch(key));
  }

  static int get size => _cache.length;

  static void cleanup() {
    _cache.removeWhere((key, entry) => entry.isExpired);
  }
}

class _CacheEntry {
  final dynamic value;
  final DateTime? expiry;

  _CacheEntry({required this.value, this.expiry});

  bool get isExpired => expiry != null && DateTime.now().isAfter(expiry!);
}

/// Provider cache with automatic cleanup
class ProviderCache {
  static const Duration defaultTtl = Duration(minutes: 5);
  static const Duration shortTtl = Duration(minutes: 1);
  static const Duration longTtl = Duration(hours: 1);

  static Future<T?> getOrFetch<T>(
    String key,
    Future<T> Function() fetcher, {
    Duration? ttl,
  }) async {
    // Check cache first
    final cached = CacheUtils.get<T>(key);
    if (cached != null) return cached;

    try {
      // Fetch fresh data
      final result = await fetcher();

      // Cache the result
      CacheUtils.set(key, result, ttl: ttl ?? defaultTtl);

      return result;
    } catch (e) {
      // Return cached data if available, even if expired
      final expired = CacheUtils.get<T>(key);
      if (expired != null) return expired;

      rethrow;
    }
  }

  static void invalidateUserRelated(String userId) {
    CacheUtils.invalidatePattern('profile_$userId.*');
    CacheUtils.invalidatePattern('meals_$userId.*');
    CacheUtils.invalidatePattern('weight_$userId.*');
    CacheUtils.invalidatePattern('nutrition_$userId.*');
  }
}
