import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/plate_analysis_provider.dart';
import '../widgets/analysis_result_card.dart';

class AnalysisResultScreen extends ConsumerWidget {
  const AnalysisResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(plateAnalysisNotifierProvider);
    final notifier = ref.read(plateAnalysisNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matokeo ya Uchanganuzi'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            notifier.reset();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64.sp,
                        color: AppColors.error,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        state.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24.h),
                      AppButton(
                        text: 'Jaribu Tena',
                        onPressed: () {
                          notifier.reset();
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                )
              : state.result == null
                  ? const Center(child: Text('Hakuna matokeo'))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnalysisResultCard(result: state.result!),
                          SizedBox(height: 24.h),
                          AppButton(
                            text: 'Hifadhi na Endelea',
                            onPressed: () {
                              // Save result to meal log
                              notifier.reset();
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            },
                          ),
                          SizedBox(height: 12.h),
                          AppButton(
                            text: 'Piga Picha Nyingine',
                            onPressed: () {
                              notifier.reset();
                              Navigator.pop(context);
                            },
                            isOutlined: true,
                          ),
                        ],
                      ),
                    ),
    );
  }
}
