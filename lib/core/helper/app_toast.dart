import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:weather_task_app/core/helper/app_toast_config.dart';

class AppToast {
  AppToast._();

  static void success(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) => AppToastConfig.show(
    context,
    type: ToastificationType.success,
    message: message,
    title: title,
    duration: duration,
  );

  static void error(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) => AppToastConfig.show(
    context,
    type: ToastificationType.error,
    message: message,
    title: title,
    duration: duration,
  );

  static void info(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) => AppToastConfig.show(
    context,
    type: ToastificationType.info,
    message: message,
    title: title,
    duration: duration,
  );

  static void warning(
    BuildContext context, {
    required String message,
    String? title,
    Duration duration = const Duration(seconds: 3),
  }) => AppToastConfig.show(
    context,
    type: ToastificationType.warning,
    message: message,
    title: title,
    duration: duration,
  );
}
