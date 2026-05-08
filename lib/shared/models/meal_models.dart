/// Shared meal models used across the app
class MealModel {
  final String id;
  final String name;
  final int calories;
  final double protein;
  final double carbs;
  final double fat;
  final String imageUrl;
  final List<String> mealTypes;
  final List<String> ingredients;
  final String recipe;
  final String category;
  final String difficulty;
  final String description;
  final int weight;
  final int servingSize;
  final String preparationTime;

  const MealModel({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.imageUrl,
    required this.mealTypes,
    required this.ingredients,
    required this.recipe,
    this.category = 'Main Course',
    this.difficulty = 'Medium',
    this.description = '',
    this.weight = 250,
    this.servingSize = 1,
    this.preparationTime = '30 mins',
  });

  factory MealModel.fromJson(Map<String, dynamic> json) {
    return MealModel(
      id: json['id'] as String,
      name: json['name'] as String,
      calories: json['calories'] as int,
      protein: (json['protein'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      mealTypes: List<String>.from(json['mealTypes'] as List),
      ingredients: List<String>.from(json['ingredients'] as List),
      recipe: json['recipe'] as String,
      category: json['category'] as String? ?? 'Main Course',
      difficulty: json['difficulty'] as String? ?? 'Medium',
      description: json['description'] as String? ?? '',
      weight: json['weight'] as int? ?? 250,
      servingSize: json['servingSize'] as int? ?? 1,
      preparationTime: json['preparationTime'] as String? ?? '30 mins',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'imageUrl': imageUrl,
      'mealTypes': mealTypes,
      'ingredients': ingredients,
      'recipe': recipe,
      'category': category,
      'difficulty': difficulty,
      'description': description,
      'weight': weight,
      'servingSize': servingSize,
      'preparationTime': preparationTime,
    };
  }

  MealModel copyWith({
    String? id,
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    String? imageUrl,
    List<String>? mealTypes,
    List<String>? ingredients,
    String? recipe,
    String? category,
    String? difficulty,
    String? description,
    int? weight,
    int? servingSize,
    String? preparationTime,
  }) {
    return MealModel(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      imageUrl: imageUrl ?? this.imageUrl,
      mealTypes: mealTypes ?? this.mealTypes,
      ingredients: ingredients ?? this.ingredients,
      recipe: recipe ?? this.recipe,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      servingSize: servingSize ?? this.servingSize,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealModel &&
        other.id == id &&
        other.name == name &&
        other.calories == calories &&
        other.protein == protein &&
        other.carbs == carbs &&
        other.fat == fat;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        calories.hashCode ^
        protein.hashCode ^
        carbs.hashCode ^
        fat.hashCode;
  }

  @override
  String toString() {
    return 'MealModel(id: $id, name: $name, calories: $calories)';
  }
}

/// Simple meal data structure for quick operations
class SimpleMeal {
  final String name;
  final int calories;
  final List<String> images;
  final bool isLogged;
  final bool hasPlanned;
  final List<Map<String, dynamic>> loggedMeals;

  const SimpleMeal({
    required this.name,
    required this.calories,
    required this.images,
    this.isLogged = false,
    this.hasPlanned = false,
    this.loggedMeals = const [],
  });

  factory SimpleMeal.fromMap(Map<String, dynamic> map) {
    return SimpleMeal(
      name: map['name'] as String,
      calories: int.tryParse(map['calories'].toString()) ?? 0,
      images: List<String>.from(map['images'] as List? ?? []),
      isLogged: map['isLogged'] as bool? ?? false,
      hasPlanned: map['hasPlanned'] as bool? ?? false,
      loggedMeals: List<Map<String, dynamic>>.from(map['loggedMeals'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'calories': calories,
      'images': images,
      'isLogged': isLogged,
      'hasPlanned': hasPlanned,
      'loggedMeals': loggedMeals,
    };
  }
}
