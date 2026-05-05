import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/food.dart';
import '../providers/meal_provider.dart';

class FoodSearchDelegate extends SearchDelegate<Food?> {
  final WidgetRef ref;
  final String? userZone;

  FoodSearchDelegate(this.ref, {this.userZone});

  @override
  String get searchFieldLabel => 'Tafuta chakula...';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildFoodList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildFoodList(context);
  }

  Widget _buildFoodList(BuildContext context) {
    final foodsAsync = ref.watch(foodItemsProvider(userZone));

    return foodsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (foods) {
        final filtered = _filterFoods(foods);

        if (filtered.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search_off,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Hakuna chakula kilichopatikana',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final food = filtered[index];
            return _FoodSearchTile(
              food: food,
              onTap: () => close(context, food),
            );
          },
        );
      },
    );
  }

  List<Food> _filterFoods(List<Food> foods) {
    if (query.isEmpty) {
      // Show zonal foods first when no query
      final zonalFoods = foods.where((f) => f.zone != 'all').toList();
      final otherFoods = foods.where((f) => f.zone == 'all').toList();
      return [...zonalFoods, ...otherFoods];
    }

    final lowerQuery = query.toLowerCase();
    return foods.where((food) {
      return food.nameSw.toLowerCase().contains(lowerQuery) ||
          (food.nameEn?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }
}

class _FoodSearchTile extends StatelessWidget {
  final Food food;
  final VoidCallback onTap;

  const _FoodSearchTile({
    required this.food,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getCategoryColor(food.category).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          _getCategoryIcon(food.category),
          color: _getCategoryColor(food.category),
        ),
      ),
      title: Row(
        children: [
          Expanded(
            child: Text(
              food.nameSw,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          if (food.zone != 'all')
            Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Eneo lako',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
      subtitle: Text(
        food.nameEn ?? '',
        style: TextStyle(color: Colors.grey.shade600),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${food.caloriesPer100g.toStringAsFixed(0)} kcal',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            '${food.standardServingSize.toStringAsFixed(0)}g/${food.servingUnit}',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'carbohydrates':
        return AppColors.carbohydrates;
      case 'protein':
        return AppColors.protein;
      case 'vegetables':
        return AppColors.vegetables;
      case 'fruits':
        return AppColors.fruits;
      case 'dairy':
        return AppColors.dairy;
      case 'fats':
        return AppColors.fats;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'carbohydrates':
        return Icons.grain;
      case 'protein':
        return Icons.egg;
      case 'vegetables':
        return Icons.eco;
      case 'fruits':
        return Icons.apple;
      case 'dairy':
        return Icons.water_drop;
      case 'fats':
        return Icons.opacity;
      default:
        return Icons.fastfood;
    }
  }
}
