import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import '../../shared/services/unified_meal_service.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import '../network/api_client.dart';
import '../database/database_helper.dart';
import '../../features/meal_logging/data/datasources/meal_local_datasource.dart';
import '../../features/weight_tracking/data/datasources/weight_local_datasource.dart';

// SharedPreferences provider with proper initialization
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Use initializeDependencies() first');
});

// Unified meal service provider
final unifiedMealServiceProvider = Provider<UnifiedMealService>((ref) {
  return UnifiedMealService();
});

// Connectivity service provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

// Database helper provider
final databaseHelperProvider = Provider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});

// Dio provider for ApiClient
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// ApiClient provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.read(dioProvider);
  return ApiClient(dio);
});

// Meal local data source provider
final mealLocalDataSourceProvider = Provider<MealLocalDataSource>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return MealLocalDataSourceImpl(dbHelper);
});

// Weight local data source provider
final weightLocalDataSourceProvider = Provider<WeightLocalDataSource>((ref) {
  final dbHelper = ref.read(databaseHelperProvider);
  return WeightLocalDataSourceImpl(dbHelper);
});

// Sync service provider
final syncServiceProvider = Provider<SyncService>((ref) {
  final connectivityService = ref.read(connectivityServiceProvider);
  final apiClient = ref.read(apiClientProvider);
  final mealDataSource = ref.read(mealLocalDataSourceProvider);
  final weightDataSource = ref.read(weightLocalDataSourceProvider);

  return SyncService(
    mealDataSource,
    weightDataSource,
    apiClient,
    connectivityService,
  );
});

// Initialize all dependencies asynchronously
Future<void> initializeDependencies() async {
  try {
    // Initialize SharedPreferences and store reference if needed
    await SharedPreferences.getInstance();

    // Initialize the unified meal service
    final mealService = UnifiedMealService();
    await mealService.initialize();

    print('Dependencies initialized successfully');
  } catch (e) {
    print('Error initializing dependencies: $e');
    rethrow;
  }
}
