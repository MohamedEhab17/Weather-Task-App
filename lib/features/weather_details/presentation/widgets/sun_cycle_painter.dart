import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SunCyclePainter extends CustomPainter {
  final double progress;
  final Color lineColor;
  final Color greyColor;

  SunCyclePainter({
    required this.progress,
    required this.lineColor,
    required this.greyColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double topPadding = 20.0;
    final center = Offset(size.width / 2, size.height);
    final radius = math.min(size.height - topPadding, size.width / 2.2);

    final arcPaint = Paint()
      ..color = greyColor.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(rect, math.pi, math.pi, false, arcPaint);

    final completedPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    canvas.drawArc(rect, math.pi, math.pi * progress, false, completedPaint);

    final sunAngle = math.pi + (math.pi * progress);
    final sunX = center.dx + radius * math.cos(sunAngle);
    final sunY = center.dy + radius * math.sin(sunAngle);

    final sunPaintOuter = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final sunPaintInner = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(sunX, sunY),
      12.r,
      Paint()
        ..color = Colors.amber.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(Offset(sunX, sunY), 7.r, sunPaintOuter);
    canvas.drawCircle(Offset(sunX, sunY), 4.r, sunPaintInner);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
