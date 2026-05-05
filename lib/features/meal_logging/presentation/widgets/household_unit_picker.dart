import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class HouseholdUnitPicker extends StatelessWidget {
  final String unit;
  final double value;
  final ValueChanged<double> onChanged;

  const HouseholdUnitPicker({
    super.key,
    required this.unit,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingMedium),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$value $unit',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
              ),
              Row(
                children: [
                  _QuantityButton(
                    icon: Icons.remove,
                    onPressed: () {
                      if (value > 0.5) {
                        onChanged(value - 0.5);
                      }
                    },
                  ),
                  SizedBox(width: 8.w),
                  _QuantityButton(
                    icon: Icons.add,
                    onPressed: () {
                      onChanged(value + 0.5);
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Slider(
            value: value,
            min: 0.5,
            max: 10.0,
            divisions: 19,
            label: '$value $unit',
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0].map((q) {
              final isSelected = value == q;
              return ChoiceChip(
                label: Text('$q'),
                selected: isSelected,
                onSelected: (_) => onChanged(q),
                selectedColor: AppColors.primary.withOpacity(0.1),
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : null,
                  fontWeight: isSelected ? FontWeight.w600 : null,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _QuantityButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.primary),
        onPressed: onPressed,
        constraints: BoxConstraints(
          minWidth: 40.w,
          minHeight: 40.h,
        ),
      ),
    );
  }
}
