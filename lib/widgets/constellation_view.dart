import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/pillar_data.dart';

class ConstellationView extends StatelessWidget {
  final List<List<bool>> unlockedMap; // [pillarIndex][stageIndex]
  final List<List<bool>> reachedMap;  // time-reached but maybe not unlocked
  const ConstellationView({super.key, required this.unlockedMap, required this.reachedMap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.inkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inkLine),
      ),
      child: CustomPaint(
        size: Size.infinite,
        painter: _ConstellationPainter(
          unlockedMap: unlockedMap,
          reachedMap: reachedMap,
          colors: kPillars.map((p) => Color(p.color)).toList(),
          labels: kPillars.map((p) => p.icon).toList(),
        ),
      ),
    );
  }
}

class _ConstellationPainter extends CustomPainter {
  final List<List<bool>> unlockedMap;
  final List<List<bool>> reachedMap;
  final List<Color> colors;
  final List<String> labels;

  _ConstellationPainter({
    required this.unlockedMap,
    required this.reachedMap,
    required this.colors,
    required this.labels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pillarCount = unlockedMap.length;
    final stageCount = unlockedMap.isNotEmpty ? unlockedMap[0].length : 3;
    final colWidth = size.width / pillarCount;

    // background faint dots
    final bgDotPaint = Paint()..color = Colors.white.withOpacity(0.04);
    for (int i = 0; i < 26; i++) {
      final dx = (i * 53) % size.width.toInt();
      final dy = (i * 31) % size.height.toInt();
      canvas.drawCircle(Offset(dx.toDouble(), dy.toDouble()), 1.2, bgDotPaint);
    }

    final List<List<Offset>> positions = [];

    for (int p = 0; p < pillarCount; p++) {
      final colCenterX = colWidth * (p + 0.5);
      final List<Offset> colPositions = [];
      for (int s = 0; s < stageCount; s++) {
        // stage 0 at bottom, last stage at top
        final t = s / (stageCount - 1);
        final y = size.height * (0.88 - t * 0.72);
        final wiggle = (s.isEven ? -1 : 1) * colWidth * 0.12;
        final x = colCenterX + wiggle;
        colPositions.add(Offset(x, y));
      }
      positions.add(colPositions);
    }

    // draw connecting lines within each pillar
    for (int p = 0; p < pillarCount; p++) {
      final color = colors[p % colors.length];
      for (int s = 0; s < stageCount - 1; s++) {
        final a = positions[p][s];
        final b = positions[p][s + 1];
        final bothUnlocked = unlockedMap[p][s] && unlockedMap[p][s + 1];
        final linePaint = Paint()
          ..color = bothUnlocked ? color.withOpacity(0.8) : Colors.white.withOpacity(0.08)
          ..strokeWidth = bothUnlocked ? 1.6 : 1.0;
        canvas.drawLine(a, b, linePaint);
      }
    }

    // draw stars
    for (int p = 0; p < pillarCount; p++) {
      final color = colors[p % colors.length];
      for (int s = 0; s < stageCount; s++) {
        final pos = positions[p][s];
        final unlocked = unlockedMap[p][s];
        final reached = reachedMap[p][s];

        if (unlocked) {
          final glowPaint = Paint()
            ..color = color.withOpacity(0.35)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
          canvas.drawCircle(pos, 10, glowPaint);
          final starPaint = Paint()..color = color;
          _drawStar(canvas, pos, 6, starPaint);
        } else if (reached) {
          final ringPaint = Paint()
            ..color = AppColors.gold.withOpacity(0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4;
          canvas.drawCircle(pos, 5, ringPaint);
        } else {
          final dimPaint = Paint()
            ..color = Colors.white.withOpacity(0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2;
          canvas.drawCircle(pos, 4, dimPaint);
        }
      }

      // pillar icon label at bottom
      final textPainter = TextPainter(
        text: TextSpan(text: labels[p], style: const TextStyle(fontSize: 14)),
        textDirection: TextDirection.ltr,
      )..layout();
      final labelPos = Offset(positions[p][0].dx - textPainter.width / 2, size.height * 0.94);
      textPainter.paint(canvas, labelPos);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 5;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.45;
      final angle = (i * 3.14159 / points) - 3.14159 / 2;
      final x = center.dx + r * _cos(angle);
      final y = center.dy + r * _sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  double _cos(double a) => (a).isNaN ? 0 : _mathCos(a);
  double _sin(double a) => (a).isNaN ? 0 : _mathSin(a);
  double _mathCos(double x) {
    // simple wrapper to avoid importing dart:math separately in comments
    return _dartMathCos(x);
  }
  double _mathSin(double x) => _dartMathSin(x);

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) {
    return true;
  }
}

double _dartMathCos(double x) => _cosImpl(x);
double _dartMathSin(double x) => _sinImpl(x);
