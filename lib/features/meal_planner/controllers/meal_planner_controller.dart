import 'package:intl/intl.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/services/performance_monitoring_service.dart';
import '../models/meal.dart';
import '../services/ai_recommendation_service.dart';
import '../services/meal_service.dart';

class MealPlannerController {
  final MealService _mealService;
  final AIRecommendationService _aiService;
  final PerformanceMonitoringService _perfService =
      PerformanceMonitoringService();

  // User preferences and health data
  Map<String, dynamic> _userPreferences = {};
  Map<String, dynamic> _healthMetrics = {};
  final List<String> _dietaryRestrictions = [];

  // This would typically connect to a repository or service
  final Map<String, Map<String, Meal>> _mealPlans =
      {}; // date -> meal type -> meal

  // Sample meals data (in a real app, this would come from a database or API)
  final List<Meal> _availableMeals = [
    Meal(
      id: '1',
      name: 'Oatmeal with Berries',
      calories: 320,
      protein: 12.5,
      carbs: 52.0,
      fat: 8.0,
      imageUrl: 'assets/images/oatmeal.jpg',
      ingredients: ['Oats', 'Milk', 'Mixed berries', 'Honey'],
      recipe: 'Cook oats with milk. Top with berries and honey.',
      mealTypes: ['breakfast'],
    ),
    Meal(
      id: '2',
      name: 'Egg Avocado Toast',
      calories: 380,
      protein: 15.0,
      carbs: 30.0,
      fat: 22.0,
      imageUrl: 'assets/images/avocado_toast.jpg',
      ingredients: ['Whole grain bread', 'Avocado', 'Eggs', 'Salt', 'Pepper'],
      recipe:
          'Toast bread. Mash avocado and spread on bread. Top with fried egg.',
      mealTypes: ['breakfast'],
    ),

    Meal(
      id: '3',
      name: 'Mandazi with Chai',
      calories: 380,
      protein: 6.0,
      carbs: 58.0,
      fat: 14.0,
      imageUrl: 'assets/images/mandazi.jpg',
      ingredients: ['Flour', 'Sugar', 'Coconut milk', 'Cardamom', 'Tea leaves'],
      recipe:
          'Make dough with flour, sugar and coconut milk. Fry until golden. Serve with spiced tea.',
      mealTypes: ['breakfast'],
    ),
    // Lunch options
    Meal(
      id: '4',
      name: 'Grilled Chicken Salad',
      calories: 420,
      protein: 35.0,
      carbs: 15.0,
      fat: 25.0,
      imageUrl: 'assets/images/chicken_salad.jpg',
      ingredients: [
        'Chicken breast',
        'Mixed greens',
        'Cherry tomatoes',
        'Cucumber',
        'Olive oil',
      ],
      recipe:
          'Grill chicken. Mix vegetables and top with sliced chicken. Drizzle with olive oil.',
      mealTypes: ['lunch'],
    ),
    Meal(
      id: '5',
      name: 'Ugali with Sukuma Wiki',
      calories: 450,
      protein: 18.0,
      carbs: 65.0,
      fat: 10.0,
      imageUrl: 'assets/images/ugali.jpg',
      ingredients: [
        'Maize flour',
        'Sukuma Wiki (kale)',
        'Onions',
        'Tomatoes',
        'Spices',
      ],
      recipe:
          'Cook ugali until firm. In separate pan, cook sukuma wiki with onions and tomatoes.',
      mealTypes: ['lunch', 'dinner'],
    ),
    // Dinner options
    Meal(
      id: '6',
      name: 'Salmon with Quinoa',
      calories: 520,
      protein: 42.0,
      carbs: 35.0,
      fat: 22.0,
      imageUrl: 'assets/images/salmon_quinoa.jpg',
      ingredients: ['Salmon fillet', 'Quinoa', 'Broccoli', 'Lemon', 'Dill'],
      recipe: 'Cook quinoa. Bake salmon with lemon and dill. Steam broccoli.',
      mealTypes: ['dinner'],
    ),
    Meal(
      id: '7',
      name: 'Nyama Choma with Kachumbari',
      calories: 580,
      protein: 45.0,
      carbs: 20.0,
      fat: 32.0,
      imageUrl: 'assets/images/nyama_choma.jpg',
      ingredients: [
        'Goat meat or beef',
        'Tomatoes',
        'Onions',
        'Cilantro',
        'Lemon juice',
      ],
      recipe:
          'Marinate meat with spices. Grill until well done. Make kachumbari salad with tomatoes, onions and cilantro.',
      mealTypes: ['dinner'],
    ),
  ];

  MealPlannerController({
    MealService? mealService,
    AIRecommendationService? aiService,
  })  : _mealService = mealService ?? MealService(),
        _aiService = aiService ?? AIRecommendationService();

  Future<void> initialize() async {
    _perfService.startTimer('meal_planner_initialization');

    await NotificationService.initialize();
    await _loadUserPreferences();
    await _loadHealthMetrics();

    _perfService.endTimer('meal_planner_initialization');
    _perfService.recordFeatureLoadTime(
        'meal_planner', const Duration(milliseconds: 100));
  }

  Future<void> _loadUserPreferences() async {
    // Load user preferences from local storage or API
    _userPreferences = {
      'preferredCuisines': ['Mediterranean', 'Asian', 'African'],
      'mealSize': 'medium',
      'cookingSkill': 'intermediate',
      'mealPrepTime': 30, // minutes
      'budget': 'moderate',
    };
  }

  Future<void> _loadHealthMetrics() async {
    // Load health metrics from health tracking service
    _healthMetrics = {
      'weight': 70.0,
      'height': 175.0,
      'activityLevel': 'moderate',
      'sleepHours': 7.5,
      'stressLevel': 'low',
    };
  }

  Future<List<Meal>> getPersonalizedRecommendations() async {
    _perfService.startTimer('ai_recommendations');

    // Get AI-powered meal recommendations based on user preferences and health metrics
    final recommendations = await _aiService.getRecommendations(
      preferences: _userPreferences,
      healthMetrics: _healthMetrics,
      dietaryRestrictions: _dietaryRestrictions,
    );

    _perfService.endTimer('ai_recommendations');
    _perfService.recordCacheHit('ai_recommendations', true);

    return recommendations;
  }

  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    _userPreferences = preferences;
    // Trigger re-recommendation of meals
    await getPersonalizedRecommendations();
  }

  Future<void> updateHealthMetrics(Map<String, dynamic> metrics) async {
    _healthMetrics = metrics;
    // Trigger re-recommendation of meals
    await getPersonalizedRecommendations();
  }

  Future<void> addDietaryRestriction(String restriction) async {
    if (!_dietaryRestrictions.contains(restriction)) {
      _dietaryRestrictions.add(restriction);
      // Trigger re-recommendation of meals
      await getPersonalizedRecommendations();
    }
  }

  Future<void> removeDietaryRestriction(String restriction) async {
    _dietaryRestrictions.remove(restriction);
    // Trigger re-recommendation of meals
    await getPersonalizedRecommendations();
  }

  void loadMealsForDate(DateTime date) {
    // In a real app, this would fetch data from a storage or API
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (!_mealPlans.containsKey(dateStr)) {
      _mealPlans[dateStr] = {};
    }
  }

  Meal? getBreakfastForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _mealPlans[dateStr]?['breakfast'];
  }

  Meal? getLunchForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _mealPlans[dateStr]?['lunch'];
  }

  Meal? getDinnerForDate(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return _mealPlans[dateStr]?['dinner'];
  }

  Future<List<Meal>> getAvailableMeals(String mealType) async {
    _perfService.startTimer('get_available_meals');

    // Remove artificial delay - use cached filtering instead
    final filteredMeals = _availableMeals
        .where((meal) => meal.mealTypes.contains(mealType))
        .toList();

    _perfService.endTimer('get_available_meals');
    _perfService.recordCacheHit('meal_filter', true);

    return filteredMeals;
  }

  Future<void> setMealForDate(DateTime date, String mealType, Meal meal) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (!_mealPlans.containsKey(dateStr)) {
      _mealPlans[dateStr] = {};
    }
    _mealPlans[dateStr]![mealType] = meal;

    // Schedule notifications for the meal
    await _scheduleMealNotifications(date, mealType, meal);
  }

  Future<void> _scheduleMealNotifications(
    DateTime date,
    String mealType,
    Meal meal,
  ) async {
    // Determine meal time based on meal type
    DateTime mealTime;
    switch (mealType) {
      case 'breakfast':
        mealTime = DateTime(date.year, date.month, date.day, 8, 0); // 8:00 AM
        break;
      case 'lunch':
        mealTime = DateTime(date.year, date.month, date.day, 13, 0); // 1:00 PM
        break;
      case 'dinner':
        mealTime = DateTime(date.year, date.month, date.day, 19, 0); // 7:00 PM
        break;
      default:
        mealTime = DateTime(
          date.year,
          date.month,
          date.day,
          12,
          0,
        ); // Default to noon
    }

    // Schedule the meal reminder
    await NotificationService.scheduleReminder(
      id: int.parse(meal.id),
      title: 'Time to eat: ${meal.name}',
      body: 'Don\'t forget to log your meal after eating!',
      scheduledTime: mealTime,
    );

    // Schedule the tracking reminder
    await NotificationService.scheduleReminder(
      id: int.parse(meal.id) + 1000, // Use different ID to avoid conflicts
      title: 'Meal Tracking Reminder',
      body: 'Remember to log your ${meal.name}!',
      scheduledTime: mealTime,
    );
  }

  Future<void> removeMealFromDate(DateTime date, String mealType) async {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    if (_mealPlans.containsKey(dateStr)) {
      final meal = _mealPlans[dateStr]![mealType];
      if (meal != null) {
        // Cancel notifications for this meal
        await NotificationService.cancelNotification(int.parse(meal.id));
        await NotificationService.cancelNotification(int.parse(meal.id) + 1000);
      }
      _mealPlans[dateStr]!.remove(mealType);
    }
  }

  // Get a suggested breakfast based on date
  Meal? getSuggestedBreakfast(DateTime date) {
    // First check if the user has a planned meal
    final planned = getBreakfastForDate(date);
    if (planned != null) return planned;

    // Otherwise provide a suggestion based on the day of week
    // In a real app, this would use user preferences, history, etc.
    return _availableMeals.firstWhere(
      (meal) => meal.mealTypes.contains('breakfast'),
      orElse: () => _availableMeals.first,
    );
  }

  // Get a suggested lunch based on date
  Meal? getSuggestedLunch(DateTime date) {
    // First check if the user has a planned meal
    final planned = getLunchForDate(date);
    if (planned != null) return planned;

    // Otherwise provide a suggestion
    return _availableMeals.firstWhere(
      (meal) => meal.mealTypes.contains('lunch'),
      orElse: () => _availableMeals.first,
    );
  }

  // Get a suggested dinner based on date
  Meal? getSuggestedDinner(DateTime date) {
    // First check if the user has a planned meal
    final planned = getDinnerForDate(date);
    if (planned != null) return planned;

    // Otherwise provide a suggestion
    return _availableMeals.firstWhere(
      (meal) => meal.mealTypes.contains('dinner'),
      orElse: () => _availableMeals.first,
    );
  }
}
