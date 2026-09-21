import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'presentation/dashboard/dashboard_screen.dart';
import 'presentation/assessment/assessment_screen.dart';
import 'presentation/plan/plan_screen.dart';
import 'presentation/placeholder/placeholder_screen.dart';
import 'presentation/shell/app_shell.dart';
import 'presentation/theme/app_theme.dart';

class SdetCoachApp extends StatelessWidget {
  const SdetCoachApp({super.key});

  static final _router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/plan',
            builder: (context, state) => const PlanScreen(),
          ),
          GoRoute(
            path: '/assessment',
            builder: (context, state) => const AssessmentScreen(),
          ),
          GoRoute(
            path: '/learn',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Learn',
              icon: Icons.menu_book_outlined,
            ),
          ),
          GoRoute(
            path: '/mock',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Mock Interview',
              icon: Icons.record_voice_over_outlined,
            ),
          ),
          GoRoute(
            path: '/progress',
            builder: (context, state) => const PlaceholderScreen(
              title: 'Progress',
              icon: Icons.insights_outlined,
            ),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Senior SDET Interview Coach',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.light,
    darkTheme: AppTheme.dark,
    themeMode: ThemeMode.system,
    routerConfig: _router,
  );
}
