import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class ActionPlanCard extends StatelessWidget {
  final double currentWeight;
  final double targetWeight;
  final double height;
  final String gender;

  const ActionPlanCard({
    super.key,
    required this.currentWeight,
    required this.targetWeight,
    required this.height,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final difference = targetWeight - currentWeight;
    final isGain = difference > 0;
    final weeks = difference.abs() / 0.5;
    final goalDate = DateTime.now().add(Duration(days: (weeks * 7).round()));

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.track_changes,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Mpango wa Kufikia Lengo',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Lengo: ${targetWeight.toStringAsFixed(1)} kg',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        isGain ? 'Ongeza uzito' : 'Punguza uzito',
                        style: TextStyle(
                          color: isGain ? Colors.blue : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: currentWeight / targetWeight,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isGain ? Colors.blue : AppColors.success,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Tarehe ya kukadiriwa: ${goalDate.day}/${goalDate.month}/${goalDate.year}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              'Hatua za Kufuata:',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8.h),
            ..._getActionSteps(isGain).map((step) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                          child: Text(step, style: TextStyle(fontSize: 13.sp))),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List<String> _getActionSteps(bool isGain) {
    if (isGain) {
      return [
        'Ongeza kalori 500 kwa siku kwa kula mara kwa mara',
        'Kula vyakula vyenye protini nyingi kama nyama, samaki, maharage',
        'Ongeza mafuta yenye afya kama parachichi, karanga',
        'Fanya mazoezi ya kujenga misuli mara 3 kwa wiki',
      ];
    } else {
      return [
        'Punguza sukari na vinywaji vyenye sukari',
        'Ongeza mboga na matunda katika kila mlo',
        'Kunywa maji lita 2 kila siku',
        'Tembea kwa dakika 30 kila siku',
        'Punguza vyakula vya kukaanga na mafuta mengi',
      ];
    }
  }
}
