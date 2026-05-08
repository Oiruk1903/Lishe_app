import 'package:flutter/material.dart';

class NavigationItem {
  final IconData icon;
  final String label;
  final String path;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.path,
  });
}
