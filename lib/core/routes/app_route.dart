import 'package:career_lens/core/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The route configuration.
final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: RoutePath.input,
      builder: (BuildContext context, GoRouterState state) {
        return const Scaffold();
      },
      routes: [
        GoRoute(
          path: RoutePath.result,
          builder: (BuildContext context, GoRouterState state) {
            return const Scaffold();
          },
        ),
      ],
    ),
  ],
);
