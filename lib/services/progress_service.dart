import '../providers/app_provider.dart';
import '../data/schedule_data.dart';
import '../data/study_data.dart';
import '../data/gk_data.dart';
import '../data/bible_data.dart';
import '../utils/date_utils.dart';

class TodayStats {
  final int done;
  final int total;
  const TodayStats(this.done, this.total);
  double get pct => total == 0 ? 0 : done / total;
}

TodayStats computeTodayStats(AppProvider app, DateTime now) {
  final shift = app.getString('shift_pref', fallback: 'morning');
  final key = scheduleKeyForToday(now.weekday, shift);
  final blocks = kSchedules[key]!;
  final dKey = dateKeyFor(now);

  final scheduleDone = app.getBoolList('schedule_$dKey', blocks.length).where((e) => e).length;
  final dsDone = app.getBoolList('daystudy_$dKey', kDayStudyTasks.length).where((e) => e).length;
  final nsDone = app.getBoolList('nightstudy_$dKey', kNightStudyTasks.length).where((e) => e).length;

  final todayIdx = now.weekday % 7;
  final weekKey = weekStartKeyFor(now);
  final gkDoneToday = app.getBoolList('gk_$weekKey', 7)[todayIdx] ? 1 : 0;
  final bibleDoneToday = app.getBoolList('bible_$weekKey', 7)[todayIdx] ? 1 : 0;

  final done = scheduleDone + dsDone + nsDone + gkDoneToday + bibleDoneToday;
  final total = blocks.length + kDayStudyTasks.length + kNightStudyTasks.length + 1 + 1;

  return TodayStats(done, total);
}

int weeklyCount(AppProvider app, String prefix, DateTime now) {
  final weekKey = weekStartKeyFor(now);
  return app.getBoolList('${prefix}_$weekKey', 7).where((e) => e).length;
}
