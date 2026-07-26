String dateKeyFor(DateTime d) => '${d.year}-${d.month}-${d.day}';

String weekStartKeyFor(DateTime now) {
  final diff = now.weekday % 7;
  final sunday = now.subtract(Duration(days: diff));
  return dateKeyFor(sunday);
}
