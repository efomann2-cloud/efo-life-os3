import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../services/progress_service.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final now = DateTime.now();
    final stats = computeTodayStats(app, now);
    final gkWeek = weeklyCount(app, 'gk', now);
    final bibleWeek = weeklyCount(app, 'bible', now);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: SizedBox(
            width: 180, height: 180,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180, height: 180,
                  child: CircularProgressIndicator(
                    value: stats.pct,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withOpacity(0.06),
                    valueColor: const AlwaysStoppedAnimation(AppColors.gold),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('${(stats.pct * 100).round()}%', style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, color: AppColors.parchment)),
                    Text('${stats.done}/${stats.total} today', style: const TextStyle(fontSize: 12, color: AppColors.dim)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),

        const Text('THIS WEEK', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _statCard('💡 Knowledge', '$gkWeek/7')),
            const SizedBox(width: 10),
            Expanded(child: _statCard('✝ Bible', '$bibleWeek/7')),
          ],
        ),

        const SizedBox(height: 20),
        const Text('Heatmap · Streak · Balance Check — ቀጣይ sub-steps ላይ ይጨመራሉ', style: TextStyle(fontSize: 11, color: AppColors.dim)),
      ],
    );
  }

  Widget _statCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.inkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inkLine),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.goldLight)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.dim)),
        ],
      ),
    );
  }
}
