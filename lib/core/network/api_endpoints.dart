class ApiEndpoints {
  // Dev: your machine's LAN IP so the phone/emulator can reach the local backend.
  // Prod: switch back to 'https://api.lishe.tz'
  static const String baseUrl = 'http://192.168.145.49:8080';

  // ---------------------------------------------------------------------------
  // Auth  —  /v1/auth/*  (public: register, login, forgot-password)
  // ---------------------------------------------------------------------------
  static const String register        = '/v1/auth/register';
  static const String login           = '/v1/auth/login';
  static const String refresh         = '/v1/auth/refresh';
  static const String logout          = '/v1/auth/logout';
  static const String profile         = '/v1/auth/profile';
  static const String changePassword  = '/v1/auth/change-password';
  static const String forgotPassword  = '/v1/auth/forgot-password';

  // ---------------------------------------------------------------------------
  // Foods  —  /v1/foods/*
  // ---------------------------------------------------------------------------
  static const String foods           = '/v1/foods';
  static const String foodCategories  = '/v1/foods/categories';
  static const String foodContent     = '/v1/foods/content';

  // ---------------------------------------------------------------------------
  // Meals  —  /v1/meals/*
  // ---------------------------------------------------------------------------
  static const String meals           = '/v1/meals';
  static const String mealsSummary    = '/v1/meals/summary';
  static const String water           = '/v1/meals/water';
  static const String waterSummary    = '/v1/meals/water/summary';

  // ---------------------------------------------------------------------------
  // AI  —  /v1/ai/*
  // ---------------------------------------------------------------------------
  static const String chat             = '/v1/ai/chat';
  static const String chatHistory      = '/v1/ai/chat/history';
  static const String analyzePlate     = '/v1/ai/analyze-plate';
  static const String recommendations  = '/v1/ai/recommendations';
  static const String generatePlan     = '/v1/ai/recommendations/generate';
  static const String mealPlans        = '/v1/ai/recommendations/meal-plans';
  static const String alerts           = '/v1/ai/recommendations/alerts';
  static const String recHistory       = '/v1/ai/recommendations/history';
  static const String recFeedback      = '/v1/ai/recommendations/feedback';

  // ---------------------------------------------------------------------------
  // Progress / Analytics  —  /v1/progress/*
  // ---------------------------------------------------------------------------
  static const String progress         = '/v1/progress';
  static const String progressBmi      = '/v1/progress/bmi';
  static const String progressNutrients = '/v1/progress/nutrients';
  static const String progressCalories  = '/v1/progress/calories';
  static const String progressAdherence = '/v1/progress/adherence';

  // ---------------------------------------------------------------------------
  // Weight Tracking  —  /v1/weights/*
  // ---------------------------------------------------------------------------
  static const String weights       = '/v1/weights';
  static const String weightsLatest = '/v1/weights/latest';
  static const String weightsBmi    = '/v1/weights/bmi';
  static const String weightsTrends = '/v1/weights/trends';

  // ---------------------------------------------------------------------------
  // Admin  —  /v1/admin/*  (JWT + ADMIN role required)
  // ---------------------------------------------------------------------------
  static const String adminAnalytics   = '/v1/admin/analytics/platform';
  static const String adminReports     = '/v1/admin/reports';
}
