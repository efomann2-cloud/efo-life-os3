import '../providers/app_provider.dart';
import '../data/schedule_data.dart';
import '../data/study_data.dart';
import '../utils/date_utils.dart';

class TodayStats {
  final int done;
  final int total;
  const TodayStats(this.done, this.total);
  double get pct => total == 0 ? 0 : done / total;
}

class DayStat {
  final DateTime date;
  final double pct;
  final bool excused;
  const DayStat({required this.date, required this.pct, required this.excused});
}

TodayStats computeStatsForDate(AppProvider app, DateTime date) {
  final shift = app.getString('shift_pref', fallback: 'morning');
  final key = scheduleKeyForToday(date.weekday, shift);
  final blocks = kSchedules[key]!;
  final dKey = dateKeyFor(date);

  final scheduleDone = app.getBoolList('schedule_$dKey', blocks.length).where((e) => e).length;
  final dsDone = app.getBoolList('daystudy_$dKey', kDayStudyTasks.length).where((e) => e).length;
  final nsDone = app.getBoolList('nightstudy_$dKey', kNightStudyTasks.length).where((e) => e).length;

  final dIdx = date.weekday % 7;
  final weekKey = weekStartKeyFor(date);
  final gkDone = app.getBoolList('gk_$weekKey', 7)[dIdx] ? 1 : 0;
  final bibleDone = app.getBoolList('bible_$weekKey', 7)[dIdx] ? 1 : 0;

  final done = scheduleDone + dsDone + nsDone + gkDone + bibleDone;
  final total = blocks.length + kDayStudyTasks.length + kNightStudyTasks.length + 1 + 1;

  return TodayStats(done, total);
}

TodayStats computeTodayStats(AppProvider app, DateTime now) => computeStatsForDate(app, now);

List<DayStat> computeWeekHeatmap(AppProvider app) {
  final now = DateTime.now();
  final List<DayStat> result = [];
  for (int i = 6; i >= 0; i--) {
    final d = now.subtract(Duration(days: i));
    final stats = computeStatsForDate(app, d);
    final excused = app.getBool('excused_${dateKeyFor(d)}');
    result.add(DayStat(date: d, pct: stats.pct, excused: excused));
  }
  return result;
}

int weeklyCount(AppProvider app, String prefix, DateTime now) {
  final weekKey = weekStartKeyFor(now);
  return app.getBoolList('${prefix}_$weekKey', 7).where((e) => e).length;
}
