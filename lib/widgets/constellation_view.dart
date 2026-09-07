import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/pillar_data.dart';

class ConstellationView extends StatelessWidget {
  final List<List<bool>> unlockedMap;
  final List<List<bool>> reachedMap;
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

    final bgDotPaint = Paint()..color = Colors.white.withOpacity(0.04);
    for (int i = 0; i < 26; i++) {
      final dx = (i * 53) % size.width.toInt();
      final dy = (i * 31) % (size.height.toInt() - 20);
      canvas.drawCircle(Offset(dx.toDouble(), dy.toDouble()), 1.2, bgDotPaint);
    }

    final List<List<Offset>> positions = [];
    for (int p = 0; p < pillarCount; p++) {
      final colCenterX = colWidth * (p + 0.5);
      final List<Offset> colPositions = [];
      for (int s = 0; s < stageCount; s++) {
        final t = stageCount > 1 ? s / (stageCount - 1) : 0.0;
        final y = size.height * (0.82 - t * 0.62);
        final wiggle = (s.isEven ? -1 : 1) * colWidth * 0.12;
        final x = colCenterX + wiggle;
        colPositions.add(Offset(x, y));
      }
      positions.add(colPositions);
    }

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
          _drawStar(canvas, pos, 6, Paint()..color = color);
        } else if (reached) {
          canvas.drawCircle(pos, 5, Paint()
            ..color = AppColors.gold.withOpacity(0.6)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.4);
        } else {
          canvas.drawCircle(pos, 4, Paint()
            ..color = Colors.white.withOpacity(0.15)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2);
        }
      }

      final textPainter = TextPainter(
        text: TextSpan(text: labels[p], style: const TextStyle(fontSize: 14)),
        textDirection: TextDirection.ltr,
      )..layout();
      final labelPos = Offset(positions[p][0].dx - textPainter.width / 2, size.height * 0.90);
      textPainter.paint(canvas, labelPos);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const points = 5;
    final path = Path();
    for (int i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.45;
      final angle = (i * math.pi / points) - math.pi / 2;
      final x = center.dx + r * math.cos(angle);
      final y = center.dy + r * math.sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ConstellationPainter oldDelegate) => true;
}
