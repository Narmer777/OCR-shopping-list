import 'package:flutter/material.dart';

import 'app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Умный список покупок',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: const Color(0xFFF5F0E8),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE85D3A),
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A1A),
          onSurfaceVariant: const Color(0xFF6B7280),
        ),
      ),
      home: const AppShell(),
    );
  }
}
