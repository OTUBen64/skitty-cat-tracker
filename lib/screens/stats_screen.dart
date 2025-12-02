import 'package:flutter/material.dart';
import '../data/feeding_repo.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day).subtract(const Duration(days: 6));
    final items = FeedingRepo.instance.listNewestFirst();
    final counts = <DateTime, int>{};

    for (int i = 0; i < 7; i++) {
      final d = DateTime(start.year, start.month, start.day).add(Duration(days: i));
      counts[d] = 0;
    }
    for (final f in items) {
      final d = DateTime(f.when.year, f.when.month, f.when.day);
      if (d.isAfter(start.subtract(const Duration(days: 1))) && d.isBefore(start.add(const Duration(days: 7)))) {
        counts[d] = (counts[d] ?? 0) + 1;
      }
    }

    final rows = counts.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rows.length,
      itemBuilder: (context, i) {
        final e = rows[i];
        final label = '${e.key.month}/${e.key.day}';
        return ListTile(
          leading: const Icon(Icons.calendar_today_outlined),
          title: Text('Meals: ${e.value}'),
          subtitle: Text(label),
        );
      },
    );
  }
}
                      