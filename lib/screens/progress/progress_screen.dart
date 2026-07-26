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
    final heatmap = computeWeekHeatmap(app);
    final streak = currentStreak(app);
    final checkedIn = isCheckedInToday(app);

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
        const SizedBox(height: 24),

        GestureDetector(
          onTap: checkedIn ? null : () => performCheckIn(context.read<AppProvider>()),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: checkedIn ? AppColors.sage.withOpacity(0.12) : AppColors.gold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: checkedIn ? AppColors.sage.withOpacity(0.4) : AppColors.gold.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(checkedIn ? '✓' : '🔥', style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Text(
                  checkedIn ? 'Checked in · $streak day streak' : 'Check in today',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: checkedIn ? AppColors.sage : AppColors.goldLight),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),

        const Text('LAST 7 DAYS', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.inkCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.inkLine),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: heatmap.map((d) {
              final isToday = _isSameDay(d.date, now);
              Color cellColor;
              if (d.excused) {
                cellColor = AppColors.sage.withOpacity(0.35);
              } else if (d.pct >= 0.9) {
                cellColor = AppColors.sage;
              } else if (d.pct > 0) {
                cellColor = AppColors.gold.withOpacity(0.35 + d.pct * 0.5);
              } else {
                cellColor = Colors.white.withOpacity(0.06);
              }
              return Column(
                children: [
                  Container(
                    width: 30, height: 30,
                    decoration: BoxDecoration(
                      color: cellColor,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday ? Border.all(color: AppColors.gold, width: 1.5) : null,
                    ),
                    alignment: Alignment.center,
                    child: d.excused
                        ? const Icon(Icons.beach_access, size: 13, color: AppColors.inkDeep)
                        : (d.pct >= 0.9 ? const Icon(Icons.check, size: 13, color: AppColors.inkDeep) : null),
                  ),
                  const SizedBox(height: 5),
                  Text(_shortDay(d.date.weekday), style: const TextStyle(fontSize: 10, color: AppColors.dim)),
                ],
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 22),
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
        const Text('Balance Check — ቀጣይ sub-step ላይ ይጨመራል', style: TextStyle(fontSize: 11, color: AppColors.dim)),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  String _shortDay(int weekday) {
    const names = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return names[weekday - 1];
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
