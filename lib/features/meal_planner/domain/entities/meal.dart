/// Core meal entity for the meal planner feature
class Meal {
  final String id;
  final String name;
  final String description;
  final double protein;
  final double calories;
  final double carbs;
  final double fats;
  final MealCategory category;
  final DateTime date;
  final bool isLogged;
  final List<String> tags;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Meal({
    required this.id,
    required this.name,
    required this.description,
    required this.protein,
    required this.calories,
    required this.carbs,
    required this.fats,
    required this.category,
    required this.date,
    this.isLogged = false,
    this.tags = const [],
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated values
  Meal copyWith({
    String? id,
    String? name,
    String? description,
    double? protein,
    double? calories,
    double? carbs,
    double? fats,
    MealCategory? category,
    DateTime? date,
    bool? isLogged,
    List<String>? tags,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      protein: protein ?? this.protein,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      fats: fats ?? this.fats,
      category: category ?? this.category,
      date: date ?? this.date,
      isLogged: isLogged ?? this.isLogged,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'protein': protein,
      'calories': calories,
      'carbs': carbs,
      'fats': fats,
      'category': category.name,
      'date': date.toIso8601String(),
      'isLogged': isLogged,
      'tags': tags,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      protein: (json['protein'] as num).toDouble(),
      calories: (json['calories'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fats: (json['fats'] as num).toDouble(),
      category: MealCategory.values.firstWhere(
        (cat) => cat.name == json['category'],
        orElse: () => MealCategory.other,
      ),
      date: DateTime.parse(json['date'] as String),
      isLogged: json['isLogged'] as bool? ?? false,
      tags: (json['tags'] as List?)?.cast<String>() ?? [],
      imageUrl: json['imageUrl'] as String?,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'] as String) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String) 
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Meal &&
        other.id == id &&
        other.name == name &&
        other.date == date;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ date.hashCode;

  @override
  String toString() {
    return 'Meal(id: $id, name: $name, date: $date, isLogged: $isLogged)';
  }
}

/// Meal categories
enum MealCategory {
  breakfast,
  lunch,
  dinner,
  snack,
  other;

  String get displayName {
    switch (this) {
      case MealCategory.breakfast:
        return 'Breakfast';
      case MealCategory.lunch:
        return 'Lunch';
      case MealCategory.dinner:
        return 'Dinner';
      case MealCategory.snack:
        return 'Snack';
      case MealCategory.other:
        return 'Other';
    }
  }
}

/// Meal statistics entity
class MealStatistics {
  final int totalMeals;
  final int loggedMeals;
  final double loggedPercentage;
  final double totalProtein;
  final double averageProteinPerMeal;
  final DateTime startDate;
  final DateTime endDate;

  const MealStatistics({
    required this.totalMeals,
    required this.loggedMeals,
    required this.loggedPercentage,
    required this.totalProtein,
    required this.averageProteinPerMeal,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalMeals': totalMeals,
      'loggedMeals': loggedMeals,
      'loggedPercentage': loggedPercentage,
      'totalProtein': totalProtein,
      'averageProteinPerMeal': averageProteinPerMeal,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }

  factory MealStatistics.fromJson(Map<String, dynamic> json) {
    return MealStatistics(
      totalMeals: json['totalMeals'] as int,
      loggedMeals: json['loggedMeals'] as int,
      loggedPercentage: (json['loggedPercentage'] as num).toDouble(),
      totalProtein: (json['totalProtein'] as num).toDouble(),
      averageProteinPerMeal: (json['averageProteinPerMeal'] as num).toDouble(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
    );
  }
}
