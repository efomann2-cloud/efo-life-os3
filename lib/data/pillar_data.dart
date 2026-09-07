class Stage {
  final String label;
  final List<String> milestones;
  const Stage({required this.label, required this.milestones});
}

class Pillar {
  final String id;
  final String icon;
  final String label;
  final int color; // hex, e.g. 0xFF5EA8E0
  final String category; // links to a tracker: academic | business | extracurricular | spiritual
  final List<Stage> stages;
  const Pillar({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    required this.category,
    required this.stages,
  });
}

const List<Pillar> kPillars = [
  Pillar(
    id: 'academic',
    icon: '🎓',
    label: 'Academic Excellence',
    color: 0xFF5EA8E0,
    category: 'academic',
    stages: [
      Stage(label: 'Year 1', milestones: ['Score 98%+, become Top 1 Student', 'Complete Grade 9 & 10 Entrance Exam Subjects']),
      Stage(label: 'Year 2', milestones: ['Prepare and apply for scholarships', 'Complete Grade 11 & 12 Entrance Exam Subjects']),
      Stage(label: 'Year 3', milestones: ['High score in SAT / IELTS', 'National Exam 570+/600']),
    ],
  ),
  Pillar(
    id: 'business',
    icon: '💻',
    label: 'Personal Business & Tech',
    color: 0xFFF0B44C,
    category: 'business',
    stages: [
      Stage(label: 'Year 1', milestones: ['Learn Dart/Flutter + Python (alternating days)', 'Build a portfolio project — Attendance & Punctuality System']),
      Stage(label: 'Year 2', milestones: ['Freelancing (Flutter/Python)', 'Build EFO Life OS app']),
      Stage(label: 'Year 3', milestones: ['Continue freelancing', 'StarX AstroAI — Exoplanet Tracker AI (Python/AI)']),
    ],
  ),
  Pillar(
    id: 'extracurricular',
    icon: '🏆',
    label: 'Extracurricular Activities',
    color: 0xFF5FD6A6,
    category: 'extracurricular',
    stages: [
      Stage(label: 'Year 1', milestones: ['Launch StarX Academy V1', 'School Maths Olympiad']),
      Stage(label: 'Year 2', milestones: ['Launch StarX Academy V2', 'Participate in Ethiopian Maths Olympiad']),
      Stage(label: 'Year 3', milestones: ['Launch StarX Academy V3', 'International competition']),
    ],
  ),
  Pillar(
    id: 'spiritual',
    icon: '📖',
    label: 'Spiritual Growth',
    color: 0xFFB98BE0,
    category: 'spiritual',
    stages: [
      Stage(label: 'Year 1', milestones: ['Build a consistent Bible study & prayer life', 'Launch Telegram spiritual channel']),
      Stage(label: 'Year 2', milestones: ['Teach others to build a consistent Bible study & prayer life', 'Launch TikTok spiritual channel']),
      Stage(label: 'Year 3', milestones: ['Continue a consistent Bible study & prayer life', 'Launch YouTube spiritual channel']),
    ],
  ),
];
