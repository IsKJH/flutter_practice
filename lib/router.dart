import 'package:flutter/material.dart';
import 'package:flutter_practice/screens/error/error_screen.dart';
import 'package:flutter_practice/widgets/layout.dart';
import 'package:go_router/go_router.dart';

import 'screens/home/home_screen.dart';
import 'screens/interview/interview_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: "/",
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Layout(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/",
                name: "home",
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/interview",
                name: "interview",
                builder: (context, state) => const InterviewScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/:path(.*)",
        builder: (context, state) => const ErrorScreen(),
      ),
    ],
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: const ErrorScreen(),
      );
    },
  );

  static GoRouter get router => _router;
}
