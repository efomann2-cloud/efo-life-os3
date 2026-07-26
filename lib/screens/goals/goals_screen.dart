import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../data/schedule_data.dart';
import '../../data/study_data.dart';
import '../../data/gk_data.dart';

String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

String _weekStartKey(DateTime now) {
  final diff = now.weekday % 7; // Sunday=0 days since Sunday
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

  @override
  void initState() {
    super.initState();
    selectedGkDay = DateTime.now().weekday % 7;
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final key = scheduleKeyForToday(now.weekday, shift);
    final blocks = kSchedules[key]!;
    final isWeekday = now.weekday >= 1 && now.weekday <= 5;
    final app = context.watch<AppProvider>();
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

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
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

        SizedBox(
          height: 46,
          child: Row(
            children: List.generate(7, (i) {
              final isSelected = i == selectedGkDay;
              final isToday = i == todayIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => selectedGkDay = i),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.gold : AppColors.inkCard,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? AppColors.gold : AppColors.inkLine),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      kDayShort[i],
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
        ),
        const SizedBox(height: 12),

        Container(
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
                child: Text('${gkItem.icon} ${gkItem.topic}', style: const TextStyle(fontSize: 11, color: AppColors.gold, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 10),
              Text(gkItem.sub, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.parchment)),
              const SizedBox(height: 8),
              Text(gkItem.task, style: const TextStyle(fontSize: 13, color: AppColors.parchmentDim, height: 1.4)),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () => app.setBoolListAt(weekKey, 7, selectedGkDay, !gkDone[selectedGkDay]),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: gkDone[selectedGkDay] ? AppColors.sage.withOpacity(0.15) : Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: gkDone[selectedGkDay] ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    gkDone[selectedGkDay] ? '✓ Completed' : 'Mark as done',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: gkDone[selectedGkDay] ? AppColors.sage : AppColors.goldLight),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text('Bible · Summer Plan · Quick Capture — ቀጣይ sub-steps ላይ ይጨመራሉ', style: TextStyle(fontSize: 11, color: AppColors.dim)),
      ],
    );
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
