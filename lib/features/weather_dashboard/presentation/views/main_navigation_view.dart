import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/bottom_nav_cubit.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/widgets/main_navigation_shell.dart';

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
