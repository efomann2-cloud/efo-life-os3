import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../services/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    final missionStartStr = app.getString('mission_start_date', fallback: app.getString('journey_start_date'));
    final focusMode = app.getBool('focus_mode_enabled', fallback: true);
    final hasPin = app.getString('app_pin').length == 4;

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
          const Text('🌙 FOCUS', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.inkCard,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.inkLine),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Focus Mode', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.parchment)),
                      const SizedBox(height: 4),
                      const Text('Silences reminders during your 4:00–8:00 (ET) Night Study block so you can stay focused.', style: TextStyle(fontSize: 11.5, color: AppColors.dim, height: 1.4)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: focusMode,
                  activeColor: AppColors.gold,
                  onChanged: (v) => context.read<AppProvider>().setValue('focus_mode_enabled', v),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          const Text('🔒 PRIVACY', style: TextStyle(color: AppColors.gold, fontSize: 11, letterSpacing: 1.2)),
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
                Text(hasPin ? 'App Lock: On' : 'App Lock: Off', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.parchment)),
                const SizedBox(height: 4),
                const Text('Require a 4-digit PIN to open the app — keeps your Reflections and journal private.', style: TextStyle(fontSize: 11.5, color: AppColors.dim, height: 1.4)),
                const SizedBox(height: 12),
                Row(children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showPinDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.gold.withOpacity(0.4))),
                        alignment: Alignment.center,
                        child: Text(hasPin ? 'Change PIN' : 'Set PIN', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.goldLight)),
                      ),
                    ),
                  ),
                  if (hasPin) ...[
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () => context.read<AppProvider>().setValue('app_pin', ''),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.inkLine)),
                        child: const Text('Remove', style: TextStyle(fontSize: 13, color: AppColors.dim)),
                      ),
                    ),
                  ],
                ]),
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
          const Text('Notifications — ቀጣይ sub-step ላይ ይጨመራል', style: TextStyle(fontSize: 11, color: AppColors.dim)),
        ],
      ),
    );
  }

  void _showPinDialog(BuildContext context) {
    String pin1 = '';
    String pin2 = '';
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.inkCard,
          title: const Text('Set a 4-digit PIN', style: TextStyle(color: AppColors.parchment, fontSize: 15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                style: const TextStyle(color: AppColors.parchment),
                decoration: const InputDecoration(labelText: 'New PIN', labelStyle: TextStyle(color: AppColors.dim), counterText: ''),
                onChanged: (v) => pin1 = v,
              ),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                style: const TextStyle(color: AppColors.parchment),
                decoration: const InputDecoration(labelText: 'Confirm PIN', labelStyle: TextStyle(color: AppColors.dim), counterText: ''),
                onChanged: (v) => pin2 = v,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.dim))),
            TextButton(
              onPressed: () {
                if (pin1.length == 4 && pin1 == pin2) {
                  context.read<AppProvider>().setValue('app_pin', pin1);
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('PINs must match and be 4 digits'), backgroundColor: Colors.redAccent),
                  );
                }
              },
              child: const Text('Save', style: TextStyle(color: AppColors.gold)),
            ),
          ],
        ),
      ),
    );
  }
}
