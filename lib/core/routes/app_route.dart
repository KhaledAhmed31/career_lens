import 'package:career_lens/core/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  initialLocation: RoutePath.input,
  routes: [
    GoRoute(
      path: RoutePath.input,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: Scaffold(),
          transitionDuration: const Duration(milliseconds: 300), // Optional
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Use a built-in Flutter transition widget
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: RoutePath.result,
          pageBuilder: (BuildContext context, GoRouterState state) {
            return CustomTransitionPage(
              key: state.pageKey,
              transitionDuration: const Duration(milliseconds: 300), // Optional
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    // Use a built-in Flutter transition widget
                    return FadeTransition(
                      opacity: CurveTween(
                        curve: Curves.easeInOut,
                      ).animate(animation),
                      child: child,
                    );
                  },
              child: Scaffold(),
            );
          },
        ),
      ],
    ),
  ],
);
