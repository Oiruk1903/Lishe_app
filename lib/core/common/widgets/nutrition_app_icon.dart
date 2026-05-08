import 'package:flutter/material.dart';

class NutritionAppIcon extends StatelessWidget {
  final double size;
  final Color color;

  const NutritionAppIcon({
    super.key,
    this.size = 80,
    this.color = const Color(0xFF1B5E20),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _NutritionIconPainter(color: color)),
    );
  }
}

class _NutritionIconPainter extends CustomPainter {
  final Color color;

  _NutritionIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Draw apple and fork combination
    // Fork tine 1
    _drawForkTine(canvas, centerX - 12, centerY - 20, paint);
    // Fork tine 2
    _drawForkTine(canvas, centerX, centerY - 20, paint);
    // Fork tine 3
    _drawForkTine(canvas, centerX + 12, centerY - 20, paint);

    // Fork handle
    final handlePath =
        Path()
          ..moveTo(centerX - 4, centerY)
          ..quadraticBezierTo(
            centerX - 6,
            centerY + 15,
            centerX - 3,
            centerY + 25,
          )
          ..quadraticBezierTo(
            centerX + 3,
            centerY + 25,
            centerX + 6,
            centerY + 15,
          )
          ..quadraticBezierTo(centerX + 4, centerY, centerX, centerY - 5)
          ..close();

    canvas.drawPath(handlePath, paint);

    // Draw apple on side
    final applePaint =
        Paint()
          ..color = const Color(0xFFD32F2F)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX + 20, centerY - 10), 8, applePaint);
    canvas.drawPath(
      _createAppleStemLeaf(centerX + 20, centerY - 18),
      Paint()
        ..color = const Color(0xFF4CAF50)
        ..style = PaintingStyle.fill,
    );
  }

  void _drawForkTine(Canvas canvas, double x, double y, Paint paint) {
    final path =
        Path()
          ..moveTo(x - 1, y)
          ..lineTo(x - 2, y + 8)
          ..lineTo(x + 2, y + 8)
          ..lineTo(x + 1, y)
          ..close();
    canvas.drawPath(path, paint);
  }

  Path _createAppleStemLeaf(double x, double y) {
    return Path()
      ..moveTo(x, y)
      ..quadraticBezierTo(x - 2, y - 4, x - 4, y - 6)
      ..quadraticBezierTo(x - 2, y - 5, x, y - 3)
      ..close();
  }

  @override
  bool shouldRepaint(_NutritionIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// Alternative: Plate and cutlery icon
class HealthyPlateIcon extends StatelessWidget {
  final double size;
  final Color color;

  const HealthyPlateIcon({
    super.key,
    this.size = 80,
    this.color = const Color(0xFF1B5E20),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _HealthyPlateIconPainter(color: color)),
    );
  }
}

class _HealthyPlateIconPainter extends CustomPainter {
  final Color color;

  _HealthyPlateIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    const plateRadius = 30.0;

    // Draw plate rim
    final platePaint =
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    canvas.drawCircle(Offset(centerX, centerY), plateRadius, platePaint);

    // Draw plate fill
    final plateFillPaint =
        Paint()
          ..color = color.withValues(alpha: 0.1)
          ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), plateRadius, plateFillPaint);

    // Draw plate sections (like food groups)
    // Protein section (red)
    final proteinArc =
        Paint()
          ..color = const Color(0xFFE91E63)
          ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: plateRadius - 2,
      ),
      -1.57,
      1.57,
      true,
      proteinArc,
    );

    // Carbs section (orange)
    final carbsArc =
        Paint()
          ..color = const Color(0xFFFF9800)
          ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: plateRadius - 2,
      ),
      0,
      1.57,
      true,
      carbsArc,
    );

    // Veggies section (green)
    final veggiesArc =
        Paint()
          ..color = const Color(0xFF4CAF50)
          ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: plateRadius - 2,
      ),
      1.57,
      1.57,
      true,
      veggiesArc,
    );

    // Fork on right
    _drawFork(canvas, centerX + plateRadius + 10, centerY, color);
  }

  void _drawFork(Canvas canvas, double x, double y, Color color) {
    final forkPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;

    // Fork handle
    canvas.drawLine(Offset(x, y + 8), Offset(x, y - 8), forkPaint);

    // Fork tines
    for (int i = -1; i <= 1; i++) {
      canvas.drawLine(
        Offset(x + (i * 2), y - 8),
        Offset(x + (i * 2), y - 15),
        forkPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_HealthyPlateIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
