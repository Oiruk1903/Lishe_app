import 'package:flutter/material.dart';
import 'package:lishe_app/features/meal_planner/controllers/meal_planner_controller.dart';
import 'package:lishe_app/features/meal_planner/models/meal.dart';

class AIRecommendationsPanel extends StatefulWidget {
  final Function(Meal) onMealSelected;

  const AIRecommendationsPanel({
    super.key,
    required this.onMealSelected,
  });

  @override
  State<AIRecommendationsPanel> createState() => _AIRecommendationsPanelState();
}

class _AIRecommendationsPanelState extends State<AIRecommendationsPanel> {
  final MealPlannerController _controller = MealPlannerController();
  List<Meal> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final recommendations = await _controller.getPersonalizedRecommendations();
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading recommendations: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'AI-Powered Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _loadRecommendations,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_recommendations.isEmpty)
            const Center(
              child: Text('No recommendations available'),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  final meal = _recommendations[index];
                  return Card(
                    margin: const EdgeInsets.only(right: 16),
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            meal.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${meal.calories} calories',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Protein: ${meal.protein}g',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Carbs: ${meal.carbs}g',
                            style: const TextStyle(fontSize: 12),
                          ),
                          Text(
                            'Fat: ${meal.fat}g',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            onPressed: () => widget.onMealSelected(meal),
                            child: const Text('Add to Plan'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
} 