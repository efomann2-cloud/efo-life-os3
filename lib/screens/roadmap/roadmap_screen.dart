import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../data/pillar_data.dart';
import '../../services/roadmap_service.dart';

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final now = DateTime.now();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: AppColors.inkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.inkLine),
          ),
          child: const Text(
            '"I can do all things through Christ who strengthens me." — Philippians 4:13',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.parchmentDim),
          ),
        ),

        ...kPillars.map((pillar) {
          final color = Color(pillar.color);
          return Container(
            margin: const EdgeInsets.only(bottom: 18),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inkCard,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.inkLine),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(pillar.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(pillar.label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.parchment))),
                ]),
                const SizedBox(height: 14),
                ...List.generate(pillar.stages.length, (i) {
                  final stage = pillar.stages[i];
                  final reached = stageTimeReached(app, i, now);
                  final perf = reached ? stagePerformance(app, pillar.category, i, now) : 0.0;
                  final unlocked = reached && perf >= 0.75;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: unlocked ? color.withOpacity(0.12) : Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: unlocked ? color.withOpacity(0.5) : AppColors.inkLine),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Icon(
                            unlocked ? Icons.star : (reached ? Icons.star_half : Icons.star_border),
                            size: 16,
                            color: unlocked ? color : (reached ? AppColors.gold : AppColors.dim),
                          ),
                          const SizedBox(width: 6),
                          Text(stage.label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: unlocked ? AppColors.parchment : AppColors.dim)),
                          const Spacer(),
                          if (!reached)
                            Text('Starts in ${daysUntilStage(app, i, now)}d', style: const TextStyle(fontSize: 10, color: AppColors.dim))
                          else
                            Text('${(perf * 100).round()}%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: unlocked ? color : AppColors.goldLight)),
                        ]),
                        const SizedBox(height: 8),
                        ...stage.milestones.map((m) => Padding(
                              padding: const EdgeInsets.only(bottom: 3, left: 22),
                              child: Text('• $m', style: TextStyle(fontSize: 11.5, color: unlocked ? AppColors.parchmentDim : AppColors.dim, height: 1.4)),
                            )),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }
}
