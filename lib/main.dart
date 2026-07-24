import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/di/injection.dart';
import 'package:weather_task_app/core/routers/app_router.dart';
import 'package:weather_task_app/core/theme/app_theme.dart';
import 'package:weather_task_app/core/theme/cubit/theme_cubit.dart';
import 'package:weather_task_app/core/localization/cubit/language_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_cubit.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';

import 'package:flutter/foundation.dart';
import 'package:device_preview/device_preview.dart';
import 'package:toastification/toastification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  // Initialize easy localization
  await EasyLocalization.ensureInitialized();

  // Initialize Router
  AppRouter.initRouter();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        child: const WeatherTaskApp(),
      ),
    ),
  );
}

class WeatherTaskApp extends StatelessWidget {
  const WeatherTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit()..loadSavedTheme(),
        ),
        BlocProvider<LanguageCubit>(
          create: (context) => getIt<LanguageCubit>()..loadSavedLanguage(),
        ),
        BlocProvider<SettingsCubit>(
          create: (context) => getIt<SettingsCubit>()..init(),
        ),
        BlocProvider<DashboardCubit>(
          create: (context) => getIt<DashboardCubit>()..init(),
        ),
        BlocProvider<SearchCubit>(
          create: (context) => getIt<SearchCubit>()..init(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, AppThemeMode>(
        builder: (context, themeMode) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return ScreenUtilInit(
                designSize: const Size(360, 690),
                minTextAdapt: true,
                splitScreenMode: true,
                builder: (context, child) {
                  return ToastificationWrapper(
                    child: MaterialApp.router(
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
                      locale: locale,
                      builder: DevicePreview.appBuilder,
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
