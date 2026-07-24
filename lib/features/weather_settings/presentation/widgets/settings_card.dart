import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: context.ext.colors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.ext.colors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.ext.colors.primaryLight,
            ),
            child: Icon(icon, color: context.ext.colors.primary, size: 20.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Text(
              title,
              style: context.text.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
