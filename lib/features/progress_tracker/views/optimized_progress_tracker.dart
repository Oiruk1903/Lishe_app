import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/services/lazy_loading_service.dart';
import '../../../core/services/cache_service.dart';
import '../models/progress_models.dart';

/// Optimized progress tracker view with lazy loading and caching
class OptimizedProgressTrackerView extends ConsumerStatefulWidget {
  const OptimizedProgressTrackerView({super.key});

  @override
  ConsumerState<OptimizedProgressTrackerView> createState() =>
      _OptimizedProgressTrackerViewState();
}

class _OptimizedProgressTrackerViewState
    extends ConsumerState<OptimizedProgressTrackerView>
    with AutomaticKeepAliveClientMixin {
  bool _isInitialized = false;
  final CacheService _cacheService = CacheService();

  @override
  bool get wantKeepAlive => true; // Keep state alive for better performance

  @override
  void initState() {
    super.initState();
    _initializeView();
  }

  Future<void> _initializeView() async {
    if (_isInitialized) return;

    try {
      // Initialize lazy loading for progress tracker
      final lazyLoadingService = ref.read(lazyLoadingServiceProvider);
      await lazyLoadingService.loadFeature('progress_tracker');

      // Preload critical data
      await _preloadCriticalData();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing progress tracker: $e');
    }
  }

  Future<void> _preloadCriticalData() async {
    try {
      // Check if we have cached data
      final cachedProgressData = await _cacheService.get('progress_data');
      final cachedNutritionData = await _cacheService.get('nutrition_data');

      if (cachedProgressData == null || cachedNutritionData == null) {
        // Load and cache data if not available
        await _loadAndCacheData();
      }
    } catch (e) {
      debugPrint('Error preloading data: $e');
    }
  }

  Future<void> _loadAndCacheData() async {
    try {
      // Simulate API calls - in real app, these would be actual API calls
      final progressData = await _fetchProgressData();
      final nutritionData = await _fetchNutritionData();

      // Cache the data
      await _cacheService.set('progress_data', progressData.toJson(),
          expiration: const Duration(hours: 1));
      await _cacheService.set('nutrition_data', nutritionData.toJson(),
          expiration: const Duration(hours: 1));
    } catch (e) {
      debugPrint('Error loading and caching data: $e');
    }
  }

  Future<ProgressData> _fetchProgressData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return ProgressData(
      calorieData: [],
      proteinData: [],
      weightData: [],
      weeklyMealsLogged: 21,
      weeklyProtein: 420,
      weeklyProgress: 0.85,
      lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      streak: 3,
      goalProgress: 0.7,
    );
  }

  Future<NutritionData> _fetchNutritionData() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    return NutritionData(
      proteinPercentage: 15.0,
      carbsPercentage: 45.0,
      fatsPercentage: 30.0,
      fiberPercentage: 10.0,
      vitaminsPercentage: 80.0,
      weeklyCalories: 12850,
      recommendedCalories: 14000,
      carbs: 1750,
      protein: 420,
      fats: 490,
      water: 8.4,
      nutritionScore: 8,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isInitialized) {
      return _buildLoadingState();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Notifications coming soon!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildWeeklyProgressCard(),
              SizedBox(height: 20.h),
              _buildNutritionSummaryCard(),
              SizedBox(height: 20.h),
              _buildKeepItUpSection(),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Progress',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading progress data...'),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyProgressCard() {
    return FutureBuilder<ProgressData>(
      future: _getProgressData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCardSkeleton();
        }

        if (snapshot.hasError) {
          return _buildErrorCard('Failed to load progress data');
        }

        final progressData = snapshot.data!;

        return Card(
          elevation: 8,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Color(0xFF006400),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      "Weekly Progress",
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  "You've logged ${progressData.weeklyMealsLogged} meals and ${progressData.weeklyProtein}g of protein this week.",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: LinearProgressIndicator(
                    value: progressData.weeklyProgress,
                    minHeight: 12.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  children: [
                    Text(
                      "Week progress: ${(progressData.weeklyProgress * 100).toInt()}%",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "Updated ${_formatLastUpdated(progressData.lastUpdated)}",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionSummaryCard() {
    return FutureBuilder<NutritionData>(
      future: _getNutritionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCardSkeleton();
        }

        if (snapshot.hasError) {
          return _buildErrorCard('Failed to load nutrition data');
        }

        final nutritionData = snapshot.data!;

        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.restaurant_menu,
                      color: Theme.of(context).primaryColor,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      "Weekly Nutrition Summary",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "This Week",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              nutritionData.weeklyCalories.toString(),
                              style: TextStyle(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Padding(
                              padding: EdgeInsets.only(bottom: 4.h),
                              child: Text(
                                "kcal/week",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Icon(
                              Icons.compass_calibration,
                              size: 14.sp,
                              color: Colors.grey[600],
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Recommended: ${nutritionData.recommendedCalories} kcal/week",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: nutritionData.weeklyCalories /
                                nutritionData.recommendedCalories,
                            strokeWidth: 6,
                            backgroundColor: Colors.grey[200],
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.green),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "${((nutritionData.weeklyCalories / nutritionData.recommendedCalories) * 100).toInt()}%",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "of goal",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                const Divider(height: 1),
                SizedBox(height: 15.h),
                Text(
                  "Weekly Nutrient Breakdown",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildNutrientCard(
                        emoji: "🍞",
                        name: "Carbs",
                        amount: "${nutritionData.carbs}g",
                        status: "✅ Good",
                        statusColor: Colors.green,
                        percentage: 0.83,
                        backgroundColor: Colors.amber.withValues(alpha: 0.08),
                      ),
                      SizedBox(width: 10.w),
                      _buildNutrientCard(
                        emoji: "🍳",
                        name: "Protein",
                        amount: "${nutritionData.protein}g",
                        status: "⚠️ Slightly Low",
                        statusColor: Colors.orange,
                        percentage: 0.62,
                        backgroundColor: Colors.blue.withValues(alpha: 0.08),
                      ),
                      SizedBox(width: 10.w),
                      _buildNutrientCard(
                        emoji: "🥑",
                        name: "Fats",
                        amount: "${nutritionData.fats}g",
                        status: "✅ Balanced",
                        statusColor: Colors.green,
                        percentage: 0.78,
                        backgroundColor: Colors.green.withValues(alpha: 0.08),
                      ),
                      SizedBox(width: 10.w),
                      _buildNutrientCard(
                        emoji: "💧",
                        name: "Water",
                        amount: "${nutritionData.water}L",
                        status: "🚱 Try to drink more",
                        statusColor: Colors.red,
                        percentage: 0.48,
                        backgroundColor: Colors.blue.withValues(alpha: 0.08),
                        isWater: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutrientCard({
    required String emoji,
    required String name,
    required String amount,
    required String status,
    required Color statusColor,
    required double percentage,
    required Color backgroundColor,
    bool isWater = false,
  }) {
    return Container(
      width: 120.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: backgroundColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 20.sp),
              ),
              const Spacer(),
              Text(
                status,
                style: TextStyle(
                  fontSize: 8.sp,
                  color: statusColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage,
              minHeight: 4.h,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage > 0.8
                    ? Colors.green
                    : percentage > 0.6
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeepItUpSection() {
    return FutureBuilder<ProgressData>(
      future: _getProgressData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCardSkeleton();
        }

        if (snapshot.hasError) {
          return _buildErrorCard('Failed to load streak data');
        }

        final progressData = snapshot.data!;

        return Card(
          elevation: 4,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "🔄 Keep It Up!",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        "Weekly Streaks",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "🔥",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${progressData.streak}-week streak",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "of balanced nutrition",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                const Divider(height: 1),
                SizedBox(height: 20.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        "🎯",
                        style: TextStyle(fontSize: 22.sp),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Getting closer to your goal:",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "Healthy Weight",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progressData.goalProgress,
                    minHeight: 8.h,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Starting point",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      "${(progressData.goalProgress * 100).toInt()}% complete",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      "Goal",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardSkeleton() {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        height: 200.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: Colors.grey[100],
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String message) {
    return Card(
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          color: Colors.red[50],
        ),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red[400],
              size: 48.sp,
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _refreshData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Future<ProgressData> _getProgressData() async {
    try {
      final cachedData = await _cacheService.get('progress_data');
      if (cachedData != null) {
        return ProgressData.fromJson(cachedData);
      }

      final data = await _fetchProgressData();
      await _cacheService.set('progress_data', data.toJson(),
          expiration: const Duration(hours: 1));
      return data;
    } catch (e) {
      debugPrint('Error getting progress data: $e');
      rethrow;
    }
  }

  Future<NutritionData> _getNutritionData() async {
    try {
      final cachedData = await _cacheService.get('nutrition_data');
      if (cachedData != null) {
        return NutritionData.fromJson(cachedData);
      }

      final data = await _fetchNutritionData();
      await _cacheService.set('nutrition_data', data.toJson(),
          expiration: const Duration(hours: 1));
      return data;
    } catch (e) {
      debugPrint('Error getting nutrition data: $e');
      rethrow;
    }
  }

  Future<void> _refreshData() async {
    try {
      // Clear cache
      await _cacheService.remove('progress_data');
      await _cacheService.remove('nutrition_data');

      // Reload data
      await _loadAndCacheData();

      // Update UI
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatLastUpdated(DateTime lastUpdated) {
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
