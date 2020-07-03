import 'package:flutter/material.dart';

class CurvedDecoratorPainter extends CustomPainter {
  final Color color;
  final double radius;

  CurvedDecoratorPainter({@required this.color, @required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTWH(0, 0, size.width, size.height);
    final center = Offset(shapeBounds.center.dx, shapeBounds.top);
    //final circleBounds =
    //Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()..color = color;
    /*final backgroundPath = Path()
    ..moveTo(shapeBounds.left, shapeBounds.top) //3
    ..lineTo(shapeBounds.bottomLeft.dx, shapeBounds.bottomLeft.dy) //4
    ..arcTo(circleBounds, -pi, pi, false) //5
    ..lineTo(shapeBounds.bottomRight.dx, shapeBounds.bottomRight.dy) //6
    ..lineTo(shapeBounds.topRight.dx, shapeBounds.topRight.dy) //7
    ..close();
    canvas.drawPath(backgroundPath, paint);*/
    Path path = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.drawShadow(path, Colors.grey.withAlpha(30), 3.0, true);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CurvedDecoratorPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

class CurvedDecorator extends StatelessWidget {
  final Color color;
  final double radius;

  CurvedDecorator({@required this.color, @required this.radius});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite, //2
      painter: CurvedDecoratorPainter(color: color, radius: radius), //3
    );
  }
}
