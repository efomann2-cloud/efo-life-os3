class ScheduleBlock {
  final double start; // western 24h, e.g. 8.0 = 8:00 AM
  final double end;
  final String icon;
  final String label;
  const ScheduleBlock({
    required this.start,
    required this.end,
    required this.icon,
    required this.label,
  });

  String get westernTime {
    String fmt(double h) {
      int hh = h.floor();
      int mm = ((h - hh) * 60).round();
      final period = hh >= 12 ? 'PM' : 'AM';
      int display = hh % 12;
      if (display == 0) display = 12;
      return '$display:${mm.toString().padLeft(2, '0')} $period';
    }
    return '${fmt(start)} – ${fmt(end)}';
  }

  String get ethiopianTime {
    String fmt(double h) {
      int hh = h.floor();
      int mm = ((h - hh) * 60).round();
      int ethHour = ((hh - 6) % 12 + 12) % 12;
      if (ethHour == 0) ethHour = 12;
      return '$ethHour:${mm.toString().padLeft(2, '0')}';
    }
    return '${fmt(start)} – ${fmt(end)} (ኢት)';
  }
}

const Map<String, List<ScheduleBlock>> kSchedules = {
  'morning': [
    ScheduleBlock(start: 6, end: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(start: 8, end: 11, icon: '📚', label: 'Day Study'),
    ScheduleBlock(start: 11, end: 12, icon: '🏠', label: 'Home Tasks'),
    ScheduleBlock(start: 12, end: 12.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(start: 13, end: 14, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(start: 14, end: 15, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(start: 16, end: 20, icon: '🌙', label: 'Night Study'),
  ],
  'afternoon': [
    ScheduleBlock(start: 6, end: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(start: 8, end: 9, icon: '🧺', label: 'Home Tasks'),
    ScheduleBlock(start: 9, end: 12, icon: '📚', label: 'Day Study'),
    ScheduleBlock(start: 12, end: 12.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(start: 13, end: 14, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(start: 14, end: 15, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(start: 16, end: 20, icon: '🌙', label: 'Night Study'),
  ],
  'saturday': [
    ScheduleBlock(start: 6, end: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(start: 8, end: 9, icon: '🚿', label: 'Personal Care'),
    ScheduleBlock(start: 9, end: 12, icon: '🧺', label: 'Home Tasks · Laundry'),
    ScheduleBlock(start: 12, end: 12.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(start: 13, end: 14, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(start: 14, end: 15, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(start: 16, end: 20, icon: '🌙', label: 'Night Study'),
  ],
  'sunday': [
    ScheduleBlock(start: 6, end: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(start: 8, end: 11, icon: '⛪', label: 'Church Service'),
    ScheduleBlock(start: 11, end: 12, icon: '🌱', label: 'Teaching Young Ones'),
    ScheduleBlock(start: 12, end: 12.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(start: 13, end: 14, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(start: 14, end: 15, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(start: 16, end: 20, icon: '🌙', label: 'Night Study'),
  ],
};

String scheduleKeyForToday(int weekday, String chosenShift) {
  // DateTime.weekday: 1=Mon ... 7=Sun
  if (weekday == 7) return 'sunday';
  if (weekday == 6) return 'saturday';
  return chosenShift;
}
