import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/routers/app_router_paths.dart';
import 'package:weather_task_app/features/splash/presentation/views/splash_view.dart';

class AppRouter {
  static late final GoRouter router;

  static void initRouter() {
    router = GoRouter(
      initialLocation: AppRoutesPaths.splash,
      routes: [
        GoRoute(
          path: AppRoutesPaths.splash,
          name: 'splash',
          builder: (context, state) => const SplashView(),
        ),
        GoRoute(
          path: AppRoutesPaths.home,
          name: 'home',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Weather Dashboard')),
          ),
        ),
      ],
    );
  }
}
