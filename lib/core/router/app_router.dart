import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mindpath/features/meditations/presentation/screens/meditations_home_screen.dart';
import 'package:mindpath/features/onboarding/presentation/screens/goal_setting_screen.dart';
import 'package:mindpath/features/onboarding/presentation/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const GoalSettingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MeditationsHomeScreen(),
      ),
    ],
  );
}
