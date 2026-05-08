import 'package:flutter/material.dart';

class MealPlannerDatePicker extends StatefulWidget {
  final DateTime? initialDate;
  final ValueChanged<DateTime>? onDateSelected;

  const MealPlannerDatePicker({
    super.key,
    this.initialDate,
    this.onDateSelected,
  });

  @override
  State<MealPlannerDatePicker> createState() => _MealPlannerDatePickerState();
}

class _MealPlannerDatePickerState extends State<MealPlannerDatePicker> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;
  late List<DateTime> _weekDays;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _focusedDate = widget.initialDate ?? DateTime.now();
    _updateWeekDays();
  }

  void _updateWeekDays() {
    final firstDayOfWeek = _focusedDate.subtract(
      Duration(days: _focusedDate.weekday - 1),
    );
    _weekDays = List.generate(
      7,
      (index) => firstDayOfWeek.add(Duration(days: index)),
    );
  }

  void _nextWeek() {
    setState(() {
      _focusedDate = _focusedDate.add(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  void _previousWeek() {
    setState(() {
      _focusedDate = _focusedDate.subtract(const Duration(days: 7));
      _updateWeekDays();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8), // very light gray
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${_getMonthName(_focusedDate.month)} ${_focusedDate.year}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                Row(
                  children: [
                    _buildArrowButton(
                      Icons.chevron_left_rounded,
                      _previousWeek,
                    ),
                    const SizedBox(width: 8),
                    _buildArrowButton(Icons.chevron_right_rounded, _nextWeek),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:
                  _weekDays.map((date) {
                    final isSelected =
                        date.day == _selectedDate.day &&
                        date.month == _selectedDate.month &&
                        date.year == _selectedDate.year;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                        if (widget.onDateSelected != null) {
                          widget.onDateSelected!(date);
                        }
                      },
                      child: Container(
                        width: 44,
                        height: 64,
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getWeekDayAbbr(date.weekday),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? const Color(0xFF388E3C)
                                        : const Color(0xFFBDBDBD),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFB2F2C8)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                date.day.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                      isSelected
                                          ? const Color(0xFF1B5E20)
                                          : const Color(0xFF222222),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return Material(
      color: const Color(0xFFF0F0F0),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, color: const Color(0xFF888888), size: 22),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[month - 1];
  }

  String _getWeekDayAbbr(int weekday) {
    const weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return weekdays[weekday - 1];
  }
}
