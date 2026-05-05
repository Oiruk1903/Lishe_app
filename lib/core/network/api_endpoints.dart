class ApiEndpoints {
  // Base URL - Replace with actual backend URL
  static const String baseUrl = 'https://api.lishe.tz/v1';

  // Auth
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String changePassword = '/auth/change-password';
  static const String forgotPassword = '/auth/forgot-password';

  // Foods
  static const String foods = '/foods';
  static const String foodCategories = '/foods/categories';
  static const String searchFoods = '/foods/search';
  static const String zonalFoods = '/foods/zonal';

  // Meals
  static const String meals = '/meals';
  static const String syncMeals = '/meals/sync';
  static const String dailySummary = '/meals/summary';
  static const String mealRecommendations = '/meals/recommendations';

  // Weight
  static const String weights = '/weights';
  static const String syncWeights = '/weights/sync';
  static const String bmi = '/weights/bmi';
  static const String weightGoal = '/weights/goal';

  // AI Features
  static const String chat = '/ai/chat';
  static const String analyzePlate = '/ai/analyze-plate';
  static const String recommendations = '/ai/recommendations';

  // Reminders
  static const String reminders = '/reminders';
  static const String clinicReminders = '/reminders/clinic';

  // User Settings
  static const String settings = '/settings';
  static const String language = '/settings/language';
  static const String notifications = '/settings/notifications';
}
