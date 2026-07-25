import 'package:flutter/material.dart';

void main() {
  runApp(const EfoLifeOsApp());
}

class EfoLifeOsApp extends StatelessWidget {
  const EfoLifeOsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EFO Life OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF0A0F1C),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFFCFA15A),
          secondary: const Color(0xFF7BA384),
        ),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'EFO Life OS\nSetup Successful ✦',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFFF2EAD9), fontSize: 22),
          ),
        ),
      ),
    );
  }
}
