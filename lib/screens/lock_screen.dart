import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/app_provider.dart';

class LockScreen extends StatefulWidget {
  final VoidCallback onUnlocked;
  const LockScreen({super.key, required this.onUnlocked});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String entered = '';
  bool error = false;

  void _tap(String digit) {
    if (entered.length >= 4) return;
    setState(() {
      entered += digit;
      error = false;
    });
    if (entered.length == 4) {
      final app = context.read<AppProvider>();
      final pin = app.getString('app_pin');
      if (entered == pin) {
        widget.onUnlocked();
      } else {
        setState(() => error = true);
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) setState(() => entered = '');
        });
      }
    }
  }

  void _backspace() {
    if (entered.isEmpty) return;
    setState(() => entered = entered.substring(0, entered.length - 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inkDeep,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Text('✦', style: TextStyle(fontSize: 28, color: AppColors.gold)),
            const SizedBox(height: 10),
            const Text('EFO Life OS', style: TextStyle(fontSize: 16, color: AppColors.parchment, fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(error ? 'Wrong PIN, try again' : 'Enter your PIN', style: TextStyle(fontSize: 12, color: error ? Colors.redAccent : AppColors.dim)),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < entered.length;
                return Container(
                  width: 14, height: 14,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? AppColors.gold : Colors.transparent,
                    border: Border.all(color: AppColors.gold),
                  ),
                );
              }),
            ),
            const Spacer(),
            _buildKeypad(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];
    return Column(
      children: rows.map((row) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((k) {
              if (k.isEmpty) return const SizedBox(width: 72, height: 60);
              return GestureDetector(
                onTap: () => k == '⌫' ? _backspace() : _tap(k),
                child: Container(
                  width: 72, height: 60,
                  alignment: Alignment.center,
                  child: Text(k, style: const TextStyle(fontSize: 22, color: AppColors.parchment, fontWeight: FontWeight.w500)),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
