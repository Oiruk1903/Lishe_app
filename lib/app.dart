import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/constants/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/services/lazy_loading_service.dart';
import 'l10n/app_localizations.dart';
import 'shared/provides.dart';

class LisheApp extends ConsumerStatefulWidget {
  const LisheApp({super.key});

  @override
  ConsumerState<LisheApp> createState() => _LisheAppState();
}

class _LisheAppState extends ConsumerState<LisheApp> {
  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    // Initialize services with timeout to prevent hanging
    try {
      // Initialize notification service in background
      await NotificationService.initialize()
          .timeout(const Duration(seconds: 2));
      print('Notification service initialized');
    } catch (e) {
      print('Notification service initialization failed: $e');
      // Continue without notifications if it fails
    }

    // Initialize other non-critical services in background
    _initializeNonCriticalServices();
  }

  void _initializeNonCriticalServices() {
    // Initialize non-critical services without blocking UI
    Future.microtask(() async {
      try {
        // Initialize lazy loading service
        final lazyLoadingService = LazyLoadingService();
        lazyLoadingService.initializeDefaultLoaders();

        // Start loading secondary features in background
        await lazyLoadingService.loadSecondaryFeatures();

        print('Non-critical services initialization completed');
      } catch (e) {
        print('Error in non-critical services: $e');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: 'Lishe AI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('sw', 'TZ'),
            Locale('en'),
          ],
          routerConfig: router.router,
        );
      },
    );
  }
}
