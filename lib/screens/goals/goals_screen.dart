import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../data/schedule_data.dart';
import '../../data/study_data.dart';
import '../../data/gk_data.dart';
import '../../data/bible_data.dart';
import 'end_of_day_review.dart';

String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

String _weekStartKey(DateTime now) {
  final diff = now.weekday % 7;
  final sunday = now.subtract(Duration(days: diff));
  return '${sunday.year}-${sunday.month}-${sunday.day}';
}

bool _blockContainsNow(ScheduleBlock b, double nowFloat) {
  double adjustedNow = nowFloat;
  if (b.westEnd > 24 && nowFloat < (b.westEnd - 24)) adjustedNow = nowFloat + 24;
  return adjustedNow >= b.westStart && adjustedNow < b.westEnd;
}

double _blockProgress(ScheduleBlock b, double nowFloat) {
  double adjustedNow = nowFloat;
  if (b.westEnd > 24 && nowFloat < (b.westEnd - 24)) adjustedNow = nowFloat + 24;
  final span = b.westEnd - b.westStart;
  if (span <= 0) return 0;
  return ((adjustedNow - b.westStart) / span).clamp(0, 1);
}

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});
  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String shift = 'morning';
  Timer? _ticker;
  late int selectedGkDay;
  late int selectedBibleDay;
  final TextEditingController _reflectionController = TextEditingController();
  bool _reflectionInit = false;
  final TextEditingController _summerController = TextEditingController();
  final TextEditingController _captureController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final today = DateTime.now().weekday % 7;
    selectedGkDay = today;
    selectedBibleDay = today;
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _reflectionController.dispose();
    _summerController.dispose();
    _captureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final app = context.watch<AppProvider>();

    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayKey = _dateKey(yesterday);
    final lastReviewed = app.getString('last_reviewed_date');

    final key = scheduleKeyForToday(now.weekday, shift);
    final blocks = kSchedules[key]!;
    final isWeekday = now.weekday >= 1 && now.weekday <= 5;
    final stateKey = 'schedule_${_dateKey(now)}';
    final done = app.getBoolList(stateKey, blocks.length);

    final nowFloat = now.hour + now.minute / 60.0;
    ScheduleBlock current = blocks.firstWhere(
      (b) => _blockContainsNow(b, nowFloat),
      orElse: () => blocks.first,
    );
    final pct = _blockProgress(current, nowFloat);

    final weekKey = 'gk_${_weekStartKey(now)}';
    final gkDone = app.getBoolList(weekKey, 7);
    final gkItem = kGkPlan[selectedGkDay];
    final todayIndex = now.weekday % 7;

    final bibleWeekKey = 'bible_${_weekStartKey(now)}';
    final bibleDone = app.getBoolList(bibleWeekKey, 7);
    final bibleItem = kBiblePlan[selectedBibleDay];

    final reflectionKey = 'reflection_${_dateKey(now)}';
    if (!_reflectionInit) {
      _reflectionController.text = app.getString(reflectionKey);
      _reflectionInit = true;
    }

    final summerGoals = app.getMapList('summer_plan');
    final captures = app.getMapList('quick_capture');

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (lastReviewed != yesterdayKey)
          GestureDetector(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => EndOfDayReview(dateKey: yesterdayKey, dateLabel: _weekdayName(yesterday.weekday)),
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.gold.withOpacity(0.4)),
              ),
              child: Row(children: [
                const Icon(Icons.today_outlined, color: AppColors.gold, size: 18),
                const SizedBox(width: 10),
                const Expanded(child: Text('Review yesterday\u2019s goals', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.parchment))),
                const Icon(Icons.chevron_right, color: AppColors.gold, size: 18),
              ]),
            ),
          ),

        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.inkCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.inkLine),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                const Text('RIGHT NOW', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.5)),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  alignment: Alignment.center,
                  child: Text(current.icon, style: const TextStyle(fontSize: 20)),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(current.label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.parchment)),
                  Text(current.ethLabel, style: const TextStyle(fontSize: 12, color: AppColors.dim)),
                ]),
              ]),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(value: pct.toDouble(), minHeight: 4, backgroundColor: Colors.white10, color: AppColors.gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (isWeekday)
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: AppColors.inkCard, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.inkLine)),
            child: Row(children: [
              _shiftBtn('morning', 'Morning Shift'),
              _shiftBtn('afternoon', 'Afternoon Shift'),
            ]),
          ),
        const SizedBox(height: 16),

        Text(_weekdayName(now.weekday).toUpperCase(), style: const TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 8),

        ...List.generate(blocks.length, (i) {
          final b = blocks[i];
          final isDone = done[i];
          return GestureDetector(
            onTap: () => app.setBoolListAt(stateKey, blocks.length, i, !isDone),
            child: Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: isDone ? AppColors.sage.withOpacity(0.12) : AppColors.inkCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDone ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
              ),
              child: Row(children: [
                SizedBox(
                  width: 68,
                  child: Text(b.ethLabel, style: const TextStyle(fontSize: 11, color: AppColors.goldLight)),
                ),
                const SizedBox(width: 8),
                Text(b.icon, style: const TextStyle(fontSize: 17)),
                const SizedBox(width: 10),
                Expanded(child: Text(b.label, style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500,
                  color: isDone ? AppColors.parchmentDim : AppColors.parchment,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                ))),
                Container(
                  width: 22, height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone ? AppColors.sage : Colors.transparent,
                    border: Border.all(color: isDone ? AppColors.sage : AppColors.gold, width: 1.5),
                  ),
                  child: isDone ? const Icon(Icons.check, size: 14, color: AppColors.inkDeep) : null,
                ),
              ]),
            ),
          );
        }),

        const SizedBox(height: 24),
        const Text('☀ DAY STUDY', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        ..._buildChecklist(context, app, 'daystudy_${_dateKey(now)}', kDayStudyTasks, '☀'),

        const SizedBox(height: 20),
        const Text('🌙 NIGHT STUDY', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        ..._buildChecklist(context, app, 'nightstudy_${_dateKey(now)}', kNightStudyTasks, '🌙'),

        const SizedBox(height: 24),
        const Text('💡 GENERAL KNOWLEDGE — THIS WEEK', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        _buildDayStrip(selectedGkDay, todayIndex, (i) => setState(() => selectedGkDay = i)),
        const SizedBox(height: 12),
        _buildPlanCard(
          tag: '${gkItem.icon} ${gkItem.topic}',
          title: gkItem.sub,
          fieldLabel: 'Task',
          fieldValue: gkItem.task,
          isDone: gkDone[selectedGkDay],
          doneLabel: 'Mark as done',
          onToggle: () => app.setBoolListAt(weekKey, 7, selectedGkDay, !gkDone[selectedGkDay]),
        ),

        const SizedBox(height: 24),
        const Text('✝ BIBLE — THIS WEEK', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        _buildDayStrip(selectedBibleDay, todayIndex, (i) => setState(() => selectedBibleDay = i)),
        const SizedBox(height: 12),
        _buildPlanCard(
          tag: '📖 ${bibleItem.book}',
          title: bibleItem.read,
          fieldLabel: 'Focus',
          fieldValue: bibleItem.focus,
          isDone: bibleDone[selectedBibleDay],
          doneLabel: 'Mark as read',
          onToggle: () => app.setBoolListAt(bibleWeekKey, 7, selectedBibleDay, !bibleDone[selectedBibleDay]),
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.inkCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.inkLine),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('📝 Today\u2019s Reflection', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.goldLight)),
              const SizedBox(height: 8),
              TextField(
                controller: _reflectionController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.parchment, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'What stood out to you today?',
                  hintStyle: const TextStyle(color: AppColors.dim, fontSize: 12),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.03),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.inkLine)),
                  contentPadding: const EdgeInsets.all(10),
                ),
                onChanged: (v) => app.setValue(reflectionKey, v),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text('🌞 SUMMER PLAN (Your Own Goals)', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _summerController,
                style: const TextStyle(color: AppColors.parchment, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Add a summer goal…',
                  hintStyle: const TextStyle(color: AppColors.dim, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.inkCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inkLine)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: (_) => _addToList(app, 'summer_plan', summerGoals, _summerController),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _addToList(app, 'summer_plan', summerGoals, _summerController),
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: AppColors.gold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (summerGoals.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No summer goals yet — add your first one above.', style: TextStyle(fontSize: 12, color: AppColors.dim)),
          ),
        ..._buildEditableList(app, 'summer_plan', summerGoals, showCheck: true),

        const SizedBox(height: 24),
        const Text('💭 QUICK CAPTURE (Ideas)', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _captureController,
                style: const TextStyle(color: AppColors.parchment, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'A business or outreach idea…',
                  hintStyle: const TextStyle(color: AppColors.dim, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.inkCard,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.inkLine)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onSubmitted: (_) => _addToList(app, 'quick_capture', captures, _captureController),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _addToList(app, 'quick_capture', captures, _captureController),
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                alignment: Alignment.center,
                child: const Icon(Icons.add, color: AppColors.gold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (captures.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text('No ideas captured yet — jot one down before you forget it.', style: TextStyle(fontSize: 12, color: AppColors.dim)),
          ),
        ..._buildEditableList(app, 'quick_capture', captures, showCheck: false),

        const SizedBox(height: 24),
      ],
    );
  }

  void _addToList(AppProvider app, String key, List<Map<String, dynamic>> current, TextEditingController ctrl) {
    final text = ctrl.text.trim();
    if (text.isEmpty) return;
    final updated = List<Map<String, dynamic>>.from(current)
      ..add({'text': text, 'done': false, 'id': DateTime.now().millisecondsSinceEpoch});
    app.setMapList(key, updated);
    ctrl.clear();
  }

  List<Widget> _buildEditableList(AppProvider app, String key, List<Map<String, dynamic>> items, {required bool showCheck}) {
    return items.asMap().entries.map((entry) {
      final i = entry.key;
      final item = entry.value;
      final isDone = item['done'] == true;
      return Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: (showCheck && isDone) ? AppColors.sage.withOpacity(0.12) : AppColors.inkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: (showCheck && isDone) ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
        ),
        child: Row(children: [
          if (showCheck)
            GestureDetector(
              onTap: () {
                final updated = List<Map<String, dynamic>>.from(items);
                updated[i] = {...updated[i], 'done': !isDone};
                app.setMapList(key, updated);
              },
              child: Container(
                width: 22, height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone ? AppColors.sage : Colors.transparent,
                  border: Border.all(color: isDone ? AppColors.sage : AppColors.gold, width: 1.5),
                ),
                child: isDone ? const Icon(Icons.check, size: 14, color: AppColors.inkDeep) : null,
              ),
            )
          else
            const Text('💭', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 10),
          Expanded(child: Text(item['text'] ?? '', style: TextStyle(
            fontSize: 13.5,
            color: (showCheck && isDone) ? AppColors.parchmentDim : AppColors.parchment,
            decoration: (showCheck && isDone) ? TextDecoration.lineThrough : null,
          ))),
          GestureDetector(
            onTap: () {
              final updated = List<Map<String, dynamic>>.from(items)..removeAt(i);
              app.setMapList(key, updated);
            },
            child: const Icon(Icons.close, size: 16, color: AppColors.dim),
          ),
        ]),
      );
    }).toList();
  }

  Widget _shiftBtn(String value, String label) {
    final active = shift == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => shift = value),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(color: active ? AppColors.gold : Colors.transparent, borderRadius: BorderRadius.circular(9)),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: active ? AppColors.inkDeep : AppColors.dim)),
        ),
      ),
    );
  }

  String _weekdayName(int w) {
    const names = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    return names[w - 1];
  }
}

Widget _buildDayStrip(int selected, int today, void Function(int) onTap) {
  const labels = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return SizedBox(
    height: 44,
    child: Row(
      children: List.generate(7, (i) {
        final isSelected = i == selected;
        final isToday = i == today;
        return Expanded(
          child: GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.gold : AppColors.inkCard,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isSelected ? AppColors.gold : AppColors.inkLine),
              ),
              alignment: Alignment.center,
              child: Text(
                labels[i],
                style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.inkDeep : (isToday ? AppColors.sage : AppColors.dim),
                ),
              ),
            ),
          ),
        );
      }),
    ),
  );
}

Widget _buildPlanCard({
  required String tag,
  required String title,
  required String fieldLabel,
  required String fieldValue,
  required bool isDone,
  required String doneLabel,
  required VoidCallback onToggle,
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.inkCard,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.inkLine),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Text(tag, style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600)),
        ),
        const SizedBox(height: 10),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.parchment)),
        const SizedBox(height: 8),
        Text(fieldLabel, style: const TextStyle(fontSize: 10, color: AppColors.dim, letterSpacing: 0.6)),
        const SizedBox(height: 2),
        Text(fieldValue, style: const TextStyle(fontSize: 13, color: AppColors.parchmentDim, height: 1.4)),
        const SizedBox(height: 14),
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: isDone ? AppColors.sage.withOpacity(0.15) : Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDone ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
            ),
            alignment: Alignment.center,
            child: Text(
              isDone ? '✓ Completed' : doneLabel,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDone ? AppColors.sage : AppColors.goldLight),
            ),
          ),
        ),
      ],
    ),
  );
}

List<Widget> _buildChecklist(BuildContext context, AppProvider app, String stateKey, List<String> tasks, String icon) {
  final done = app.getBoolList(stateKey, tasks.length);
  return List.generate(tasks.length, (i) {
    final isDone = done[i];
    return GestureDetector(
      onTap: () => app.setBoolListAt(stateKey, tasks.length, i, !isDone),
      child: Container(
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: isDone ? AppColors.sage.withOpacity(0.12) : AppColors.inkCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDone ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
        ),
        child: Row(children: [
          Text(icon, style: const TextStyle(fontSize: 15)),
          const SizedBox(width: 10),
          Expanded(child: Text(tasks[i], style: TextStyle(
            fontSize: 13.5, fontWeight: FontWeight.w500,
            color: isDone ? AppColors.parchmentDim : AppColors.parchment,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ))),
          Container(
            width: 22, height: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppColors.sage : Colors.transparent,
              border: Border.all(color: isDone ? AppColors.sage : AppColors.gold, width: 1.5),
            ),
            child: isDone ? const Icon(Icons.check, size: 14, color: AppColors.inkDeep) : null,
          ),
        ]),
      ),
    );
  });
}
