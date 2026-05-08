import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lishe_app/features/auth/domain/entities/user.dart' show User;
import 'package:lishe_app/core/constants/app_colors.dart';
import 'package:lishe_app/core/router/routes.dart';
import 'package:go_router/go_router.dart';

class WelcomeCard extends StatelessWidget {
  final User? user;

  const WelcomeCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [AppColors.cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Habari, ${user?.fullName.split(' ').first ?? 'Mpendwa'}!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (user?.cohort != null)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    _getCohortDisplayName(user!.cohort!),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Je, umekula leo? Weka milo yako ili kufuatilia lishe bora.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.push(Routes.mealLogging);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 12.h,
              ),
            ),
            child: const Text('Weka Mlo'),
          ),
        ],
      ),
    );
  }

  String _getCohortDisplayName(String cohortId) {
    switch (cohortId) {
      case 'mothers_children':
        return 'Mama na Mtoto';
      case 'adolescents':
        return 'Vijana';
      case 'ncd':
        return 'NCD';
      case 'malnutrition':
        return 'Utapiamlo';
      case 'school_students':
        return 'Mwanafunzi';
      default:
        return 'Mtu Mzima';
    }
  }
}
