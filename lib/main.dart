import 'package:flutter/material.dart';
import 'app_router.dart';

void main() {
  runApp(const SkittyApp());
}

class SkittyApp extends StatelessWidget {
  const SkittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skitty – Cat Feeding Tracker',
      routerConfig: AppRouter.router,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7), // Skitty purple vibe
        useMaterial3: true,
      ),
    );
  }
}
