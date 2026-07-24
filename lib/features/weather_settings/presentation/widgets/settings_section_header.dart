import 'package:flutter/material.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class SettingsSectionHeader extends StatelessWidget {
  const SettingsSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.text.bodySmall!.copyWith(
        color: context.ext.colors.textSecondary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ).forText(title),
    );
  }
}
