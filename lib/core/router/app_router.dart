import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/cohort_section_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/meal_logging/presentation/screens/meal_logging_screen.dart';
import '../../features/meal_planner/views/optimized_meal_planner.dart';
import '../../features/progress_tracker/views/optimized_progress_tracker.dart';
import '../../features/weight_tracking/presentation/screens/weight_progress_screen.dart';
import '../../features/chatbot/presentation/screens/chat_screen.dart';
import 'routes.dart';

final appRouterProvider = Provider<AppRouter>((ref) {
  return AppRouter();
});

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>();

  late final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.login,
    routes: [
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: Routes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: Routes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.cohortSelection,
        name: 'cohortSelection',
        builder: (context, state) => const CohortSelectionScreen(),
      ),
      GoRoute(
        path: Routes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: Routes.mealLogging,
        name: 'mealLogging',
        builder: (context, state) => const MealLoggingScreen(),
      ),
      GoRoute(
        path: Routes.mealPlanner,
        name: 'mealPlanner',
        builder: (context, state) => const OptimizedMealPlannerView(),
      ),
      GoRoute(
        path: Routes.progressTracker,
        name: 'progressTracker',
        builder: (context, state) => const OptimizedProgressTrackerView(),
      ),
      GoRoute(
        path: Routes.weightProgress,
        name: 'weightProgress',
        builder: (context, state) => const WeightProgressScreen(),
      ),
      GoRoute(
        path: Routes.chat,
        name: 'chat',
        builder: (context, state) => const ChatScreen(),
      ),
      // Placeholder routes for remaining features
      GoRoute(
        path: Routes.settings,
        name: 'settings',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: const Center(child: Text('Settings - Coming Soon')),
        ),
      ),
      GoRoute(
        path: Routes.plateAnalysis,
        name: 'plateAnalysis',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Plate Analysis')),
          body: const Center(child: Text('Plate Analysis - Coming Soon')),
        ),
      ),
      GoRoute(
        path: Routes.reminders,
        name: 'reminders',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Reminders')),
          body: const Center(child: Text('Reminders - Coming Soon')),
        ),
      ),
      GoRoute(
        path: Routes.foodSearch,
        name: 'foodSearch',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Food Search')),
          body: const Center(child: Text('Food Search - Coming Soon')),
        ),
      ),
    ],
  );
}
