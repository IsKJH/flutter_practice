import 'package:flutter/material.dart';
import 'package:flutter_practice/screens/auth/login_screen.dart';
import 'package:flutter_practice/screens/error/error_screen.dart';
import 'package:flutter_practice/services/auth_service.dart';
import 'package:flutter_practice/widgets/layout.dart';
import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/interview/interview_screen.dart';
import '../screens/mypage/mypage_screen.dart';
import '../screens/search/search_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: "/",
    redirect: (context, state) async {
      final authService = AuthService();
      final isLoggedIn = await authService.isLoggedIn();

      if (state.matchedLocation == "/login" && isLoggedIn) {
        return "/";
      }
      if (state.matchedLocation != "/login" && !isLoggedIn) {
        return "/login";
      }
      return null;
    },
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
                path: "/search",
                name: "search",
                builder: (context, state) => const SearchScreen(),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: "/mypage",
                name: "mypage",
                builder: (context, state) => const MyPageScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
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
