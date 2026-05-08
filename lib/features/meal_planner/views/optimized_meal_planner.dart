import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/date_picker.dart';
import '../../../shared/services/unified_meal_service.dart';
import '../../../core/services/lazy_loading_service.dart';

/// Optimized meal planner view with lazy loading and caching
class OptimizedMealPlannerView extends ConsumerStatefulWidget {
  const OptimizedMealPlannerView({super.key});

  @override
  ConsumerState<OptimizedMealPlannerView> createState() =>
      _OptimizedMealPlannerViewState();
}

class _OptimizedMealPlannerViewState
    extends ConsumerState<OptimizedMealPlannerView>
    with AutomaticKeepAliveClientMixin {
  DateTime _selectedDate = DateTime.now();
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true; // Keep state alive for better performance

  @override
  void initState() {
    super.initState();
    _initializeView();
  }

  Future<void> _initializeView() async {
    // Load meal planner feature lazily
    final lazyLoadingService = LazyLoadingService();
    await lazyLoadingService.loadFeature('meal_planner');

    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        title: const Text('Meal Planner'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),
              _buildDatePicker(),
              SizedBox(height: 8.h),
              _buildStatsRow(),
              SizedBox(height: 8.h),
              _buildMealsHeader(),
              _buildMealsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return MealPlannerDatePicker(
      initialDate: _selectedDate,
      onDateSelected: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        children: [
          Flexible(
            child: _buildStatCard(
              title: 'Calories',
              value: '1,800',
              unit: 'kcal',
              icon: Icons.local_fire_department,
              iconColor: const Color(0xFFFF7043),
            ),
          ),
          SizedBox(width: 16.w),
          Flexible(
            child: _buildStatCard(
              title: 'Drink Water',
              value: '12',
              unit: 'glass',
              icon: Icons.opacity_rounded,
              iconColor: const Color(0xFF00BFFF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      height: 110.h,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28.sp),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: const Color(0xFF222222),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3.h),
                      child: Text(
                        unit,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: const Color(0xFF888888),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Text(
        'Meals for ${_formatDate(_selectedDate)}',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF222222),
          fontFamily: 'Inter',
        ),
      ),
    );
  }

  Widget _buildMealsList() {
    return Consumer(
      builder: (context, ref, child) {
        final mealsAsync =
            ref.watch(unifiedMealsForDateProvider(_selectedDate));

        return mealsAsync.when(
          loading: () => _buildLoadingState(),
          error: (error, stack) => _buildErrorState(error),
          data: (meals) => _buildMealsContent(meals),
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          const CircularProgressIndicator(),
          SizedBox(height: 16.h),
          Text(
            'Loading meals...',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          Icon(
            Icons.error_outline,
            size: 48.sp,
            color: Colors.red[400],
          ),
          SizedBox(height: 16.h),
          Text(
            'Error loading meals',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            error.toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: _refreshData,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsContent(List<Map<String, dynamic>> meals) {
    if (meals.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Icon(
              Icons.restaurant_menu,
              size: 48.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No meals planned for this day',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: _addMeal,
              child: const Text('Add Meal'),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: meals.length,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        thickness: 0.5,
        indent: 32,
        endIndent: 32,
        color: Color(0xFFE0E0E0),
      ),
      itemBuilder: (context, index) {
        final meal = meals[index];
        return _buildMealCard(meal);
      },
    );
  }

  Widget _buildMealCard(Map<String, dynamic> meal) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      meal['name'] ?? 'Unknown Meal',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (meal['isLogged'] == true) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Text(
                          'Logged',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                    if (meal['hasPlanned'] == true &&
                        meal['isLogged'] != true) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: const Text(
                          'Planned',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    const Icon(
                      Icons.local_fire_department,
                      color: Color(0xFFFFB300),
                      size: 20,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      meal['calories']?.toString() ?? '0',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: const Color(0xFF888888),
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: (meal['images'] as List<String>? ?? [])
                .map(
                  (img) => Container(
                    margin: EdgeInsets.only(left: 6.w),
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(img),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          // Handle image loading error
                        },
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(width: 14.w),
          GestureDetector(
            onTap: () => _toggleMealStatus(meal),
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: meal['isLogged'] == true
                    ? Colors.green.withOpacity(0.1)
                    : const Color(0xFFF0F0F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                meal['isLogged'] == true ? Icons.check : Icons.add,
                color: meal['isLogged'] == true
                    ? Colors.green
                    : const Color(0xFF388E3C),
                size: 24.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> _refreshData() async {
    // Clear cache for selected date and reload
    final mealService = ref.read(unifiedMealServiceProvider);
    await mealService.clearCacheForDate(_selectedDate);

    // Invalidate provider to trigger refresh
    ref.invalidate(unifiedMealsForDateProvider(_selectedDate));
  }

  void _addMeal() {
    // Navigate to add meal screen
    // This will be implemented when we create the add meal functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add meal feature coming soon!')),
    );
  }

  void _toggleMealStatus(Map<String, dynamic> meal) {
    final mealService = ref.read(unifiedMealServiceProvider);
    final mealName = meal['name'] as String;
    final isCurrentlyLogged = meal['isLogged'] == true;

    mealService.updateMealStatus(
      _selectedDate,
      mealName,
      isLogged: !isCurrentlyLogged,
    );

    // Refresh the data
    ref.invalidate(unifiedMealsForDateProvider(_selectedDate));
  }
}
