import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../data/feeding_repo.dart';
import '../models/feeding.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = FeedingRepo.instance;
    final df = DateFormat('EEE, MMM d • h:mm a');

    return ValueListenableBuilder<Box<Feeding>>(
      valueListenable: repo.listenable(),   // <- this is key
      builder: (context, box, _) {
        final items = repo.listNewestFirst();
        if (items.isEmpty) {
          return const Center(child: Text('No feedings yet. Log one from Home.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, i) {
            final f = items[i];
            return ListTile(
              leading: Icon(
                f.foodType == 'Dry' ? Icons.rice_bowl_outlined
                  : f.foodType == 'Treat' ? Icons.emoji_food_beverage_outlined
                  : Icons.fastfood_outlined,
              ),
              title: Text('${f.foodType} • ${f.portionGrams} g'),
              subtitle: Text('${df.format(f.when)} • by ${f.by}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: () => repo.delete(f.id),
                tooltip: 'Delete',
              ),
            );
          },
        );
      },
    );
  }
}
