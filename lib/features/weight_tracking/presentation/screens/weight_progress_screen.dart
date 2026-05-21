import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../providers/weight_provider.dart';
import '../widgets/bmi_gauge.dart';
import '../widgets/action_plan_card.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/weight_entry.dart';
import '../../../auth/domain/entities/user.dart';

class WeightProgressScreen extends ConsumerStatefulWidget {
  const WeightProgressScreen({super.key});

  @override
  ConsumerState<WeightProgressScreen> createState() =>
      _WeightProgressScreenState();
}

class _WeightProgressScreenState extends ConsumerState<WeightProgressScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _noteController = TextEditingController();
  bool _showAddForm = false;

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weightEntriesAsync = ref.watch(weightEntriesProvider);
    final currentWeightAsync = ref.watch(currentWeightProvider);
    final bmiAsync = ref.watch(bmiProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Maendeleo ya Uzito'),
        actions: [
          IconButton(
            icon: Icon(_showAddForm ? Icons.close : Icons.add),
            onPressed: () {
              setState(() {
                _showAddForm = !_showAddForm;
                if (!_showAddForm) {
                  _weightController.clear();
                  _noteController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.paddingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Weight and BMI Card
            _buildSummaryCard(context, currentWeightAsync, bmiAsync, user),
            SizedBox(height: 20.h),

            // Add Weight Form (if visible)
            if (_showAddForm) ...[
              _buildAddWeightForm(context),
              SizedBox(height: 20.h),
            ],

            // Weight Chart
            Text(
              'Historia ya Uzito',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            _buildWeightChart(context, weightEntriesAsync),
            SizedBox(height: 20.h),

            // Action Plan
            if (user?.targetWeight != null && currentWeightAsync.value != null)
              ActionPlanCard(
                currentWeight: currentWeightAsync.value!.weight,
                targetWeight: user!.targetWeight!,
                height: user.height ?? 165,
                gender: user.gender,
              ),
            SizedBox(height: 20.h),

            // Weight History List
            Text(
              'Rekodi za Uzito',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 12.h),
            _buildHistoryList(context, weightEntriesAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    AsyncValue<WeightEntry?> currentWeightAsync,
    AsyncValue<double?> bmiAsync,
    User? user,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Uzito wa Sasa',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      currentWeightAsync.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('--'),
                        data: (entry) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                entry?.weight.toStringAsFixed(1) ?? '--',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                              ),
                              Text(
                                ' kg',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      if (user?.targetWeight != null &&
                          currentWeightAsync.value != null)
                        Text(
                          'Lengo: ${user!.targetWeight!.toStringAsFixed(1)} kg',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 60.h,
                  color: AppColors.divider,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'BMI',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      bmiAsync.when(
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('--'),
                        data: (bmi) {
                          if (bmi == null) {
                            return Column(
                              children: [
                                const Text('--'),
                                Text(
                                  'Weka urefu',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            );
                          }
                          return BMIGauge(bmi: bmi.bmi);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddWeightForm(BuildContext context) {
    final state = ref.watch(addWeightNotifierProvider);
    final notifier = ref.read(addWeightNotifierProvider.notifier);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weka Uzito Mpya',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16.h),
            AppTextField(
              label: 'Uzito (kg)',
              controller: _weightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                final weight = double.tryParse(value);
                if (weight != null) notifier.updateWeight(weight);
              },
            ),
            SizedBox(height: 12.h),
            AppTextField(
              label: 'Urefu (cm) — Si lazima ukishasainisha',
              controller: _heightController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                notifier.updateHeight(double.tryParse(value));
              },
            ),
            SizedBox(height: 12.h),
            AppTextField(
              label: 'Maelezo (Si lazima)',
              controller: _noteController,
              onChanged: notifier.updateNote,
            ),
            if (state.errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: Text(
                  state.errorMessage!,
                  style: TextStyle(color: AppColors.error, fontSize: 12.sp),
                ),
              ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Ghairi',
                    onPressed: () {
                      setState(() {
                        _showAddForm = false;
                        _weightController.clear();
                        _heightController.clear();
                        _noteController.clear();
                      });
                    },
                    isOutlined: true,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppButton(
                    text: 'Hifadhi',
                    onPressed: () async {
                      if (_weightController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tafadhali weka uzito')),
                        );
                        return;
                      }
                      final success = await notifier.submit();
                      if (success && mounted) {
                        setState(() {
                          _showAddForm = false;
                          _weightController.clear();
                          _heightController.clear();
                          _noteController.clear();
                        });
                        notifier.reset();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Uzito umehifadhiwa!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    isLoading: state.isSubmitting,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightChart(
      BuildContext context, AsyncValue<List<WeightEntry>> asyncValue) {
    return Container(
      height: 200.h,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [AppColors.cardShadow],
      ),
      child: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (entries) {
          if (entries.length < 2) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 40.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Weka angalau vipimo viwili vya uzito',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          final spots = entries.asMap().entries.map((e) {
            return FlSpot(e.key.toDouble(), e.value.weight);
          }).toList();

          final minWeight =
              entries.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
          final maxWeight =
              entries.map((e) => e.weight).reduce((a, b) => a > b ? a : b);

          return LineChart(
            LineChartData(
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: AppColors.divider,
                    strokeWidth: 0.5,
                  );
                },
              ),
              titlesData: FlTitlesData(
                show: true,
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: entries.length > 5
                        ? (entries.length / 5).floorToDouble()
                        : 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index >= 0 && index < entries.length) {
                        final date = entries[index].recordedAt;
                        return Text(
                          '${date.day}/${date.month}',
                          style: TextStyle(fontSize: 10.sp),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toStringAsFixed(0),
                        style: TextStyle(fontSize: 10.sp),
                      );
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: (entries.length - 1).toDouble(),
              minY: (minWeight - 2).floorToDouble(),
              maxY: (maxWeight + 2).ceilToDouble(),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.3,
                  color: AppColors.primary,
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: AppColors.primary,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                ),
              ],
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: AppColors.primary,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final index = spot.x.toInt();
                      final entry = entries[index];
                      return LineTooltipItem(
                        '${entry.weight.toStringAsFixed(1)} kg\n${entry.recordedAt.day}/${entry.recordedAt.month}',
                        const TextStyle(color: Colors.white),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(
      BuildContext context, AsyncValue<List<WeightEntry>> asyncValue) {
    return asyncValue.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
      data: (entries) {
        if (entries.isEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 32.h),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 40.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Bado hujaweka rekodi yoyote ya uzito',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: entries.length,
          itemBuilder: (context, index) {
            final entry = entries.reversed.toList()[index];
            final previousEntry = index < entries.length - 1
                ? entries.reversed.toList()[index + 1]
                : null;
            final change = previousEntry != null
                ? entry.weight - previousEntry.weight
                : 0.0;

            return ListTile(
              leading: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.monitor_weight,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
              ),
              title: Text('${entry.weight.toStringAsFixed(1)} kg'),
              subtitle: Text(
                '${entry.recordedAt.day}/${entry.recordedAt.month}/${entry.recordedAt.year}',
              ),
              trailing: change != 0
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color:
                            (change < 0 ? AppColors.success : AppColors.error)
                                .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            change < 0
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            size: 12.sp,
                            color: change < 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            '${change.abs().toStringAsFixed(1)} kg',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: change < 0
                                  ? AppColors.success
                                  : AppColors.error,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}
