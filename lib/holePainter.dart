import 'package:flutter/material.dart';

class HolePainter extends CustomPainter {
  double radius, width, height;
  Color color;

  HolePainter({
    @required this.radius,
    @required this.color,
    @required this.height,
    @required this.width,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()
          ..addRRect(RRect.fromLTRBR(0, 0, width, height, Radius.circular(0))),
        Path()
          ..addOval(Rect.fromCircle(
            center: Offset(
              width / 2,
              height / 2,
            ),
            radius: radius,
          ))
          ..close(),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
