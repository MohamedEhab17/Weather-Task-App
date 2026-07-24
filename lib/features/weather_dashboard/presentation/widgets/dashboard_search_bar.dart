import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({super.key, required this.onSearchTap});

  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: context.ext.colors.cardBackground,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: context.ext.colors.cardBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              color: context.ext.colors.textSecondary,
              size: 20.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              context.trContext(TK.weatherSearchHint),
              style: context.text.bodyMedium!.copyWith(
                color: context.ext.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
