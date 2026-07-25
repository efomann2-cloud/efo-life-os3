import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/home_shell.dart';

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
        home: Consumer<AppProvider>(
          builder: (context, app, _) {
            if (!app.isLoaded) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            return const HomeShell();
          },
        ),
      ),
    );
  }
}
