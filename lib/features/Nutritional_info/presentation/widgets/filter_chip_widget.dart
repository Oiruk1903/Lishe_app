import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  const FilterChipWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: false,
      onSelected: (_) {},
    );
  }
}
