import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class BMIGauge extends StatelessWidget {
  final double bmi;

  const BMIGauge({super.key, required this.bmi});

  @override
  Widget build(BuildContext context) {
    final category = _getBMICategory(bmi);
    final color = _getBMIColor(bmi);

    return Column(
      children: [
        Text(
          bmi.toStringAsFixed(1),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        SizedBox(
          height: 8.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: _getBMIProgress(bmi),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('18.5', style: TextStyle(fontSize: 10.sp, color: Colors.blue)),
            Text('25', style: TextStyle(fontSize: 10.sp, color: Colors.green)),
            Text('30', style: TextStyle(fontSize: 10.sp, color: Colors.orange)),
          ],
        ),
      ],
    );
  }

  String _getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Upungufu';
    if (bmi < 25) return 'Kawaida';
    if (bmi < 30) return 'Kupita Kiasi';
    return 'Unene';
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 25) return AppColors.success;
    if (bmi < 30) return AppColors.warning;
    return AppColors.error;
  }

  double _getBMIProgress(double bmi) {
    if (bmi < 18.5) return bmi / 40;
    if (bmi < 25) return (bmi - 18.5) / 40 + 0.46;
    if (bmi < 30) return (bmi - 25) / 40 + 0.62;
    return 0.75 + (bmi - 30) / 80;
  }
}
