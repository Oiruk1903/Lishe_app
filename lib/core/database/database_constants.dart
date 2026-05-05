class DatabaseConstants {
  static const String databaseName = 'lishe_app.db';
  static const int databaseVersion = 3;

  // Table Names
  static const String tableUsers = 'users';
  static const String tableFoodItems = 'food_items';
  static const String tableMealLogs = 'meal_logs';
  static const String tableWeightEntries = 'weight_entries';
  static const String tableReminders = 'reminders';

  // Common Columns
  static const String columnId = 'id';
  static const String columnUserId = 'user_id';
  static const String columnCreatedAt = 'created_at';
  static const String columnUpdatedAt = 'updated_at';
  static const String columnSynced = 'synced';

  // Users Table Columns
  static const String columnFullName = 'full_name';
  static const String columnEmail = 'email';
  static const String columnPhoneNumber = 'phone_number';
  static const String columnDateOfBirth = 'date_of_birth';
  static const String columnGender = 'gender';
  static const String columnCohort = 'cohort';
  static const String columnProfileImage = 'profile_image';
  static const String columnHeight = 'height';
  static const String columnTargetWeight = 'target_weight';
  static const String columnPreferredLanguage = 'preferred_language';
  static const String columnNotificationSettings = 'notification_settings';

  // Food Items Table Columns
  static const String columnNameSw = 'name_sw';
  static const String columnNameEn = 'name_en';
  static const String columnCategory = 'category';
  static const String columnCaloriesPer100g = 'calories_per_100g';
  static const String columnProteinPer100g = 'protein_per_100g';
  static const String columnCarbsPer100g = 'carbs_per_100g';
  static const String columnFatPer100g = 'fat_per_100g';
  static const String columnFiberPer100g = 'fiber_per_100g';
  static const String columnStandardServingSize = 'standard_serving_size';
  static const String columnServingUnit = 'serving_unit';
  static const String columnZone = 'zone';
  static const String columnIsLocal = 'is_local';
  static const String columnImageUrl = 'image_url';

  // Meal Logs Table Columns
  static const String columnFoodItemId = 'food_item_id';
  static const String columnMealPeriod = 'meal_period';
  static const String columnQuantity = 'quantity';
  static const String columnUnit = 'unit';
  static const String columnLoggedAt = 'logged_at';

  // Weight Entries Table Columns
  static const String columnWeight = 'weight';
  static const String columnRecordedAt = 'recorded_at';
  static const String columnNote = 'note';

  // Reminders Table Columns
  static const String columnType = 'type';
  static const String columnTitle = 'title';
  static const String columnDescription = 'description';
  static const String columnScheduledFor = 'scheduled_for';
  static const String columnIsCompleted = 'is_completed';
}
