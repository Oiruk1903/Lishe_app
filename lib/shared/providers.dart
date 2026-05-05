import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/local_storage_service.dart';

// Local Storage Service Provider
final localStorageServiceProvider =
    FutureProvider<LocalStorageService>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return LocalStorageService(prefs);
});

// Locale Provider
final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('en');
});

// Theme Mode Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

// App Router Provider
final appRouterProvider = FutureProvider((ref) {
  throw UnimplementedError('AppRouter initialization required');
});
