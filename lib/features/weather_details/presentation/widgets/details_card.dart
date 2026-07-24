import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.desc,
    this.footer,
  });

  final IconData icon;
  final String title;
  final String value;
  final String desc;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: context.ext.colors.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: context.ext.colors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: context.ext.colors.primary, size: 20.sp),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  title,
                  style: context.text.bodyMedium!.copyWith(
                    color: context.ext.colors.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: context.text.headlineSmall!.copyWith(
                  fontWeight: FontWeight.w800,
                  color: context.ext.colors.textPrimary,
                ),
              ),
              if (footer != null) ...[
                SizedBox(height: 4.h),
                footer!,
              ],
              SizedBox(height: 2.h),
              Text(
                desc,
                style: context.text.labelSmall!.copyWith(
                  color: context.ext.colors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
