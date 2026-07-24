import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class SettingsUnitOption extends StatelessWidget {
  const SettingsUnitOption({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? context.ext.colors.primary
              : context.ext.colors.greyExtraLight.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Text(
          label,
          style: context.text.bodyMedium!.copyWith(
            color: isSelected ? Colors.white : context.ext.colors.textSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
