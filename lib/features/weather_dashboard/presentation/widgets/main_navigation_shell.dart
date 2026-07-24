import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/theme/weather_theme_helper.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/bottom_nav_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_state.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/views/weather_dashboard_view.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/app_nav_bar.dart';
import 'package:weather_task_app/features/weather_search/presentation/views/weather_search_view.dart';
import 'package:weather_task_app/features/weather_settings/presentation/views/weather_settings_view.dart';

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
          bottomNavigationBar: AppNavBar(
            currentIndex: _currentIndex,
            onTabTapped: _onTabTapped,
          ),
        );
      },
    );
  }
}
