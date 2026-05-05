import 'dart:async';
import '../../features/meal_logging/data/datasources/meal_local_datasource.dart';
import '../../features/weight_tracking/data/datasources/weight_local_datasource.dart';
import '../network/api_client.dart';
import 'connectivity_service.dart';

class SyncService {
  final MealLocalDataSource _mealDataSource;
  final WeightLocalDataSource _weightDataSource;
  final ApiClient _apiClient;
  final ConnectivityService _connectivityService;

  Timer? _syncTimer;
  bool _isSyncing = false;

  SyncService(
    this._mealDataSource,
    this._weightDataSource,
    this._apiClient,
    this._connectivityService,
  );

  Future<void> initialize() async {
    // Listen to connectivity changes
    _connectivityService.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        sync();
      }
    });

    // Periodic sync every 15 minutes when online
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (_) async {
      if (await _connectivityService.isConnected()) {
        sync();
      }
    });

    // Initial sync
    if (await _connectivityService.isConnected()) {
      sync();
    }
  }

  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      await _syncMealLogs();
      await _syncWeightEntries();
      await _syncReminders();
    } catch (e) {
      // Log error
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncMealLogs() async {
    final unsyncedLogs = await _mealDataSource.getUnsyncedLogs();
    if (unsyncedLogs.isNotEmpty) {
      await _apiClient.syncMealLogs(unsyncedLogs);
      for (var log in unsyncedLogs) {
        await _mealDataSource.markAsSynced(log.id);
      }
    }
  }

  Future<void> _syncWeightEntries() async {
    final unsyncedEntries = await _weightDataSource.getUnsyncedEntries();
    if (unsyncedEntries.isNotEmpty) {
      await _apiClient.syncWeightEntries(unsyncedEntries);
      for (var entry in unsyncedEntries) {
        await _weightDataSource.markAsSynced(entry.id);
      }
    }
  }

  Future<void> _syncReminders() async {
    // Implement reminder sync
  }

  void dispose() {
    _syncTimer?.cancel();
  }
}
