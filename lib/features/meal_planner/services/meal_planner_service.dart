import '../../../shared/services/unified_meal_service.dart';
import '../../../core/services/cache_service.dart';

/// Service for meal planner feature that coordinates between layers
class MealPlannerService {
  final CacheService _cacheService = CacheService();
  final UnifiedMealService _unifiedMealService;

  MealPlannerService(this._unifiedMealService);

  /// Get meals for a specific date with caching
  Future<List<Map<String, dynamic>>> getMealsForDate(DateTime date) async {
    final cacheKey = 'meals_${_formatDateKey(date)}';
    final cached = await _cacheService.get(cacheKey);
    
    if (cached != null) {
      return List<Map<String, dynamic>>.from(cached);
    }
    
    final meals = await _unifiedMealService.getMealsForDate(date);
    await _cacheService.set(cacheKey, meals, expiration: const Duration(hours: 1));
    return meals;
  }

  /// Add meal for a specific date
  Future<void> addMealForDate(DateTime date, Map<String, dynamic> meal) async {
    await _unifiedMealService.addMealForDate(date, meal);
    
    // Clear cache for the date to force refresh
    final cacheKey = 'meals_${_formatDateKey(date)}';
    await _cacheService.remove(cacheKey);
  }

  /// Update meal status
  Future<void> updateMealStatus(DateTime date, String mealName, {bool? isLogged}) async {
    await _unifiedMealService.updateMealStatus(date, mealName, isLogged: isLogged);
    
    // Clear cache for the date to force refresh
    final cacheKey = 'meals_${_formatDateKey(date)}';
    await _cacheService.remove(cacheKey);
  }

  /// Clear cache for a specific date
  Future<void> clearCacheForDate(DateTime date) async {
    await _unifiedMealService.clearCacheForDate(date);
    
    final cacheKey = 'meals_${_formatDateKey(date)}';
    await _cacheService.remove(cacheKey);
  }

  /// Get meal statistics for a date range
  Future<Map<String, dynamic>> getMealStatistics(DateTime startDate, DateTime endDate) async {
    final cacheKey = 'stats_${_formatDateKey(startDate)}_${_formatDateKey(endDate)}';
    final cached = await _cacheService.get(cacheKey);
    
    if (cached != null) {
      return Map<String, dynamic>.from(cached);
    }
    
    // Calculate statistics
    int totalMeals = 0;
    int loggedMeals = 0;
    double totalProtein = 0;
    
    for (DateTime date = startDate; 
         date.isBefore(endDate) || date.isAtSameMomentAs(endDate); 
         date = date.add(const Duration(days: 1))) {
      final meals = await getMealsForDate(date);
      totalMeals += meals.length;
      loggedMeals += meals.where((meal) => meal['isLogged'] == true).length;
      totalProtein += meals.fold<double>(0, (sum, meal) => sum + (meal['protein'] as double? ?? 0));
    }
    
    final stats = {
      'totalMeals': totalMeals,
      'loggedMeals': loggedMeals,
      'loggedPercentage': totalMeals > 0 ? (loggedMeals / totalMeals) * 100 : 0,
      'totalProtein': totalProtein,
      'averageProteinPerMeal': totalMeals > 0 ? totalProtein / totalMeals : 0,
    };
    
    await _cacheService.set(cacheKey, stats, expiration: const Duration(hours: 2));
    return stats;
  }

  /// Get meal recommendations based on history
  Future<List<Map<String, dynamic>>> getMealRecommendations() async {
    const cacheKey = 'meal_recommendations';
    final cached = await _cacheService.get(cacheKey);
    
    if (cached != null) {
      return List<Map<String, dynamic>>.from(cached);
    }
    
    // Generate mock recommendations - in real app, this would use ML or analytics
    final recommendations = [
      {
        'name': 'Grilled Chicken Salad',
        'protein': 35.0,
        'calories': 320,
        'category': 'lunch',
        'reason': 'High protein, low calorie option',
      },
      {
        'name': 'Greek Yogurt Parfait',
        'protein': 20.0,
        'calories': 180,
        'category': 'breakfast',
        'reason': 'Great for morning protein boost',
      },
      {
        'name': 'Salmon with Vegetables',
        'protein': 40.0,
        'calories': 450,
        'category': 'dinner',
        'reason': 'Omega-3 rich and nutritious',
      },
    ];
    
    await _cacheService.set(cacheKey, recommendations, expiration: const Duration(hours: 24));
    return recommendations;
  }

  String _formatDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
