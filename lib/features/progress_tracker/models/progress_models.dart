import 'package:flutter/material.dart';

// Models for API integration
class NutritionData {
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatsPercentage;
  final double fiberPercentage;
  final double vitaminsPercentage;

  // New fields for optimized progress tracker
  final int weeklyCalories;
  final int recommendedCalories;
  final double carbs;
  final double protein;
  final double fats;
  final double water;
  final int nutritionScore;

  const NutritionData({
    required this.proteinPercentage,
    required this.carbsPercentage,
    required this.fatsPercentage,
    required this.fiberPercentage,
    required this.vitaminsPercentage,
    required this.weeklyCalories,
    required this.recommendedCalories,
    required this.carbs,
    required this.protein,
    required this.fats,
    required this.water,
    required this.nutritionScore,
  });

  List<double> toList() {
    return [
      proteinPercentage / 100,
      carbsPercentage / 100,
      fatsPercentage / 100,
      fiberPercentage / 100,
      vitaminsPercentage / 100,
    ];
  }

  // JSON serialization for caching
  Map<String, dynamic> toJson() {
    return {
      'proteinPercentage': proteinPercentage,
      'carbsPercentage': carbsPercentage,
      'fatsPercentage': fatsPercentage,
      'fiberPercentage': fiberPercentage,
      'vitaminsPercentage': vitaminsPercentage,
      'weeklyCalories': weeklyCalories,
      'recommendedCalories': recommendedCalories,
      'carbs': carbs,
      'protein': protein,
      'fats': fats,
      'water': water,
      'nutritionScore': nutritionScore,
    };
  }

  factory NutritionData.fromJson(Map<String, dynamic> json) {
    return NutritionData(
      proteinPercentage: json['proteinPercentage']?.toDouble() ?? 0.0,
      carbsPercentage: json['carbsPercentage']?.toDouble() ?? 0.0,
      fatsPercentage: json['fatsPercentage']?.toDouble() ?? 0.0,
      fiberPercentage: json['fiberPercentage']?.toDouble() ?? 0.0,
      vitaminsPercentage: json['vitaminsPercentage']?.toDouble() ?? 0.0,
      weeklyCalories: json['weeklyCalories']?.toInt() ?? 0,
      recommendedCalories: json['recommendedCalories']?.toInt() ?? 0,
      carbs: json['carbs']?.toDouble() ?? 0.0,
      protein: json['protein']?.toDouble() ?? 0.0,
      fats: json['fats']?.toDouble() ?? 0.0,
      water: json['water']?.toDouble() ?? 0.0,
      nutritionScore: json['nutritionScore']?.toInt() ?? 0,
    );
  }
}

class ProgressDataPoint {
  final DateTime date;
  final double value;

  const ProgressDataPoint({
    required this.date,
    required this.value,
  });
}

class ProgressData {
  final List<ProgressDataPoint> calorieData;
  final List<ProgressDataPoint> proteinData;
  final List<ProgressDataPoint> weightData;

  // New fields for optimized progress tracker
  final int weeklyMealsLogged;
  final double weeklyProtein;
  final double weeklyProgress;
  final DateTime lastUpdated;
  final int streak;
  final double goalProgress;

  const ProgressData({
    required this.calorieData,
    required this.proteinData,
    required this.weightData,
    required this.weeklyMealsLogged,
    required this.weeklyProtein,
    required this.weeklyProgress,
    required this.lastUpdated,
    required this.streak,
    required this.goalProgress,
  });

  // JSON serialization for caching
  Map<String, dynamic> toJson() {
    return {
      'weeklyMealsLogged': weeklyMealsLogged,
      'weeklyProtein': weeklyProtein,
      'weeklyProgress': weeklyProgress,
      'lastUpdated': lastUpdated.toIso8601String(),
      'streak': streak,
      'goalProgress': goalProgress,
      'calorieData': calorieData
          .map((point) => {
                'date': point.date.toIso8601String(),
                'value': point.value,
              })
          .toList(),
      'proteinData': proteinData
          .map((point) => {
                'date': point.date.toIso8601String(),
                'value': point.value,
              })
          .toList(),
      'weightData': weightData
          .map((point) => {
                'date': point.date.toIso8601String(),
                'value': point.value,
              })
          .toList(),
    };
  }

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      weeklyMealsLogged: json['weeklyMealsLogged']?.toInt() ?? 0,
      weeklyProtein: json['weeklyProtein']?.toDouble() ?? 0.0,
      weeklyProgress: json['weeklyProgress']?.toDouble() ?? 0.0,
      lastUpdated: DateTime.parse(
          json['lastUpdated'] ?? DateTime.now().toIso8601String()),
      streak: json['streak']?.toInt() ?? 0,
      goalProgress: json['goalProgress']?.toDouble() ?? 0.0,
      calorieData: (json['calorieData'] as List?)
              ?.map((point) => ProgressDataPoint(
                    date: DateTime.parse(point['date']),
                    value: point['value']?.toDouble() ?? 0.0,
                  ))
              .toList() ??
          [],
      proteinData: (json['proteinData'] as List?)
              ?.map((point) => ProgressDataPoint(
                    date: DateTime.parse(point['date']),
                    value: point['value']?.toDouble() ?? 0.0,
                  ))
              .toList() ??
          [],
      weightData: (json['weightData'] as List?)
              ?.map((point) => ProgressDataPoint(
                    date: DateTime.parse(point['date']),
                    value: point['value']?.toDouble() ?? 0.0,
                  ))
              .toList() ??
          [],
    );
  }
}

class ActivityEntry {
  final String title;
  final DateTime timestamp;
  final IconData icon;
  final Color color;
  final String? details;

  const ActivityEntry({
    required this.title,
    required this.timestamp,
    required this.icon,
    required this.color,
    this.details,
  });

  String get timeString {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
