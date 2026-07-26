class BibleItem {
  final String day;
  final String book;
  final String read;
  final String focus;
  const BibleItem({required this.day, required this.book, required this.read, required this.focus});
}

// index 0 = Sunday ... 6 = Saturday
const List<BibleItem> kBiblePlan = [
  BibleItem(day: 'Sunday', book: 'Reflection (Week Review)', read: 'Review this week\u2019s chapters', focus: 'What stood out? How can I apply it? Pray & plan for next week.'),
  BibleItem(day: 'Monday', book: 'Matthew (Personal Study)', read: 'Matthew Chapter 1–5', focus: 'Jesus the King and His Teachings'),
  BibleItem(day: 'Tuesday', book: 'Matthew (Family Study)', read: 'Matthew Chapter 6–10', focus: 'Living the Kingdom Life Together'),
  BibleItem(day: 'Wednesday', book: 'John', read: 'John Chapter 1–10', focus: 'The Light and Life in Christ'),
  BibleItem(day: 'Thursday', book: 'John', read: 'John Chapter 11–21', focus: 'Faith, Love and Eternal Life'),
  BibleItem(day: 'Friday', book: 'Romans', read: 'Romans Chapter 1–7', focus: 'Grace, Faith and Justification'),
  BibleItem(day: 'Saturday', book: 'Romans', read: 'Romans Chapter 8–16', focus: 'Living by the Spirit and God\u2019s Plan'),
];
