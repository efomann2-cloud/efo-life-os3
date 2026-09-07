import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../services/storage_service.dart';

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
          const Text('💾 BACKUP', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
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
                const Text('Export Your Data', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.parchment)),
                const SizedBox(height: 4),
                const Text('Copies all your progress as text. Paste it somewhere safe (Notes, Telegram Saved Messages) so you never lose it if you change phones.', style: TextStyle(fontSize: 11.5, color: AppColors.dim, height: 1.4)),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () async {
                    final storage = StorageService();
                    final data = await storage.loadState();
                    final jsonStr = data.toString();
                    await Clipboard.setData(ClipboardData(text: jsonStr));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Backup copied to clipboard ✓'), backgroundColor: AppColors.inkCard),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                    alignment: Alignment.center,
                    child: const Text('📋 Copy Backup to Clipboard', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.goldLight)),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('Focus Mode · App Lock · Notifications — ቀጣይ sub-steps ላይ ይጨመራሉ', style: TextStyle(fontSize: 11, color: AppColors.dim)),
        ],
      ),
    );
  }
}
