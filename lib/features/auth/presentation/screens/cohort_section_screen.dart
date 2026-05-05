import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/router/routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class CohortSelectionScreen extends ConsumerStatefulWidget {
  const CohortSelectionScreen({super.key});

  @override
  ConsumerState<CohortSelectionScreen> createState() =>
      _CohortSelectionScreenState();
}

class _CohortSelectionScreenState extends ConsumerState<CohortSelectionScreen> {
  String? _selectedCohort;

  final List<Map<String, dynamic>> _cohorts = [
    {
      'id': 'mothers_children',
      'title': 'Akina Mama na Watoto',
      'description':
          'Kwa wanawake wajawazito, wanaonyonyesha, na watoto chini ya miaka 5',
      'icon': Icons.family_restroom,
    },
    {
      'id': 'adolescents',
      'title': 'Vijana',
      'description': 'Kwa vijana na vijana wachanga wenye umri wa miaka 10-19',
      'icon': Icons.school,
    },
    {
      'id': 'ncd',
      'title': 'Magonjwa Yasiyoambukiza',
      'description': 'Kwa wanaoishi na kisukari, shinikizo la damu, n.k.',
      'icon': Icons.health_and_safety,
    },
    {
      'id': 'malnutrition',
      'title': 'Utapiamlo',
      'description': 'Kwa wenye upungufu wa uzito au virutubisho',
      'icon': Icons.monitor_weight,
    },
    {
      'id': 'school_students',
      'title': 'Wanafunzi wa Shule',
      'description': 'Kwa wanafunzi wa shule za msingi na sekondari',
      'icon': Icons.book,
    },
    {
      'id': 'university_students',
      'title': 'Wanafunzi wa Vyuo Vikuu',
      'description': 'Kwa wanafunzi wa vyuo vikuu na vijana wazima',
      'icon': Icons.school_outlined,
    },
  ];

  Future<void> _handleContinue() async {
    if (_selectedCohort == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tafadhali chagua kundi lako la lishe'),
        ),
      );
      return;
    }

    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.updateCohort(_selectedCohort!);

    if (mounted) {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              context.go(Routes.home);
            },
            child: Text(l10n.skip),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.selectCohort,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.cohortDescription,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                    SizedBox(height: 24.h),
                    ..._cohorts.map((cohort) {
                      final isSelected = _selectedCohort == cohort['id'];
                      return _CohortCard(
                        title: cohort['title'],
                        description: cohort['description'],
                        icon: cohort['icon'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _selectedCohort = cohort['id'];
                          });
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppDimensions.paddingLarge),
              child: AppButton(
                text: 'Endelea',
                onPressed: _handleContinue,
                isLoading: authState.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CohortCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _CohortCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        side: BorderSide(
          color: isSelected ? AppColors.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingMedium),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: AppColors.primary, size: 24.sp),
            ],
          ),
        ),
      ),
    );
  }
}
