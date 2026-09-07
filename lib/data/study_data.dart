class ExamPrepDay {
  final String subject;
  final String topic;
  final String phase;
  const ExamPrepDay({required this.subject, required this.topic, required this.phase});
}

// index 0 = Sunday ... 6 = Saturday
const List<ExamPrepDay> kExamPrepPlan = [
  ExamPrepDay(subject: 'Brain Reflection', topic: 'Brain reflection, review', phase: 'Weekly review, clock on target'),
  ExamPrepDay(subject: 'Math', topic: 'Math formula, geometry, graph', phase: 'Math formula and geometry'),
  ExamPrepDay(subject: 'Physics', topic: 'Physics and orbital mechanics', phase: 'Physics & orbital mechanics'),
  ExamPrepDay(subject: 'Chemistry', topic: 'Chemistry topics practice', phase: 'Chemistry review'),
  ExamPrepDay(subject: 'Biology', topic: 'Biology topics practice', phase: 'Biology review'),
  ExamPrepDay(subject: 'English', topic: 'National Entrance English + SAT Reading', phase: 'National English & SAT Grammar/Reading combined practice'),
  ExamPrepDay(subject: 'Active Testing', topic: 'Active testing, timed practice', phase: 'Full exam simulation'),
];

const int kDayStudyLength = 8;

List<String> dayStudyTasksFor(int weekday) {
  final idx = weekday % 7; // Sunday=0
  final exam = kExamPrepPlan[idx];
  return [
    'Exam Prep — ${exam.subject}: ${exam.topic}',
    'Mental Math & Speed Calculations (10 min)',
    'Formula Shortcuts & Proofs (10 min)',
    'Hard SAT/Entrance Problem Solving (10 min)',
    'Shadowing + Listen→React (10 min)',
    'Live Conversation with AI (10 min)',
    'Random Speaking Challenge (5 min)',
    'Feedback: 3 corrections + 3 expressions + 3 new words (5 min)',
  ];
}

const List<String> kNightStudyTasks = [
  'Daily Anchor — Spaced Repetition (15–20 min, non-negotiable): flashcards & exam summaries',
  'Priority 1 — Homework & Class Test Prep (when due tomorrow)',
  'Priority 2 — Assignments & Projects (when no urgent HW exists)',
  'Priority 3 — Deep Entrance Exam Drills (when day is clear of school tasks)',
];
