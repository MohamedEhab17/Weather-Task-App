import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/dashboard_cubit.dart';

class DashboardErrorView extends StatelessWidget {
  const DashboardErrorView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<DashboardCubit>().init(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 150.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              key: const ValueKey('error_widget'),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: context.ext.colors.error,
                    size: 60.sp,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: context.text.titleMedium!.copyWith(
                      color: context.ext.colors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton.icon(
                    onPressed: () => context.read<DashboardCubit>().init(),
                    icon: const Icon(Icons.refresh_rounded),
                    label: Text(context.trContext(TK.done)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.ext.colors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
