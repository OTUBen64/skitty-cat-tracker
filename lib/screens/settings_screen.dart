import 'package:flutter/material.dart';
import '../services/notifs.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _schedule() async {
    await Notifs.instance.scheduleDaily('breakfast', 8, 0, 'Breakfast time', 'Log the morning feeding');
    await Notifs.instance.scheduleDaily('dinner', 18, 0, 'Dinner time', 'Log the evening feeding');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _schedule,
            child: const Text('Enable 8:00 AM & 6:00 PM reminders'),
          ),
          const SizedBox(height: 8),
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
