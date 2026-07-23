import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/di/injection.dart';
import 'package:weather_task_app/core/routers/app_router.dart';
import 'package:weather_task_app/core/theme/app_theme.dart';
import 'package:weather_task_app/core/theme/cubit/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize easy localization
  await EasyLocalization.ensureInitialized();

  // Initialize Router
  AppRouter.initRouter();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const WeatherTaskApp(),
    ),
  );
}

class WeatherTaskApp extends StatelessWidget {
  const WeatherTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit()..loadSavedTheme(),
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          return ScreenUtilInit(
            designSize: const Size(360, 690), // standard mobile design size
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Weather Task App',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode == AppThemeMode.light
                    ? ThemeMode.light
                    : ThemeMode.dark,
                routerConfig: AppRouter.router,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
              );
            },
          );
        },
      ),
    );
  }
}
