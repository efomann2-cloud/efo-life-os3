class ScheduleBlock {
  final String ethLabel;   // exact Ethiopian time, as shown in your schedule
  final double westStart;  // internal — western equivalent, for "Right Now" detection
  final double westEnd;
  final String icon;
  final String label;
  const ScheduleBlock({
    required this.ethLabel,
    required this.westStart,
    required this.westEnd,
    required this.icon,
    required this.label,
  });
}

const Map<String, List<ScheduleBlock>> kSchedules = {
  'morning': [
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 6, westEnd: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '📚', label: 'Day Study'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '🏠', label: 'Home Tasks'),
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 18, westEnd: 18.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(ethLabel: '4:00 – 8:00', westStart: 22, westEnd: 26, icon: '🌙', label: 'Night Study'),
  ],
  'afternoon': [
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 6, westEnd: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 8, westEnd: 9, icon: '🧺', label: 'Home Tasks'),
    ScheduleBlock(ethLabel: '3:00 – 6:00', westStart: 9, westEnd: 12, icon: '📚', label: 'Day Study'),
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 18, westEnd: 18.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(ethLabel: '4:00 – 8:00', westStart: 22, westEnd: 26, icon: '🌙', label: 'Night Study'),
  ],
  'saturday': [
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 6, westEnd: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '🚿', label: 'Shower'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '🧺', label: 'Wash Clothes'),
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 18, westEnd: 18.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(ethLabel: '4:00 – 8:00', westStart: 22, westEnd: 26, icon: '🌙', label: 'Night Study'),
  ],
  'sunday': [
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 6, westEnd: 6.5, icon: '⛪', label: 'Morning Prayer'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '⛪', label: 'Church Service'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '🌱', label: 'Teaching Young Ones'),
    ScheduleBlock(ethLabel: '12:00 – 12:30', westStart: 18, westEnd: 18.5, icon: '☕', label: 'Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '💡', label: 'General Knowledge'),
    ScheduleBlock(ethLabel: '4:00 – 8:00', westStart: 22, westEnd: 26, icon: '🌙', label: 'Night Study'),
  ],
};

String scheduleKeyForToday(int weekday, String chosenShift) {
  if (weekday == 7) return 'sunday';
  if (weekday == 6) return 'saturday';
  return chosenShift;
}
