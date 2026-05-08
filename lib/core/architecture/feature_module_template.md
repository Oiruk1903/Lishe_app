# Standard Feature Module Architecture

## Directory Structure
```
lib/features/feature_name/
├── data/                    # Data layer implementation
│   ├── datasources/         # Remote and local data sources
│   ├── models/             # Data transfer objects (DTOs)
│   └── repositories/       # Repository implementations
├── domain/                  # Business logic layer
│   ├── entities/           # Core business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business use cases
├── presentation/           # UI layer
│   ├── providers/         # Riverpod state management
│   ├── screens/           # Full-screen widgets
│   ├── views/             # Optimized views with lazy loading
│   └── widgets/           # Reusable UI components
└── services/              # Feature-specific services
    └── feature_service.dart
```

## Naming Conventions

### Files
- Use snake_case for file names
- Feature names should be singular (e.g., `meal_planner`, not `meal_planners`)
- Views should be prefixed with `optimized_` when using lazy loading
- Services should be suffixed with `_service.dart`

### Classes
- Use PascalCase for class names
- Entities should be singular (e.g., `Meal`, not `Meals`)
- Views should be descriptive (e.g., `OptimizedMealPlannerView`)
- Services should be descriptive (e.g., `MealPlannerService`)

### Directories
- Use snake_case for directory names
- Keep consistent with feature naming

## Implementation Guidelines

### 1. Data Layer
- **Models**: Implement JSON serialization/deserialization
- **DataSources**: Handle API calls and local storage
- **Repositories**: Implement domain repository interfaces

### 2. Domain Layer
- **Entities**: Pure business objects without external dependencies
- **Repositories**: Abstract interfaces for data access
- **UseCases**: Single responsibility business logic

### 3. Presentation Layer
- **Providers**: Use Riverpod for state management
- **Views**: Implement lazy loading and caching
- **Widgets**: Keep components reusable and focused

### 4. Services
- **Feature Services**: Coordinate between layers
- **Integration**: Use shared services (Cache, LazyLoading)

## Performance Optimization

### Lazy Loading
```dart
class OptimizedFeatureView extends ConsumerStatefulWidget {
  // Implement lazy loading initialization
  Future<void> _initializeView() async {
    final lazyLoadingService = ref.read(lazyLoadingServiceProvider);
    await lazyLoadingService.loadFeature('feature_name');
  }
}
```

### Caching
```dart
class FeatureService {
  final CacheService _cacheService = CacheService();
  
  Future<FeatureData> getData() async {
    final cached = await _cacheService.get('feature_data');
    if (cached != null) return FeatureData.fromJson(cached);
    
    final data = await fetchFromApi();
    await _cacheService.set('feature_data', data.toJson(), 
                           expiration: Duration(hours: 1));
    return data;
  }
}
```

### Dependency Injection
```dart
// In injection_container.dart
final featureServiceProvider = Provider<FeatureService>((ref) {
  return FeatureService();
});

final featureDataRepositoryProvider = Provider<FeatureRepository>((ref) {
  return FeatureRepositoryImpl(
    remoteDataSource: ref.read(remoteDataSourceProvider),
    localDataSource: ref.read(localDataSourceProvider),
  );
});
```

## Migration Steps

1. **Analyze Current Structure**: Identify inconsistencies
2. **Create Standard Template**: Use this template as reference
3. **Update Feature by Feature**: Migrate one feature at a time
4. **Update Imports**: Fix all import paths
5. **Test Compilation**: Ensure all features work correctly
6. **Update Router**: Update navigation paths if needed

## Examples

### Standard Feature Implementation
```dart
// lib/features/meal_planner/services/meal_planner_service.dart
class MealPlannerService {
  final CacheService _cacheService = CacheService();
  final UnifiedMealService _unifiedMealService;
  
  MealPlannerService(this._unifiedMealService);
  
  Future<List<Meal>> getMealsForDate(DateTime date) async {
    final cacheKey = 'meals_${date.toIso8601String()}';
    final cached = await _cacheService.get(cacheKey);
    
    if (cached != null) {
      return (cached as List).map((json) => Meal.fromJson(json)).toList();
    }
    
    final meals = await _unifiedMealService.getMealsForDate(date);
    await _cacheService.set(cacheKey, meals.map((m) => m.toJson()).toList(),
                           expiration: Duration(hours: 1));
    return meals;
  }
}
```

### Optimized View Implementation
```dart
// lib/features/meal_planner/views/optimized_meal_planner_view.dart
class OptimizedMealPlannerView extends ConsumerStatefulWidget {
  @override
  ConsumerState<OptimizedMealPlannerView> createState() => _OptimizedMealPlannerViewState();
}

class _OptimizedMealPlannerViewState extends ConsumerState<OptimizedMealPlannerView>
    with AutomaticKeepAliveClientMixin {
  
  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();
    _initializeView();
  }
  
  Future<void> _initializeView() async {
    final lazyLoadingService = ref.read(lazyLoadingServiceProvider);
    await lazyLoadingService.loadFeature('meal_planner');
  }
  
  // Rest of implementation...
}
```
