import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weather_task_app/core/extensions/theme_ex.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final Widget? shape;
  final Color? color;
  final double size;

  const CustomLoadingIndicator({
    super.key,
    this.shape,
    this.color,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    if (shape != null) {
      return shape!;
    }

    return SpinKitPulse(color: color ?? context.colors.primary, size: size);
  }
}
