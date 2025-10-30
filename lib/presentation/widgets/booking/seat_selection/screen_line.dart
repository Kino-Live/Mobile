import 'package:flutter/material.dart';

class ScreenLine extends StatelessWidget {
  const ScreenLine({super.key, required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22,
      child: CustomPaint(
        painter: _ArcPainter(color),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  _ArcPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(6, 0, size.width - 12, size.height * 1.6);
    const pi = 3.1415926535;
    final start = 200 * pi / 180;
    final sweep = 140 * pi / 180;
    canvas.drawArc(rect, start, sweep, false, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}