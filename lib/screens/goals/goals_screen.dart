import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../data/schedule_data.dart';

String _dateKey(DateTime d) => '${d.year}-${d.month}-${d.day}';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});
  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  String shift = 'morning';
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
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

    final hourFloat = now.hour + now.minute / 60.0;
    ScheduleBlock current = blocks.first;
    for (final b in blocks) {
      if (hourFloat >= b.start && hourFloat < b.end) { current = b; break; }
    }
    final span = current.end - current.start;
    final elapsed = (hourFloat - current.start).clamp(0, span);
    final pct = span > 0 ? elapsed / span : 0.0;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Right Now card
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
                Text('RIGHT NOW', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.5)),
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
                  Text('${current.westernTime}  ·  ${current.ethiopianTime}', style: const TextStyle(fontSize: 11, color: AppColors.dim)),
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
                  width: 74,
                  child: Text('${b.westernTime}\n${b.ethiopianTime}', style: const TextStyle(fontSize: 10, color: AppColors.goldLight, height: 1.3)),
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

        const SizedBox(height: 20),
        const Text('Study · Bible · General Knowledge · Summer Plan — ቀጣይ sub-steps ላይ ይጨመራሉ', style: TextStyle(fontSize: 11, color: AppColors.dim)),
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
