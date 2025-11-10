import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_scaffold.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';

/// AppRouter sets up navigation routes for the app
class AppRouter {
  /// Main GoRouter instance with all routes
  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      // ShellRoute wraps main scaffold
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          // Home route
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          // History route
          GoRoute(
            path: '/history',
            name: 'history',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HistoryScreen()),
          ),
          // Stats route
          GoRoute(
            path: '/stats',
            name: 'stats',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: StatsScreen()),
          ),
          // Settings route
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsScreen()),
          ),
        ],
      ),
    ],
  );
}
