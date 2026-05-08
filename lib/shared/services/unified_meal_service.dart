import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/cache_service.dart';

/// Unified service for meal data management across the app
class UnifiedMealService {
  static final UnifiedMealService _instance = UnifiedMealService._internal();
  factory UnifiedMealService() => _instance;
  UnifiedMealService._internal();

  final CacheService _cacheService = CacheService();
  SharedPreferences? _prefs;

  // In-memory cache for quick access
  final Map<String, List<Map<String, dynamic>>> _mealCache = {};
  final Map<String, List<Map<String, dynamic>>> _mealPlanCache = {};

  /// Initialize the service with SharedPreferences
  Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadCachedData();
  }

  /// Load cached data from SharedPreferences
  Future<void> _loadCachedData() async {
    if (_prefs == null) return;

    // Load meal cache
    final mealCacheKeys =
        _prefs!.getKeys().where((key) => key.startsWith('meal_cache_'));
    for (final key in mealCacheKeys) {
      final cachedData = _prefs!.getStringList(key);
      if (cachedData != null) {
        final date = key.replaceFirst('meal_cache_', '');
        _mealCache[date] =
            cachedData.map((item) => _parseMealData(item)).toList();
      }
    }
  }

  /// Parse meal data from cached string
  Map<String, dynamic> _parseMealData(String data) {
    // Simple parsing - in a real app, use proper JSON parsing
    final parts = data.split('|');
    return {
      'name': parts[0],
      'calories': int.tryParse(parts[1]) ?? 0,
      'images': parts.length > 2
          ? [parts[2]]
          : [
              'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80'
            ],
      'isLogged': parts.length > 3 ? parts[3] == 'true' : false,
      'hasPlanned': parts.length > 4 ? parts[4] == 'true' : false,
      'loggedMeals': parts.length > 5 ? int.tryParse(parts[5]) ?? 0 : 0,
    };
  }

  /// Get meals for a specific date with caching
  Future<List<Map<String, dynamic>>> getMealsForDate(DateTime date) async {
    final dateKey = _formatDateKey(date);

    // Try cache service first (persistent cache)
    final cachedMeals = _cacheService.getCachedMealData(dateKey);
    if (cachedMeals != null) {
      _mealCache[dateKey] = cachedMeals; // Update memory cache
      return cachedMeals;
    }

    // Return in-memory cached data if available
    if (_mealCache.containsKey(dateKey)) {
      return _mealCache[dateKey]!;
    }

    // Generate mock data for the date
    final meals = await _generateMealsForDate(date);

    // Cache the data in both memory and persistent cache
    _mealCache[dateKey] = meals;
    await _cacheService.cacheMealData(dateKey, meals);
    await _cacheMealsForDate(dateKey, meals); // Legacy cache for compatibility

    return meals;
  }

  /// Generate mock meals for a specific date
  Future<List<Map<String, dynamic>>> _generateMealsForDate(
      DateTime date) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    return [
      {
        'name': 'Breakfast',
        'calories': '350',
        'images': [
          'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&q=80'
        ],
        'isLogged': false,
        'hasPlanned': true,
        'loggedMeals': [],
      },
      {
        'name': 'Lunch',
        'calories': '550',
        'images': [
          'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=500&q=80'
        ],
        'isLogged': true,
        'hasPlanned': true,
        'loggedMeals': [
          {'name': 'Rice and Beans', 'calories': 280}
        ],
      },
      {
        'name': 'Dinner',
        'calories': '650',
        'images': [
          'https://images.unsplash.com/photo-1467223198725-22d158293852?w=500&q=80'
        ],
        'isLogged': false,
        'hasPlanned': false,
        'loggedMeals': [],
      },
      {
        'name': 'Snack',
        'calories': '200',
        'images': [
          'https://images.unsplash.com/photo-1490474418585-ba9bad8fd0ea?w=500&q=80'
        ],
        'isLogged': false,
        'hasPlanned': false,
        'loggedMeals': [],
      },
    ];
  }

  /// Cache meals for a specific date
  Future<void> _cacheMealsForDate(
      String dateKey, List<Map<String, dynamic>> meals) async {
    if (_prefs == null) return;

    final cachedData = meals
        .map((meal) =>
            '${meal['name']}|${meal['calories']}|${meal['images']?.first ?? ''}|${meal['isLogged']}|${meal['hasPlanned']}|${meal['loggedMeals']?.length ?? 0}')
        .toList();

    await _prefs!.setStringList('meal_cache_$dateKey', cachedData);
  }

  /// Format date as cache key
  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Add or update a meal for a specific date
  Future<void> addMealForDate(DateTime date, Map<String, dynamic> meal) async {
    final dateKey = _formatDateKey(date);

    if (!_mealCache.containsKey(dateKey)) {
      _mealCache[dateKey] = [];
    }

    _mealCache[dateKey]!.add(meal);
    await _cacheMealsForDate(dateKey, _mealCache[dateKey]!);
  }

  /// Update meal status (logged/planned)
  Future<void> updateMealStatus(DateTime date, String mealName,
      {bool? isLogged, bool? hasPlanned}) async {
    final dateKey = _formatDateKey(date);

    if (_mealCache.containsKey(dateKey)) {
      final meals = _mealCache[dateKey]!;
      final mealIndex = meals.indexWhere((meal) => meal['name'] == mealName);

      if (mealIndex != -1) {
        if (isLogged != null) meals[mealIndex]['isLogged'] = isLogged;
        if (hasPlanned != null) meals[mealIndex]['hasPlanned'] = hasPlanned;

        await _cacheMealsForDate(dateKey, meals);
      }
    }
  }

  /// Clear cache for a specific date
  Future<void> clearCacheForDate(DateTime date) async {
    final dateKey = _formatDateKey(date);
    _mealCache.remove(dateKey);

    if (_prefs != null) {
      await _prefs!.remove('meal_cache_$dateKey');
    }
  }

  /// Clear all cached data
  Future<void> clearAllCache() async {
    _mealCache.clear();
    _mealPlanCache.clear();

    if (_prefs != null) {
      final keys =
          _prefs!.getKeys().where((key) => key.startsWith('meal_cache_'));
      for (final key in keys) {
        await _prefs!.remove(key);
      }
    }
  }
}

// Provider for the unified meal service
final unifiedMealServiceProvider = Provider<UnifiedMealService>((ref) {
  return UnifiedMealService();
});

// Provider for meals for a specific date
final unifiedMealsForDateProvider =
    FutureProvider.family<List<Map<String, dynamic>>, DateTime>(
        (ref, date) async {
  final service = ref.watch(unifiedMealServiceProvider);
  await service.initialize();
  return service.getMealsForDate(date);
});
