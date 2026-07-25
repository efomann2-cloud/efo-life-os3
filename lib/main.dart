import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';

void main() {
  runApp(const EfoLifeOsApp());
}

class EfoLifeOsApp extends StatelessWidget {
  const EfoLifeOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..load(),
      child: MaterialApp(
        title: 'EFO Life OS',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const TestHomeScreen(),
      ),
    );
  }
}

class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppProvider>();
    if (!app.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final testDone = app.getBool('test_toggle');
    return Scaffold(
      appBar: AppBar(title: const Text('EFO Life OS — Phase 1 Test')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Theme + Storage + Provider ✦', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => app.toggleBool('test_toggle'),
              child: Text(testDone ? 'Saved: ON ✅' : 'Tap to save: OFF'),
            ),
            const SizedBox(height: 10),
            const Text(
              'Close & reopen the app — it should remember!',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
