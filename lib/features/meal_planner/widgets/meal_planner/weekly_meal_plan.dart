import 'package:flutter/material.dart';
import 'package:lishe_app/features/meal_planner/models/meal.dart';
import 'package:lishe_app/features/meal_planner/services/meal_service.dart';

class WeeklyMealPlan extends StatefulWidget {
  final DateTime startDate;
  final Function(DateTime, String, Meal) onMealSelected;

  const WeeklyMealPlan({
    super.key,
    required this.startDate,
    required this.onMealSelected,
  });

  @override
  State<WeeklyMealPlan> createState() => _WeeklyMealPlanState();
}

class _WeeklyMealPlanState extends State<WeeklyMealPlan> {
  final MockMealService _mealService = MockMealService();
  final Map<String, List<Meal?>> _weeklyPlan = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateWeeklyPlan();
  }

  Future<void> _generateWeeklyPlan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Generate meals for each day of the week
      for (int i = 0; i < 7; i++) {
        final date = widget.startDate.add(Duration(days: i));
        final dayMeals = {
          'breakfast': _mealService.getSuggestedMealByType('breakfast'),
          'lunch': _mealService.getSuggestedMealByType('lunch'),
          'dinner': _mealService.getSuggestedMealByType('dinner'),
        };
        _weeklyPlan[date.toString()] = dayMeals.values.toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating meal plan: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Meal Plan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _generateWeeklyPlan,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 7,
              itemBuilder: (context, index) {
                final date = widget.startDate.add(Duration(days: index));
                final meals = _weeklyPlan[date.toString()] ?? [];
                return _buildDayPlan(date, meals);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayPlan(DateTime date, List<Meal?> meals) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getDayName(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildMealRow('Breakfast', meals.isNotEmpty ? meals[0] : null, date, 'breakfast'),
            const Divider(),
            _buildMealRow('Lunch', meals.length > 1 ? meals[1] : null, date, 'lunch'),
            const Divider(),
            _buildMealRow('Dinner', meals.length > 2 ? meals[2] : null, date, 'dinner'),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow(String mealType, Meal? meal, DateTime date, String mealTypeKey) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              mealType,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: meal != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${meal.calories} cal | P: ${meal.protein}g | C: ${meal.carbs}g | F: ${meal.fat}g',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  )
                : const Text('No meal planned'),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (meal != null) {
                widget.onMealSelected(date, mealTypeKey, meal);
              }
            },
          ),
        ],
      ),
    );
  }

  String _getDayName(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return '${date.day}/${date.month} - ${_getWeekdayName(date.weekday)}';
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
} 