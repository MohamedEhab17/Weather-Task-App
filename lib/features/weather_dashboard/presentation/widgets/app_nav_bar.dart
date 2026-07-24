import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/features/weather_dashboard/presentation/cubit/bottom_nav_cubit.dart';

class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabTapped,
  });

  final int currentIndex;
  final void Function(int) onTabTapped;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navBarBackground = isDark
        ? const Color(0xFF1E293B).withValues(alpha: 0.75)
        : Colors.white.withValues(alpha: 0.78);

    final activeColor = isDark
        ? const Color(0xFF60A5FA)
        : context.ext.colors.primary;

    final inactiveColor = isDark
        ? Colors.white.withValues(alpha: 0.75)
        : const Color(0xFF1E293B);

    final pillColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : context.ext.colors.primary.withValues(alpha: 0.10);

    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.white.withValues(alpha: 0.45);

    return BlocBuilder<BottomNavCubit, BottomNavState>(
      builder: (context, navState) {
        return AnimatedSlide(
          offset: navState.visible ? Offset.zero : const Offset(0, 1.5),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: AnimatedOpacity(
            opacity: navState.visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            child: Container(
              margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    decoration: BoxDecoration(
                      color: navBarBackground,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(color: borderColor, width: 1.2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavItem(
                          index: 0,
                          iconOutlined: Icons.wb_sunny_outlined,
                          iconFilled: Icons.wb_sunny_rounded,
                          label: context.trContext(TK.navHome),
                          currentIndex: currentIndex,
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                          pillColor: pillColor,
                          onTap: onTabTapped,
                        ),
                        _NavItem(
                          index: 1,
                          iconOutlined: Icons.search_rounded,
                          iconFilled: Icons.search_rounded,
                          label: context.trContext(TK.navSearch),
                          currentIndex: currentIndex,
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                          pillColor: pillColor,
                          onTap: onTabTapped,
                        ),
                        _NavItem(
                          index: 2,
                          iconOutlined: Icons.settings_outlined,
                          iconFilled: Icons.settings_rounded,
                          label: context.trContext(TK.weatherSettings),
                          currentIndex: currentIndex,
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                          pillColor: pillColor,
                          onTap: onTabTapped,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.index,
    required this.iconOutlined,
    required this.iconFilled,
    required this.label,
    required this.currentIndex,
    required this.activeColor,
    required this.inactiveColor,
    required this.pillColor,
    required this.onTap,
  });

  final int index;
  final IconData iconOutlined;
  final IconData iconFilled;
  final String label;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final Color pillColor;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = index == currentIndex;
    final color = isSelected ? activeColor : inactiveColor;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: isSelected ? pillColor : Colors.transparent,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(
                isSelected ? iconFilled : iconOutlined,
                color: color,
                size: 24.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: context.text.labelSmall!
                  .copyWith(
                    color: color,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    fontSize: 10.sp,
                  )
                  .forText(label),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
