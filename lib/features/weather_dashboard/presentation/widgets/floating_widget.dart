import 'dart:math' as math;
import 'package:flutter/material.dart';

class FloatingWidget extends StatefulWidget {
  final Widget child;
  final double offset;
  final Duration duration;

  const FloatingWidget({
    super.key,
    required this.child,
    this.offset = 6.0,
    this.duration = const Duration(seconds: 3),
  });

  @override
  State<FloatingWidget> createState() => _FloatingWidgetState();
}

class _FloatingWidgetState extends State<FloatingWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final floatOffset = math.sin(_controller.value * math.pi) * widget.offset;
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
