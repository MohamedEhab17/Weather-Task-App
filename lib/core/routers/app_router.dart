import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/routers/app_router_paths.dart';
import 'package:weather_task_app/features/splash/presentation/views/splash_view.dart';
import 'package:weather_task_app/core/weather/domain/entities/weather_entity.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/views/main_navigation_view.dart';
import 'package:weather_task_app/features/weather_details/presentation/views/weather_details_view.dart';

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
          builder: (context, state) => const MainNavigationView(),
        ),
        GoRoute(
          path: AppRoutesPaths.details,
          name: 'details',
          pageBuilder: (context, state) {
            final weather = state.extra as WeatherEntity?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: WeatherDetailsView(weather: weather),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return SlideTransition(
                  position: animation.drive(
                    Tween<Offset>(
                      begin: const Offset(0.0, 0.08),
                      end: Offset.zero,
                    ).chain(CurveTween(curve: Curves.easeOutCubic)),
                  ),
                  child: FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
