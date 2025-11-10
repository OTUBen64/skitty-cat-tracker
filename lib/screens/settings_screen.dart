import 'package:flutter/material.dart';
import '../services/notifs.dart';

/// Settings screen for managing feeding reminders
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Schedules daily notifications for breakfast and dinner
  Future<void> _schedule() async {
    await Notifs.instance.scheduleDaily('breakfast', 8, 0, 'Breakfast time', 'Log the morning feeding');
    await Notifs.instance.scheduleDaily('dinner', 18, 0, 'Dinner time', 'Log the evening feeding');
  }

  @override
  Widget build(BuildContext context) {
    // Main settings UI
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          const Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          // Button to enable reminders
          FilledButton(
            onPressed: _schedule,
            child: const Text('Enable 8:00 AM & 6:00 PM reminders'),
          ),
          const SizedBox(height: 8),
          // Button to disable all reminders
          OutlinedButton(
            onPressed: Notifs.instance.cancelAll,
            child: const Text('Disable all reminders'),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
