import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../data/study_data.dart';

class EndOfDayReview extends StatefulWidget {
  final String dateKey;
  final String dateLabel;
  const EndOfDayReview({super.key, required this.dateKey, required this.dateLabel});

  @override
  State<EndOfDayReview> createState() => _EndOfDayReviewState();
}

class _EndOfDayReviewState extends State<EndOfDayReview> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final dsKey = 'daystudy_${widget.dateKey}';
    final nsKey = 'nightstudy_${widget.dateKey}';
    final dsDone = app.getBoolList(dsKey, kDayStudyTasks.length);
    final nsDone = app.getBoolList(nsKey, kNightStudyTasks.length);
    final excusedKey = 'excused_${widget.dateKey}';
    final isExcused = app.getBool(excusedKey);

    return Container(
      padding: EdgeInsets.only(
        left: 18, right: 18, top: 18,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.inkCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.inkLine, borderRadius: BorderRadius.circular(3)))),
          const SizedBox(height: 16),
          const Text('📝 Review Your Day', style: TextStyle(fontFamily: 'serif', fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.parchment)),
          Text(widget.dateLabel, style: const TextStyle(fontSize: 12, color: AppColors.dim)),
          const SizedBox(height: 6),
          const Text(
            'Confirm what you actually completed. Anything left unchecked will count as missed.',
            style: TextStyle(fontSize: 12, color: AppColors.parchmentDim, height: 1.4),
          ),
          const SizedBox(height: 16),

          if (isExcused)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.sage.withOpacity(0.12), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.sage.withOpacity(0.4))),
              child: const Row(children: [
                Icon(Icons.beach_access, size: 16, color: AppColors.sage),
                SizedBox(width: 8),
                Expanded(child: Text('This day is marked Excused — it won\u2019t count against your streak or progress.', style: TextStyle(fontSize: 12, color: AppColors.sage))),
              ]),
            )
          else ...[
            const Text('☀ DAY STUDY', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            ...List.generate(kDayStudyTasks.length, (i) => _reviewRow(app, dsKey, kDayStudyTasks.length, i, dsDone[i], kDayStudyTasks[i])),
            const SizedBox(height: 16),
            const Text('🌙 NIGHT STUDY', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
            const SizedBox(height: 8),
            ...List.generate(kNightStudyTasks.length, (i) => _reviewRow(app, nsKey, kNightStudyTasks.length, i, nsDone[i], kNightStudyTasks[i])),
          ],

          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => app.setValue(excusedKey, !isExcused),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                color: isExcused ? AppColors.sage.withOpacity(0.15) : Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isExcused ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
              ),
              alignment: Alignment.center,
              child: Text(
                isExcused ? '✓ Marked as Excused (tap to undo)' : '🛌 Excuse this day (sick / travel)',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isExcused ? AppColors.sage : AppColors.goldLight),
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {
              app.setValue('last_reviewed_date', widget.dateKey);
              Navigator.of(context).pop();
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 13),
              decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: const Text('Done Reviewing', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.inkDeep)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewRow(AppProvider app, String key, int length, int index, bool isDone, String label) {
    return GestureDetector(
      onTap: () => app.setBoolListAt(key, length, index, !isDone),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(11),
        decoration: BoxDecoration(
          color: isDone ? AppColors.sage.withOpacity(0.12) : Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDone ? AppColors.sage.withOpacity(0.5) : AppColors.inkLine),
        ),
        child: Row(children: [
          Expanded(child: Text(label, style: TextStyle(
            fontSize: 12.5,
            color: isDone ? AppColors.parchmentDim : AppColors.parchment,
            decoration: isDone ? TextDecoration.lineThrough : null,
          ))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: isDone ? AppColors.sage : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isDone ? AppColors.sage : AppColors.dim),
            ),
            child: Text(isDone ? 'Done' : 'Missed', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: isDone ? AppColors.inkDeep : AppColors.dim)),
          ),
        ]),
      ),
    );
  }
}
