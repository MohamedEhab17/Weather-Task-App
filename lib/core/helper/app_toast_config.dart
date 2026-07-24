import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:toastification/toastification.dart';
import 'package:weather_task_app/core/extensions/localization_ex.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';
import 'package:weather_task_app/core/localization/translation_keys.dart';
import 'package:weather_task_app/core/routers/app_router.dart';

class AppToastConfig {
  AppToastConfig._();

  static void show(
    BuildContext context, {
    required ToastificationType type,
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
    IconData? iconData,
  }) {
    final rootContext = AppRouter.router.routerDelegate.navigatorKey.currentContext ?? context;
    final colors = rootContext.ext.colors;
    final isDark = rootContext.theme.brightness == Brightness.dark;

    toastification.show(
      context: rootContext,
      type: type,
      style: ToastificationStyle.minimal,
      title: Text(
        title ?? defaultTitle(context, type),
        style: context.text.titleMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
        ),
      ),
      description: Text(
        message,
        style: context.text.bodyMedium!.copyWith(
          color: colors.textSecondary,
        ),
      ),
      alignment: Alignment.topCenter,
      autoCloseDuration: duration,
      animationDuration: const Duration(milliseconds: 400),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      icon: Icon(
        iconData ?? defaultIcon(type),
        color: typeColor(context, type),
        size: 24.sp,
      ),
      showIcon: true,
      showProgressBar: true,
      progressBarTheme: ProgressIndicatorThemeData(
        color: typeColor(context, type),
        linearMinHeight: 3.h,
        linearTrackColor: context.ext.colors.greyLight,
      ),
      closeButton: ToastCloseButton(
        showType: CloseButtonShowType.onHover,
        buttonBuilder: (context, onPressed) => IconButton(
          onPressed: onPressed,
          icon: Icon(
            Icons.close_rounded,
            size: 16.sp,
            color: colors.textSecondary,
          ),
        ),
      ),
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      borderRadius: BorderRadius.circular(24.r),
      backgroundColor: isDark 
          ? context.ext.colors.primaryLight.withValues(alpha: 0.9)
          : Colors.white.withValues(alpha: 0.9),
      borderSide: BorderSide(
        color: typeColor(context, type).withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: context.colors.onSurface.withValues(
            alpha: isDark ? 0.3 : 0.08,
          ),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static Color typeColor(BuildContext context, ToastificationType type) {
    final colors = context.ext.colors;
    switch (type) {
      case ToastificationType.success:
        return colors.success;
      case ToastificationType.error:
        return colors.error;
      case ToastificationType.warning:
        return colors.warning;
      case ToastificationType.info:
        return colors.info;
      default:
        return colors.primary;
    }
  }

  static String defaultTitle(BuildContext context, ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return context.trContext(TK.toastSuccess);
      case ToastificationType.error:
        return context.trContext(TK.toastError);
      case ToastificationType.warning:
        return context.trContext(TK.toastWarning);
      case ToastificationType.info:
        return context.trContext(TK.toastInfo);
      default:
        return context.trContext(TK.toastInfo);
    }
  }

  static IconData defaultIcon(ToastificationType type) {
    switch (type) {
      case ToastificationType.success:
        return Icons.check_circle_rounded;
      case ToastificationType.error:
        return Icons.error_rounded;
      case ToastificationType.warning:
        return Icons.warning_amber_rounded;
      case ToastificationType.info:
        return Icons.info_outline_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }
}
