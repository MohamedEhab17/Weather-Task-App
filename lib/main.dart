import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_widget/home_widget.dart';
import 'package:http/http.dart' as http; // ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'package:workmanager/workmanager.dart';
import 'package:device_preview/device_preview.dart';
import 'dart:convert';

import 'package:weather_task_app/core/constants/api_keys.dart';
import 'package:weather_task_app/core/di/injection.dart';
import 'package:weather_task_app/core/routers/app_router.dart';
import 'package:weather_task_app/core/theme/app_theme.dart';
import 'package:weather_task_app/core/theme/cubit/theme_cubit.dart';
import 'package:weather_task_app/core/localization/cubit/language_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';
import 'package:weather_task_app/features/weather_search/presentation/cubit/search_cubit.dart';
import 'package:weather_task_app/core/settings/cubit/settings_cubit.dart';

const String _widgetBgTaskKey = 'weatherWidgetUpdate';

@pragma('vm:entry-point')
void _workmanagerCallback() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    if (taskName == _widgetBgTaskKey) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final favorites = prefs.getStringList('favorite_cities') ?? [];
        if (favorites.isEmpty) return true;

        final city = favorites.first;
        final isCelsius = prefs.getBool('is_celsius') ?? true;
        final apiKey = Api.apiKey;

        final url = Uri.parse(
          '${Api.baseUrl}${Api.current}?key=$apiKey&q=$city&aqi=no',
        );

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final location = data['location']['name'] as String;
          final tempC = (data['current']['temp_c'] as num).round();
          final tempF = (data['current']['temp_f'] as num).round();
          final condition = data['current']['condition']['text'] as String;

          final temp = isCelsius ? '$tempC°C' : '$tempF°F';

          await HomeWidget.saveWidgetData<String>('widget_city', location);
          await HomeWidget.saveWidgetData<String>('widget_temp', temp);
          await HomeWidget.saveWidgetData<String>('widget_condition', condition);
          await HomeWidget.updateWidget(
            androidName: 'WeatherWidgetProvider',
            iOSName: 'WeatherWidgetProvider',
          );
        }
      } catch (_) {
        // Silently fail; widget keeps showing last known data
      }
    }
    return true;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  await EasyLocalization.ensureInitialized();
  AppRouter.initRouter();

  // Initialize WorkManager for background widget updates every 15 minutes
  await Workmanager().initialize(_workmanagerCallback);
  await Workmanager().registerPeriodicTask(
    _widgetBgTaskKey,
    _widgetBgTaskKey,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
  );

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
