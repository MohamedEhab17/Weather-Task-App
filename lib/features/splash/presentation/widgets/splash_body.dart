import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/utils/app_images.dart';

class SplashBody extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<double> scaleAnimation;

  const SplashBody({
    super.key,
    required this.fadeAnimation,
    required this.scaleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF0A0F24), // Top: #0A0F24
            Color(0xFF123A74), // Middle: #123A74
            Color(0xFF1C6DD0), // Bottom: #1C6DD0
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: RepaintBoundary(
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo container with custom BoxShadow subtle glow
                  Container(
                    width: 180.w,
                    height: 180.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x384DA3FF), // #4DA3FF with 0.22 opacity
                          blurRadius: 50,
                          spreadRadius: 3,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      AppImages.imagesLogo2,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  const Text(
                    'WEATHER',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 5,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  const Text(
                    'Task App',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 6,
                      color: Color(0xFF8FB9FF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
