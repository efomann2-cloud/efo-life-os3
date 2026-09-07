class ScheduleBlock {
  final String ethLabel;
  final double westStart;
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

// Common structure for every day type. Ethiopian 12:00 = Western 6:00 AM (elapsed hour 0).
// westStart/westEnd = 6 + elapsed hours since day start.
const Map<String, List<ScheduleBlock>> kSchedules = {
  'morning': [
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 6, westEnd: 7, icon: '🌅', label: 'Start Day'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 7, westEnd: 8, icon: '🍳', label: 'Breakfast'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 8, westEnd: 9, icon: '🏫', label: 'Block 1 — School'),
    ScheduleBlock(ethLabel: '3:00 – 6:00', westStart: 9, westEnd: 12, icon: '🏫', label: 'Block 2 — School'),
    ScheduleBlock(ethLabel: '6:00 – 7:00', westStart: 12, westEnd: 13, icon: '🍽️', label: 'Lunch'),
    ScheduleBlock(ethLabel: '7:00 – 8:00', westStart: 13, westEnd: 14, icon: '😴', label: 'Block 3 — Nap'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '📚', label: 'Block 4 — Day Study'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '🏠', label: 'Block 5 — Help Family'),
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 18, westEnd: 19, icon: '🚶', label: 'Walk + Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '🔭', label: 'PAB — Projects, Astronomy & Reading'),
    ScheduleBlock(ethLabel: '3:00 – 4:00', westStart: 21, westEnd: 22, icon: '🍲', label: 'Dinner'),
    ScheduleBlock(ethLabel: '4:00 – 5:00', westStart: 22, westEnd: 23, icon: '🌙', label: 'Night Study'),
    ScheduleBlock(ethLabel: '5:00 – 6:00', westStart: 23, westEnd: 24, icon: '💻', label: 'Flutter / Python'),
    ScheduleBlock(ethLabel: '6:00 – 12:00', westStart: 24, westEnd: 30, icon: '💤', label: 'Pure Sleep'),
  ],
  'afternoon': [
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 6, westEnd: 7, icon: '🌅', label: 'Start Day'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 7, westEnd: 8, icon: '🍳', label: 'Breakfast'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 8, westEnd: 9, icon: '🏠', label: 'Block 1 — Help Family'),
    ScheduleBlock(ethLabel: '3:00 – 6:00', westStart: 9, westEnd: 12, icon: '📚', label: 'Block 2 — Day Study'),
    ScheduleBlock(ethLabel: '6:00 – 7:00', westStart: 12, westEnd: 13, icon: '🍽️', label: 'Lunch'),
    ScheduleBlock(ethLabel: '7:00 – 8:00', westStart: 13, westEnd: 14, icon: '🏫', label: 'Block 3 — School'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '🏫', label: 'Block 4 — School'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '😴', label: 'Block 5 — Nap'),
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 18, westEnd: 19, icon: '🚶', label: 'Walk + Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '🔭', label: 'PAB — Projects, Astronomy & Reading'),
    ScheduleBlock(ethLabel: '3:00 – 4:00', westStart: 21, westEnd: 22, icon: '🍲', label: 'Dinner'),
    ScheduleBlock(ethLabel: '4:00 – 5:00', westStart: 22, westEnd: 23, icon: '🌙', label: 'Night Study'),
    ScheduleBlock(ethLabel: '5:00 – 6:00', westStart: 23, westEnd: 24, icon: '💻', label: 'Flutter / Python'),
    ScheduleBlock(ethLabel: '6:00 – 12:00', westStart: 24, westEnd: 30, icon: '💤', label: 'Pure Sleep'),
  ],
  'saturday': [
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 6, westEnd: 7, icon: '🌅', label: 'Start Day'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 7, westEnd: 8, icon: '🍳', label: 'Breakfast'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 8, westEnd: 9, icon: '🚿', label: 'Block 1 — Shower + Water Fetching'),
    ScheduleBlock(ethLabel: '3:00 – 6:00', westStart: 9, westEnd: 12, icon: '🚿', label: 'Block 2 — Shower + Water Fetching'),
    ScheduleBlock(ethLabel: '6:00 – 7:00', westStart: 12, westEnd: 13, icon: '🍽️', label: 'Lunch'),
    ScheduleBlock(ethLabel: '7:00 – 8:00', westStart: 13, westEnd: 14, icon: '😴', label: 'Block 3 — Nap'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '🧺', label: 'Block 4 — Laundry'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '🤝', label: 'Block 5 — Bible Study Team'),
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 18, westEnd: 19, icon: '🚶', label: 'Walk + Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '🔭', label: 'PAB — Projects, Astronomy & Reading'),
    ScheduleBlock(ethLabel: '3:00 – 4:00', westStart: 21, westEnd: 22, icon: '🍲', label: 'Dinner'),
    ScheduleBlock(ethLabel: '4:00 – 5:00', westStart: 22, westEnd: 23, icon: '🌙', label: 'Night Study'),
    ScheduleBlock(ethLabel: '5:00 – 6:00', westStart: 23, westEnd: 24, icon: '💻', label: 'Flutter / Python'),
    ScheduleBlock(ethLabel: '6:00 – 12:00', westStart: 24, westEnd: 30, icon: '💤', label: 'Pure Sleep'),
  ],
  'sunday': [
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 6, westEnd: 7, icon: '🌅', label: 'Start Day'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 7, westEnd: 8, icon: '🍳', label: 'Breakfast'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 8, westEnd: 9, icon: '⛪', label: 'Block 1 — Church'),
    ScheduleBlock(ethLabel: '3:00 – 6:00', westStart: 9, westEnd: 12, icon: '⛪', label: 'Block 2 — Church'),
    ScheduleBlock(ethLabel: '6:00 – 7:00', westStart: 12, westEnd: 13, icon: '🍽️', label: 'Lunch'),
    ScheduleBlock(ethLabel: '7:00 – 8:00', westStart: 13, westEnd: 14, icon: '😴', label: 'Block 3 — Nap'),
    ScheduleBlock(ethLabel: '8:00 – 11:00', westStart: 14, westEnd: 17, icon: '📱', label: 'Block 4 — Social Media Content'),
    ScheduleBlock(ethLabel: '11:00 – 12:00', westStart: 17, westEnd: 18, icon: '🌱', label: 'Block 5 — Volunteer / Free Time'),
    ScheduleBlock(ethLabel: '12:00 – 1:00', westStart: 18, westEnd: 19, icon: '🚶', label: 'Walk + Rest'),
    ScheduleBlock(ethLabel: '1:00 – 2:00', westStart: 19, westEnd: 20, icon: '📖', label: 'Bible Study'),
    ScheduleBlock(ethLabel: '2:00 – 3:00', westStart: 20, westEnd: 21, icon: '🔭', label: 'PAB — Projects, Astronomy & Reading'),
    ScheduleBlock(ethLabel: '3:00 – 4:00', westStart: 21, westEnd: 22, icon: '🍲', label: 'Dinner'),
    ScheduleBlock(ethLabel: '4:00 – 5:00', westStart: 22, westEnd: 23, icon: '🌙', label: 'Night Study'),
    ScheduleBlock(ethLabel: '5:00 – 6:00', westStart: 23, westEnd: 24, icon: '💻', label: 'Flutter / Python'),
    ScheduleBlock(ethLabel: '6:00 – 12:00', westStart: 24, westEnd: 30, icon: '💤', label: 'Pure Sleep'),
  ],
};

String scheduleKeyForToday(int weekday, String chosenShift) {
  if (weekday == 7) return 'sunday';
  if (weekday == 6) return 'saturday';
  return chosenShift;
}
