import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final missionStartStr = app.getString('mission_start_date', fallback: app.getString('journey_start_date'));

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('🌌 MISSION', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 10),
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
                const Text('Mission Start Date', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.parchment)),
                const SizedBox(height: 4),
                const Text('This decides when Year 1 / Grade 10 began, and when each Roadmap stage unlocks.', style: TextStyle(fontSize: 11.5, color: AppColors.dim, height: 1.4)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(missionStartStr.isEmpty ? 'Not set' : missionStartStr, style: const TextStyle(fontSize: 15, color: AppColors.goldLight, fontWeight: FontWeight.w600)),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final now = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: now,
                          firstDate: DateTime(now.year - 2),
                          lastDate: DateTime(now.year + 1),
                          builder: (ctx, child) => Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: const ColorScheme.dark(primary: AppColors.gold, surface: AppColors.inkCard),
                            ),
                            child: child!,
                          ),
                        );
                        if (picked != null) {
                          context.read<AppProvider>().setValue('mission_start_date', '${picked.year}-${picked.month}-${picked.day}');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                        child: const Text('Change', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.goldLight)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('Language · Backup · Focus Mode · App Lock · Notifications — ቀጣይ sub-steps ላይ ይጨመራሉ', style: TextStyle(fontSize: 11, color: AppColors.dim)),
        ],
      ),
    );
  }
}
