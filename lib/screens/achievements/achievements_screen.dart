import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';

class _Badge {
  final int threshold;
  final String label;
  const _Badge(this.threshold, this.label);
}

const List<_Badge> kBadges = [
  _Badge(5, 'First Steps'),
  _Badge(20, 'Rising'),
  _Badge(50, 'Momentum'),
  _Badge(100, 'Halfway Sky'),
  _Badge(175, 'Constellation'),
  _Badge(250, 'Full Sky'),
];

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final total = app.lifetimeCompletedCount();
    final unlocked = kBadges.where((b) => total >= b.threshold).length;

    final examDateStr = app.getString('exam_date');
    DateTime? examDate;
    if (examDateStr.isNotEmpty) {
      final parts = examDateStr.split('-').map(int.parse).toList();
      examDate = DateTime(parts[0], parts[1], parts[2]);
    }
    final now = DateTime.now();
    final daysLeft = examDate == null ? null : DateTime(examDate.year, examDate.month, examDate.day).difference(DateTime(now.year, now.month, now.day)).inDays;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('⏳ EXAM COUNTDOWN', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.inkCard,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.inkLine),
          ),
          child: examDate == null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Entrance Exam Date', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.parchment)),
                    const SizedBox(height: 6),
                    const Text('Set the date of your Grade 10/12 Entrance Exam to see a live countdown.', style: TextStyle(fontSize: 12, color: AppColors.parchmentDim, height: 1.4)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _pickExamDate(context, app),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                        alignment: Alignment.center,
                        child: const Text('Set Exam Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.goldLight)),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Entrance Exam', style: TextStyle(fontSize: 13, color: AppColors.dim)),
                        GestureDetector(
                          onTap: () => _pickExamDate(context, app),
                          child: const Text('Change', style: TextStyle(fontSize: 11, color: AppColors.gold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      daysLeft! >= 0 ? '$daysLeft days left' : 'Exam day has passed',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.parchment),
                    ),
                    Text('${examDate.year}-${examDate.month.toString().padLeft(2, '0')}-${examDate.day.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 12, color: AppColors.dim)),
                  ],
                ),
        ),

        const SizedBox(height: 26),
        Text('🏆 BADGES — $unlocked/${kBadges.length} EARNED', style: const TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
        const SizedBox(height: 12),

        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.85,
          children: kBadges.map((b) {
            final on = total >= b.threshold;
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.inkCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.inkLine),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 42, height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: on ? const LinearGradient(colors: [AppColors.goldLight, AppColors.gold]) : null,
                      color: on ? null : Colors.white.withOpacity(0.05),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.emoji_events, size: 20, color: on ? AppColors.inkDeep : AppColors.dim),
                  ),
                  const SizedBox(height: 8),
                  Text(b.label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10.5, color: on ? AppColors.parchment : AppColors.dim)),
                  Text('${b.threshold}', style: const TextStyle(fontSize: 9, color: AppColors.dim)),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),
        Center(child: Text('$total lifetime tasks completed', style: const TextStyle(fontSize: 11, color: AppColors.dim))),
      ],
    );
  }

  Future<void> _pickExamDate(BuildContext context, AppProvider app) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year, 6, 1),
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      builder: (ctx, child) => Theme(
        data: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark(primary: AppColors.gold, surface: AppColors.inkCard),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      app.setValue('exam_date', '${picked.year}-${picked.month}-${picked.day}');
    }
  }
}
