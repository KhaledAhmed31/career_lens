import 'package:career_lens/core/model/service/career_predictor_service.dart';
import 'package:career_lens/core/routes/route_path.dart';
import 'package:career_lens/features/input/presentation/pages/input_page.dart';
import 'package:career_lens/features/result/presentation/pages/result_page.dart';
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
          child: InputPage(),
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
    ),
    GoRoute(
      path: RoutePath.result,
      pageBuilder: (BuildContext context, GoRouterState state) {
        return CustomTransitionPage(
          key: state.pageKey,
          transitionDuration: const Duration(milliseconds: 300), // Optional
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Use a built-in Flutter transition widget
            return FadeTransition(
              opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
              child: child,
            );
          },
          child: ResultPage(
            result: state.extra as PredictionResult,
            key: UniqueKey(),
          ),
        );
      },
    ),
  ],
);
