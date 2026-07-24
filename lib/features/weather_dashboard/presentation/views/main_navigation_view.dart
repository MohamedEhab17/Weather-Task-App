import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_task_app/core/theme/weather_theme_helper.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/bottom_nav_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/views/weather_dashboard_view.dart';
import 'package:weather_task_app/features/weather_search/presentation/views/weather_search_view.dart';
import 'package:weather_task_app/features/weather_settings/presentation/views/weather_settings_view.dart';

class MainNavigationView extends StatelessWidget {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BottomNavCubit(),
      child: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    context.read<BottomNavCubit>().setIndex(index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOutCubic,
    );
  }

  void _onFetchCity(BuildContext context, String city) {
    context.read<DashboardCubit>().fetchWeatherForCity(city);
    _onTabTapped(0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, DashboardState>(
      builder: (context, state) {
        final weather = state is DashboardSuccess ? state.weather : null;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final backgroundGradient = WeatherThemeHelper.getBackgroundGradient(
          weather,
          context.ext.colors,
          isDark,
        );

        return Scaffold(
          extendBody: true,
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: backgroundGradient),
            child: SafeArea(
              bottom: false,
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final cubit = context.read<BottomNavCubit>();
                  if (notification is ScrollUpdateNotification) {
                    final delta = notification.scrollDelta ?? 0;
                    if (delta > 3) {
                      cubit.hide();
                    } else if (delta < -3) {
                      cubit.show();
                    }
                  } else if (notification is ScrollEndNotification) {
                    cubit.show();
                  }
                  return false;
                },
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (i) {
                    setState(() => _currentIndex = i);
                    context.read<BottomNavCubit>().setIndex(i);
                  },
                  children: [
                    WeatherDashboardView(onSearchTap: () => _onTabTapped(1)),
                    WeatherSearchView(
                      onSelectCity: () => _onTabTapped(0),
                      onFetchCity: (city) => _onFetchCity(context, city),
                    ),
                    const WeatherSettingsView(),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BlocBuilder<BottomNavCubit, BottomNavState>(
            builder: (context, navState) {
              return AnimatedSlide(
                offset: navState.visible ? Offset.zero : const Offset(0, 1.5),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                child: AnimatedOpacity(
                  opacity: navState.visible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: _buildNavBar(context, isDark: isDark),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildNavBar(
    BuildContext context, {
    required bool isDark,
  }) {
    // Glassmorphic floating navbar:
    // Frosted glass effect with high-contrast text/icon colors to guarantee legibility
    final navBarBackground = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.75) // 75% dark slate glass
        : Colors.white.withValues(alpha: 0.78);            // 78% white glass

    final activeColor = isDark
        ? const Color(0xFF60A5FA)  // Bright sky blue
        : context.ext.colors.primary; // Royal blue

    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.75)  // High-visibility crisp white
        : const Color(0xFF1E293B);              // Deep slate blue

    final pillColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : context.ext.colors.primary.withValues(alpha: 0.10);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.45);

    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              color: navBarBackground,
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(color: borderColor, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  iconOutlined: Icons.wb_sunny_outlined,
                  iconFilled: Icons.wb_sunny_rounded,
                  label: context.trContext(TK.navHome),
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  pillColor: pillColor,
                ),
                _buildNavItem(
                  index: 1,
                  iconOutlined: Icons.search_rounded,
                  iconFilled: Icons.search_rounded,
                  label: context.trContext(TK.navSearch),
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  pillColor: pillColor,
                ),
                _buildNavItem(
                  index: 2,
                  iconOutlined: Icons.settings_outlined,
                  iconFilled: Icons.settings_rounded,
                  label: context.trContext(TK.weatherSettings),
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  pillColor: pillColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData iconOutlined,
    required IconData iconFilled,
    required String label,
    required Color activeColor,
    required Color inactiveColor,
    required Color pillColor,
  }) {
    final isSelected = index == _currentIndex;
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onTabTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected ? pillColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                isSelected ? iconFilled : iconOutlined,
                color: color,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: context.text.labelSmall!
                  .copyWith(
                    color: color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 10.sp,
                  )
                  .forText(label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
