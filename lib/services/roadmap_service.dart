import '../providers/app_provider.dart';
import '../data/study_data.dart';
import '../utils/date_utils.dart';

DateTime missionStartDate(AppProvider app) {
  final raw = app.getString('mission_start_date', fallback: app.getString('journey_start_date'));
  if (raw.isEmpty) return DateTime.now();
  final parts = raw.split('-').map(int.parse).toList();
  return DateTime(parts[0], parts[1], parts[2]);
}

DateTime stageStartDate(AppProvider app, int stageIndex) {
  final start = missionStartDate(app);
  return start.add(Duration(days: 365 * stageIndex));
}

double _dayStudyFraction(AppProvider app, DateTime d) {
  final dsDone = app.getBoolList('daystudy_${dateKeyFor(d)}', kDayStudyLength).where((e) => e).length;
  final nsDone = app.getBoolList('nightstudy_${dateKeyFor(d)}', kNightStudyTasks.length).where((e) => e).length;
  final total = kDayStudyTasks.length + kNightStudyTasks.length;
  return total == 0 ? 0 : (dsDone + nsDone) / total;
}

double stagePerformance(AppProvider app, String category, int stageIndex, DateTime now) {
  final start = stageStartDate(app, stageIndex);
  final end = stageStartDate(app, stageIndex + 1);
  final windowEnd = now.isBefore(end) ? now : end;
  if (windowEnd.isBefore(start)) return 0;

  if (category == 'academic') {
    int days = 0;
    double sum = 0;
    var d = DateTime(start.year, start.month, start.day);
    final last = DateTime(windowEnd.year, windowEnd.month, windowEnd.day);
    while (!d.isAfter(last)) {
      sum += _dayStudyFraction(app, d);
      days++;
      d = d.add(const Duration(days: 1));
    }
    return days == 0 ? 0 : sum / days;
  }

  if (category == 'spiritual' || category == 'extracurricular') {
    final prefix = category == 'spiritual' ? 'bible' : 'gk';
    int weeks = 0;
    double sum = 0;
    var w = start;
    while (!w.isAfter(windowEnd)) {
      final weekKey = weekStartKeyFor(w);
      final count = app.getBoolList('${prefix}_$weekKey', 7).where((e) => e).length;
      sum += count / 7;
      weeks++;
      w = w.add(const Duration(days: 7));
    }
    return weeks == 0 ? 0 : sum / weeks;
  }

  if (category == 'business') {
    final list = app.getMapList('summer_plan');
    if (list.isEmpty) return 0;
    final done = list.where((g) => g['done'] == true).length;
    return done / list.length;
  }

  return 0;
}

bool stageTimeReached(AppProvider app, int stageIndex, DateTime now) {
  return !now.isBefore(stageStartDate(app, stageIndex));
}

bool stageUnlocked(AppProvider app, String category, int stageIndex, DateTime now) {
  if (!stageTimeReached(app, stageIndex, now)) return false;
  return stagePerformance(app, category, stageIndex, now) >= 0.75;
}

int daysUntilStage(AppProvider app, int stageIndex, DateTime now) {
  final start = stageStartDate(app, stageIndex);
  return start.difference(DateTime(now.year, now.month, now.day)).inDays;
}
