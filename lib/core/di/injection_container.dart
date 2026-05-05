import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize first');
});

Future<void> initializeDependencies() async {
  await SharedPreferences.getInstance();

  // Override providers
  // This will be done in main.dart
}
