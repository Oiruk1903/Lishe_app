import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Centralized caching service for the app
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  SharedPreferences? _prefs;
  static const String _cachePrefix = 'lishe_cache_';
  static const Duration _defaultExpiration = Duration(hours: 24);

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
      // Clear expired entries on initialization
      await _clearExpiredInBackground();
    }
  }

  /// Store data in cache with optional expiration
  Future<void> set<T>(String key, T value, {Duration? expiration}) async {
    await _ensureInitialized();

    final cacheKey = _getCacheKey(key);
    final expirationTime = expiration ?? _defaultExpiration;
    final expiryDate = DateTime.now().add(expirationTime);

    final cacheData = {
      'value': value,
      'expiry': expiryDate.toIso8601String(),
      'type': T.toString(),
    };

    // Use non-blocking write for better performance
    Future.microtask(() async {
      await _prefs!.setString(cacheKey, jsonEncode(cacheData));
    });
  }

  /// Get data from cache
  T? get<T>(String key) {
    if (_prefs == null) return null;

    final cacheKey = _getCacheKey(key);
    final cachedData = _prefs!.getString(cacheKey);

    if (cachedData == null) return null;

    try {
      final data = jsonDecode(cachedData) as Map<String, dynamic>;
      final expiry = DateTime.parse(data['expiry'] as String);

      // Check if cache has expired
      if (DateTime.now().isAfter(expiry)) {
        // Remove expired cache
        remove(key);
        return null;
      }

      return data['value'] as T;
    } catch (e) {
      print('Error reading cache for key $key: $e');
      remove(key); // Remove corrupted cache
      return null;
    }
  }

  /// Check if cache exists and is not expired
  bool has(String key) {
    return get(key) != null;
  }

  /// Remove specific cache entry
  Future<void> remove(String key) async {
    await _ensureInitialized();
    final cacheKey = _getCacheKey(key);
    await _prefs!.remove(cacheKey);
  }

  /// Clear all cache
  Future<void> clear() async {
    await _ensureInitialized();
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      await _prefs!.remove(key);
    }
  }

  /// Clear expired cache entries
  Future<void> clearExpired() async {
    await _ensureInitialized();
    final keys = _prefs!.getKeys().where((key) => key.startsWith(_cachePrefix));

    for (final key in keys) {
      final cachedData = _prefs!.getString(key);
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as Map<String, dynamic>;
          final expiry = DateTime.parse(data['expiry'] as String);

          if (DateTime.now().isAfter(expiry)) {
            await _prefs!.remove(key);
          }
        } catch (e) {
          // Remove corrupted cache entries
          await _prefs!.remove(key);
        }
      }
    }
  }

  /// Clear expired cache entries in background (non-blocking)
  Future<void> _clearExpiredInBackground() async {
    // Run in background without blocking
    Future.microtask(() async {
      try {
        await clearExpired();
      } catch (e) {
        print('Background cache cleanup failed: $e');
      }
    });
  }

  /// Get cache size (number of entries)
  int get size {
    if (_prefs == null) return 0;
    return _prefs!
        .getKeys()
        .where((key) => key.startsWith(_cachePrefix))
        .length;
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    if (_prefs == null) return {'total': 0, 'expired': 0};

    final keys = _prefs!.getKeys().where((key) => key.startsWith(_cachePrefix));
    int expiredCount = 0;

    for (final key in keys) {
      final cachedData = _prefs!.getString(key);
      if (cachedData != null) {
        try {
          final data = jsonDecode(cachedData) as Map<String, dynamic>;
          final expiry = DateTime.parse(data['expiry'] as String);

          if (DateTime.now().isAfter(expiry)) {
            expiredCount++;
          }
        } catch (e) {
          expiredCount++;
        }
      }
    }

    return {
      'total': keys.length,
      'expired': expiredCount,
      'valid': keys.length - expiredCount,
    };
  }

  /// Ensure SharedPreferences is initialized
  Future<void> _ensureInitialized() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Generate cache key with prefix
  String _getCacheKey(String key) {
    return '$_cachePrefix$key';
  }

  /// Cache meal data with proper structure
  Future<void> cacheMealData(
      String date, List<Map<String, dynamic>> meals) async {
    await set('meals_$date', meals, expiration: const Duration(hours: 12));
  }

  /// Get cached meal data
  List<Map<String, dynamic>>? getCachedMealData(String date) {
    final cached = get<List<dynamic>>('meals_$date');
    if (cached == null) return null;

    return cached.cast<Map<String, dynamic>>();
  }

  /// Cache user preferences
  Future<void> cacheUserPreferences(Map<String, dynamic> preferences) async {
    await set('user_preferences', preferences,
        expiration: const Duration(days: 30));
  }

  /// Get cached user preferences
  Map<String, dynamic>? getCachedUserPreferences() {
    return get<Map<String, dynamic>>('user_preferences');
  }

  /// Cache nutrition data
  Future<void> cacheNutritionData(
      String mealId, Map<String, dynamic> nutritionData) async {
    await set('nutrition_$mealId', nutritionData,
        expiration: const Duration(hours: 6));
  }

  /// Get cached nutrition data
  Map<String, dynamic>? getCachedNutritionData(String mealId) {
    return get<Map<String, dynamic>>('nutrition_$mealId');
  }
}
