import 'package:flutter/material.dart';
import 'package:weather_task_app/core/widgets/custom_loading_indicator.dart';

class ModalProgressHUD extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;
  final Color color;
  final double size;

  const ModalProgressHUD({
    super.key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.35,
    this.color = Colors.black,
    this.size = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (inAsyncCall) ...[
          Positioned.fill(
            child: ModalBarrier(
              dismissible: false,
              color: color.withValues(alpha: opacity),
            ),
          ),
          Center(
            child: CustomLoadingIndicator(size: size),
          ),
        ],
      ],
    );
  }
}
