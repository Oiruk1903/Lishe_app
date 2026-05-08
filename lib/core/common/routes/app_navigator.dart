import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../router/routes.dart';

class AppNavigator {
  static void navigateTo(BuildContext context, String route) {
    context.go(route);
  }

  static void navigateToHome(BuildContext context) {
    context.go(Routes.home);
  }

  static void navigateToProfile(BuildContext context) {
    context.go(Routes.profile);
  }

  static void navigateToMealPlanner(BuildContext context) {
    context.go(Routes.mealPlanner);
  }

  static void navigateToMealLogging(BuildContext context) {
    context.go(Routes.mealLogging);
  }

  static void navigateToProgressTracker(BuildContext context) {
    context.go(Routes.progressTracker);
  }

  static void navigateToWeightProgress(BuildContext context) {
    context.go(Routes.weightProgress);
  }

  static void navigateToChat(BuildContext context) {
    context.go(Routes.chat);
  }

  static void navigateToSettings(BuildContext context) {
    context.go(Routes.settings);
  }

  static void navigateToLogin(BuildContext context) {
    context.go(Routes.login);
  }

  static void navigateToRegister(BuildContext context) {
    context.go(Routes.register);
  }

  static void navigateToForgotPassword(BuildContext context) {
    context.go(Routes.forgotPassword);
  }

  static void navigateToCohortSelection(BuildContext context) {
    context.go(Routes.cohortSelection);
  }

  static void navigateToPlateAnalysis(BuildContext context) {
    context.go(Routes.plateAnalysis);
  }

  static void navigateToReminders(BuildContext context) {
    context.go(Routes.reminders);
  }

  static void navigateToFoodSearch(BuildContext context) {
    context.go(Routes.foodSearch);
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
