import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/network/ai_remote_datasource.dart';

class AnalysisResultCard extends StatelessWidget {
  final PlateAnalysisModel result;

  const AnalysisResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final hasMatches = result.matchedFoods.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──────────────────────────────────────────────────────────
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: hasMatches
                        ? AppColors.success.withOpacity(0.1)
                        : AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    hasMatches ? Icons.check_circle : Icons.info_outline,
                    color: hasMatches ? AppColors.success : AppColors.warning,
                    size: 28.sp,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasMatches
                            ? 'Vyakula Vimegunduliwa!'
                            : 'Hakuna Vyakula Vilivyolingana',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${result.identifiedFoods.length} vyakula vilivyopatikana',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 12.h),

        // ── Identified foods ─────────────────────────────────────────────────
        if (result.identifiedFoods.isNotEmpty) ...[
          Text('Vyakula Vilivyogunduliwa',
              style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 8.h),
          ...result.identifiedFoods.map((food) => Card(
                margin: EdgeInsets.only(bottom: 8.h),
                child: ListTile(
                  dense: true,
                  leading: Icon(Icons.restaurant, color: AppColors.primary),
                  title: Text(food.nameSw.isNotEmpty ? food.nameSw : food.nameEn),
                  subtitle: Text(food.nameEn),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(food.confidence * 100).toStringAsFixed(0)}%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            fontSize: 13.sp),
                      ),
                      Text(
                        '~${food.estimatedGrams.toStringAsFixed(0)}g',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 11.sp),
                      ),
                    ],
                  ),
                ),
              )),
          SizedBox(height: 12.h),
        ],

        // ── Nutrients ────────────────────────────────────────────────────────
        if (hasMatches) ...[
          Text('Lishe Iliyokokotolewa',
              style: Theme.of(context).textTheme.titleSmall),
          SizedBox(height: 8.h),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                children: [
                  _nutrientRow(context, 'Kalori',
                      '${result.nutrientSummary.totalKcal.toStringAsFixed(0)} kcal',
                      AppColors.error),
                  _nutrientRow(context, 'Protini',
                      '${result.nutrientSummary.totalProtein.toStringAsFixed(1)} g',
                      AppColors.success),
                  _nutrientRow(context, 'Wanga',
                      '${result.nutrientSummary.totalCarbs.toStringAsFixed(1)} g',
                      AppColors.warning),
                  _nutrientRow(context, 'Mafuta',
                      '${result.nutrientSummary.totalFat.toStringAsFixed(1)} g',
                      AppColors.primary),
                ],
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],

        // ── AI Explanation ───────────────────────────────────────────────────
        if (result.aiExplanation.isNotEmpty) ...[
          Card(
            color: AppColors.primary.withOpacity(0.05),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: AppColors.primary, size: 18.sp),
                      SizedBox(width: 8.w),
                      Text('Ushauri wa AI',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14.sp)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(result.aiExplanation,
                      style: TextStyle(fontSize: 13.sp, height: 1.5)),
                ],
              ),
            ),
          ),
        ],

        // ── Unmatched foods ──────────────────────────────────────────────────
        if (result.unmatchedFoods.isNotEmpty) ...[
          SizedBox(height: 12.h),
          Text('Vyakula Visivyolingana',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: AppColors.textSecondary)),
          SizedBox(height: 4.h),
          Text(result.unmatchedFoods.join(', '),
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 12.sp)),
        ],
      ],
    );
  }

  Widget _nutrientRow(
      BuildContext context, String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                  width: 8.w,
                  height: 8.w,
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle)),
              SizedBox(width: 8.w),
              Text(label, style: TextStyle(fontSize: 13.sp)),
            ],
          ),
          Text(value,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
        ],
      ),
    );
  }
}
