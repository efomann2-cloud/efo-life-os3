class BuildDay {
  final String day;
  final String track;
  final String mode;
  final List<String> steps;
  const BuildDay({required this.day, required this.track, required this.mode, required this.steps});
}

// index 0 = Sunday ... 6 = Saturday
const List<BuildDay> kBuildPlan = [
  BuildDay(day: 'Sunday', track: 'Flutter & Python', mode: 'Review', steps: [
    'Review Flutter concepts from this week',
    'Review Python concepts from this week',
  ]),
  BuildDay(day: 'Monday', track: 'Flutter', mode: 'Learning Day', steps: [
    '20 min — Learn new concept',
    '20 min — Hands-on practice',
    '10 min — Feedback & review',
    '10 min — Advanced tips & shortcuts',
  ]),
  BuildDay(day: 'Tuesday', track: 'Python', mode: 'Learning Day', steps: [
    '20 min — Learn new concept',
    '20 min — Hands-on practice',
    '10 min — Feedback & review',
    '10 min — Advanced tips & shortcuts',
  ]),
  BuildDay(day: 'Wednesday', track: 'Flutter', mode: 'Project Day', steps: [
    '30 min — Coding: build real features',
    '20 min — Test & debug',
    '10 min — Commit to GitHub',
  ]),
  BuildDay(day: 'Thursday', track: 'Python', mode: 'Project Day', steps: [
    '30 min — Coding: build real features',
    '20 min — Test & debug',
    '10 min — Commit to GitHub',
  ]),
  BuildDay(day: 'Friday', track: 'Flutter', mode: 'Project Day', steps: [
    '30 min — Coding: build real features',
    '20 min — Test & debug',
    '10 min — Commit to GitHub',
  ]),
  BuildDay(day: 'Saturday', track: 'Python', mode: 'Project Day', steps: [
    '30 min — Coding: build real features',
    '20 min — Test & debug',
    '10 min — Commit to GitHub',
  ]),
];
