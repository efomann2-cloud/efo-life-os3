class GkItem {
  final String day;
  final String icon;
  final String topic;
  final String sub;
  final String task;
  const GkItem({required this.day, required this.icon, required this.topic, required this.sub, required this.task});
}

// index 0 = Sunday ... 6 = Saturday
const List<GkItem> kGkPlan = [
  GkItem(day: 'Sunday', icon: '⭐', topic: 'Reflection (Light Day)', sub: 'Review the week', task: 'What did you learn? What was interesting?'),
  GkItem(day: 'Monday', icon: '🪐', topic: 'Astronomy', sub: 'Planets — order, size, facts', task: 'Write 3 facts about each planet.'),
  GkItem(day: 'Tuesday', icon: '📱', topic: 'EFO Academy', sub: 'Flutter/Dart build session', task: 'Work on current EFO Academy feature or screen.'),
  GkItem(day: 'Wednesday', icon: '📗', topic: 'Reading Books', sub: 'English or science book', task: 'Read 5–10 pages + note new words.'),
  GkItem(day: 'Thursday', icon: '🌌', topic: 'Astronomy', sub: 'Stars & galaxies', task: 'Learn how stars are formed.'),
  GkItem(day: 'Friday', icon: '🔭', topic: 'StarX AstroAI', sub: 'Python build session', task: 'Work on current StarX AstroAI feature or module.'),
  GkItem(day: 'Saturday', icon: '📚', topic: 'Reading Books', sub: 'Story or knowledge book', task: 'Summarize what you read.'),
];

const List<String> kDayShort = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
