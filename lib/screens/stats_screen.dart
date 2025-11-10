import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
