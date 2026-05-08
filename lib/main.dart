import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/di/injection_container.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize critical dependencies with timeout and error handling
  try {
    await initializeDependencies().timeout(const Duration(seconds: 3));
    print('Dependencies initialized successfully');
  } catch (e) {
    print('Initialization timeout or error: $e');
    // Continue with app startup even if initialization fails
    // The app will work with default values
  }

  runApp(
    const ProviderScope(
      child: LisheApp(),
    ),
  );
}
