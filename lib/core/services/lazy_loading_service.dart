import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for managing lazy loading of app features and resources
class LazyLoadingService {
  static final LazyLoadingService _instance = LazyLoadingService._internal();
  factory LazyLoadingService() => _instance;
  LazyLoadingService._internal();

  final Map<String, Future<void> Function()> _loaders = {};
  final Map<String, bool> _loadedFeatures = {};
  final Map<String, Completer<void>> _loadingCompleters = {};
  
  /// Performance metrics
  final Map<String, DateTime> _loadTimes = {};

  /// Register a lazy loader for a feature
  void registerLoader(String featureName, Future<void> Function() loader) {
    _loaders[featureName] = loader;
    _loadedFeatures[featureName] = false;
  }

  /// Load a specific feature on demand
  Future<void> loadFeature(String featureName) async {
    if (_loadedFeatures[featureName] == true) {
      return; // Already loaded
    }

    if (_loadingCompleters.containsKey(featureName)) {
      // Currently loading, wait for completion
      return await _loadingCompleters[featureName]!.future;
    }

    final completer = Completer<void>();
    _loadingCompleters[featureName] = completer;

    try {
      final startTime = DateTime.now();
      
      if (_loaders.containsKey(featureName)) {
        await _loaders[featureName]!();
        _loadedFeatures[featureName] = true;
        _loadTimes[featureName] = DateTime.now();
        
        final loadDuration = DateTime.now().difference(startTime);
        if (kDebugMode) {
          print('Feature "$featureName" loaded in ${loadDuration.inMilliseconds}ms');
        }
      } else {
        throw Exception('No loader registered for feature: $featureName');
      }
      
      completer.complete();
    } catch (e) {
      completer.completeError(e);
      rethrow;
    } finally {
      _loadingCompleters.remove(featureName);
    }
  }

  /// Check if a feature is loaded
  bool isFeatureLoaded(String featureName) {
    return _loadedFeatures[featureName] ?? false;
  }

  /// Load multiple features in parallel
  Future<void> loadFeatures(List<String> featureNames) async {
    final futures = featureNames.map((name) => loadFeature(name));
    await Future.wait(futures);
  }

  /// Preload critical features (called during app startup)
  Future<void> preloadCriticalFeatures() async {
    final criticalFeatures = ['auth', 'basic_ui', 'cache'];
    
    try {
      await loadFeatures(criticalFeatures);
      if (kDebugMode) {
        print('Critical features preloaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error preloading critical features: $e');
      }
      // Continue even if preloading fails
    }
  }

  /// Load secondary features in background
  Future<void> loadSecondaryFeatures() async {
    final secondaryFeatures = ['meal_planner', 'progress_tracker', 'chatbot'];
    
    // Load without blocking
    Future.microtask(() async {
      try {
        await loadFeatures(secondaryFeatures);
        if (kDebugMode) {
          print('Secondary features loaded in background');
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error loading secondary features: $e');
        }
      }
    });
  }

  /// Get loading statistics
  Map<String, dynamic> getLoadingStats() {
    return {
      'totalFeatures': _loaders.length,
      'loadedFeatures': _loadedFeatures.values.where((loaded) => loaded).length,
      'loadingFeatures': _loadingCompleters.length,
      'loadTimes': _loadTimes.map((key, value) => 
        MapEntry(key, value.millisecondsSinceEpoch)),
    };
  }

  /// Clear all loaded features (for testing or reset)
  void clearAll() {
    _loadedFeatures.clear();
    _loadingCompleters.clear();
    _loadTimes.clear();
  }

  /// Initialize default lazy loaders
  void initializeDefaultLoaders() {
    // Authentication feature
    registerLoader('auth', () async {
      // Simulate auth initialization
      await Future.delayed(const Duration(milliseconds: 100));
    });

    // Basic UI components
    registerLoader('basic_ui', () async {
      // Simulate UI initialization
      await Future.delayed(const Duration(milliseconds: 50));
    });

    // Cache system
    registerLoader('cache', () async {
      // Initialize cache service
      await Future.delayed(const Duration(milliseconds: 200));
    });

    // Meal planner feature
    registerLoader('meal_planner', () async {
      // Initialize meal planner services
      await Future.delayed(const Duration(milliseconds: 300));
    });

    // Progress tracker feature
    registerLoader('progress_tracker', () async {
      // Initialize progress tracking services
      await Future.delayed(const Duration(milliseconds: 250));
    });

    // Chatbot feature
    registerLoader('chatbot', () async {
      // Initialize chatbot services
      await Future.delayed(const Duration(milliseconds: 400));
    });

    // Advanced features
    registerLoader('advanced_analytics', () async {
      // Initialize analytics services
      await Future.delayed(const Duration(milliseconds: 600));
    });
  }
}

/// Provider for lazy loading service
final lazyLoadingServiceProvider = Provider<LazyLoadingService>((ref) {
  return LazyLoadingService();
});

/// Async notifier for managing loading state
class LoadingStateNotifier extends AsyncNotifier<Map<String, bool>> {
  late LazyLoadingService _lazyLoadingService;

  @override
  Future<Map<String, bool>> build() async {
    _lazyLoadingService = ref.read(lazyLoadingServiceProvider);
    _lazyLoadingService.initializeDefaultLoaders();
    
    // Preload critical features
    await _lazyLoadingService.preloadCriticalFeatures();
    
    // Start loading secondary features in background
    _lazyLoadingService.loadSecondaryFeatures();
    
    return _lazyLoadingService._loadedFeatures;
  }

  /// Load a specific feature
  Future<void> loadFeature(String featureName) async {
    state = const AsyncValue.loading();
    
    try {
      await _lazyLoadingService.loadFeature(featureName);
      state = AsyncValue.data(_lazyLoadingService._loadedFeatures);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  /// Check if a feature is loaded
  bool isFeatureLoaded(String featureName) {
    return _lazyLoadingService.isFeatureLoaded(featureName);
  }

  /// Get loading statistics
  Map<String, dynamic> getLoadingStats() {
    return _lazyLoadingService.getLoadingStats();
  }
}

/// Provider for loading state
final loadingStateProvider = AsyncNotifierProvider<LoadingStateNotifier, Map<String, bool>>(
  () => LoadingStateNotifier(),
);
