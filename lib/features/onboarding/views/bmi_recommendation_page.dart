import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BMIRecommendationPage extends StatelessWidget {
  final double bmi;
  final String category;
  final String? message;

  const BMIRecommendationPage({
    super.key,
    required this.bmi,
    required this.category,
    this.message,
  });

  String get _statusText {
    if (category == 'underweight') {
      if (bmi < 16) {
        return 'Severely underweight';
      }
      return 'Underweight';
    }
    if (category == 'overweight') {
      if (bmi >= 30) {
        return 'Obese';
      }
      return 'Overweight';
    }
    return 'Healthy weight';
  }

  String get _recommendationText {
    if (category == 'underweight') {
      return 'Your BMI is ${bmi.toStringAsFixed(1)}, which is below the healthy range. Focus on nutrient-rich foods, regular meals, and balanced snacks. Consider tracking your calories and strength training to build healthy weight.';
    }
    if (category == 'overweight') {
      return 'Your BMI is ${bmi.toStringAsFixed(1)}, which is above the healthy range. Focus on portion control, whole foods, and regular physical activity. Small consistent changes can help you move toward a safer BMI.';
    }
    return 'Your BMI is ${bmi.toStringAsFixed(1)}, which falls inside the healthy range. Keep up the good work and continue eating balanced meals and staying active.';
  }

  Color get _backgroundColor {
    if (category == 'underweight' || category == 'overweight') {
      return const Color(0xFFFFF4E5);
    }
    return const Color(0xFFE8F5E9);
  }

  Color get _accentColor {
    if (category == 'underweight') {
      return Colors.orange.shade700;
    }
    if (category == 'overweight') {
      return Colors.red.shade700;
    }
    return Colors.green.shade700;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'BMI Recommendations',
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: _backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _accentColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? _recommendationText,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade900,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your BMI Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          bmi.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: _accentColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            'BMI',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () => context.go('/profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.go('/home'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _accentColor,
                  side: BorderSide(color: _accentColor, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Continue to Home',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
