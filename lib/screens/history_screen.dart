import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../data/feeding_repo.dart';
import '../models/feeding.dart';
import '../data/pet_repo.dart';
import '../models/pet.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int? _petFilter;

  @override
  Widget build(BuildContext context) {
    final repo = FeedingRepo.instance;
    final df = DateFormat('EEE, MMM d • h:mm a');
    final pets = PetRepo.instance.all();

    return Column(
      children: [
        // Filter chips
        if (pets.isNotEmpty)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All pets'),
                  selected: _petFilter == null,
                  onSelected: (_) => setState(() => _petFilter = null),
                ),
                const SizedBox(width: 8),
                ...pets.map((p) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(p.name),
                    selected: _petFilter == p.id,
                    onSelected: (_) => setState(() => _petFilter = p.id),
                  ),
                )),
              ],
            ),
          ),

         // Expanded list 
        Expanded(
          child: ValueListenableBuilder<Box<Feeding>>(
            valueListenable: repo.listenable(),
            builder: (context, box, _) {
              final items = repo.listNewestFirst(petId: _petFilter);
              if (items.isEmpty) {
                return const Center(
                  child: Text('No feedings yet. Log one from Home.'),
                );
              }

              // Build once per build 
              final petById = {for (final p in pets) p.id: p.name};

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final f = items[i];
                  return ListTile(
                    leading: Icon(
                      f.foodType == 'Dry'
                          ? Icons.rice_bowl_outlined
                          : f.foodType == 'Treat'
                              ? Icons.emoji_food_beverage_outlined
                              : Icons.fastfood_outlined,
                    ),
                    title: Text('${f.foodType} • ${f.portionGrams} g'),
                    subtitle: Text(
                      '${df.format(f.when)} • by ${f.by}'
                      '${f.petId != null ? ' • ${petById[f.petId] ?? 'Unknown pet'}' : ''}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Delete',
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Delete feeding'),
                            content: const Text(
                                'Are you sure you want to delete this entry?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await repo.delete(f.id);
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
        
      ],
    );
  }
}
