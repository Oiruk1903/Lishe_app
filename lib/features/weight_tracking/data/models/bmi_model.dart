class BmiModel {
  final double bmi;
  final String category;
  final String categorySw;
  final String advice;
  final String adviceSw;
  final double weightKg;
  final double heightCm;
  final String? recordedAt;
  final double idealWeightKg;
  final double idealWeightMin;
  final double idealWeightMax;
  final double targetBmi;
  final double weightToTargetKg;

  const BmiModel({
    required this.bmi,
    required this.category,
    required this.categorySw,
    required this.advice,
    required this.adviceSw,
    required this.weightKg,
    required this.heightCm,
    this.recordedAt,
    required this.idealWeightKg,
    required this.idealWeightMin,
    required this.idealWeightMax,
    required this.targetBmi,
    required this.weightToTargetKg,
  });

  factory BmiModel.fromJson(Map<String, dynamic> json) => BmiModel(
        bmi: (json['bmi'] as num?)?.toDouble() ?? 0.0,
        category: json['category'] as String? ?? '',
        categorySw: json['categorySw'] as String? ?? '',
        advice: json['advice'] as String? ?? '',
        adviceSw: json['adviceSw'] as String? ?? '',
        weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0.0,
        heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0.0,
        recordedAt: json['recordedAt'] as String?,
        idealWeightKg: (json['idealWeightKg'] as num?)?.toDouble() ?? 0.0,
        idealWeightMin: (json['idealWeightMin'] as num?)?.toDouble() ?? 0.0,
        idealWeightMax: (json['idealWeightMax'] as num?)?.toDouble() ?? 0.0,
        targetBmi: (json['targetBmi'] as num?)?.toDouble() ?? 22.5,
        weightToTargetKg: (json['weightToTargetKg'] as num?)?.toDouble() ?? 0.0,
      );
}
