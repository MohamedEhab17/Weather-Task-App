import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_task_app/core/routers/app_router_paths.dart';
import 'package:weather_task_app/features/splash/presentation/widgets/splash_body.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    final CurvedAnimation curveAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(curveAnimation);
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(curveAnimation);

    // Run animation
    _controller.forward();

    // Navigate after a delay when the animation is completed
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go(AppRoutesPaths.home);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashBody(
        fadeAnimation: _fadeAnimation,
        scaleAnimation: _scaleAnimation,
      ),
    );
  }
}
