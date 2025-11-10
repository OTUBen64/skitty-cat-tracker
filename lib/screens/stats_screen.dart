import 'package:flutter/material.dart';

/// Stats screen for showing feeding statistics
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Main stats UI (placeholder)
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Stats – charts for intake by day/week will go here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
