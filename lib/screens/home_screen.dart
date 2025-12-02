import 'package:flutter/material.dart';
import '../widgets/feed_now_sheet.dart';
import '../data/feeding_repo.dart';
import '../models/feeding.dart';
import '../services/cat_fact_service.dart';
/// Home screen for quick feeding actions
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Feeding? _lastSaved;
  late Future<String> _factFuture;

  @override
  void initState() {
    super.initState();
    _factFuture = CatFactService.fetchFact();
  }

  void _retryFact() {
    setState(() {
      _factFuture = CatFactService.fetchFact();
    });
  }

  // Opens the Feed Now sheet and handles saving
  Future<void> _openFeedNow() async {
    final res = await showModalBottomSheet<FeedNowResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (ctx) => const FeedNowSheet(),
    );
    if (res == null) return;

    // Warn if feeding time is within 30 minutes of now
    final within30 = DateTime.now().difference(res.when).abs() <
        const Duration(minutes: 30);
    if (within30) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Recent feeding time'),
          content: const Text('This feeding time is within ~30 minutes of now. Save anyway?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      );
      if (ok != true) return;
    }

    // Create and save the feeding
    final feeding = Feeding(
      id: DateTime.now().microsecondsSinceEpoch,
      when: res.when,
      foodType: res.foodType,
      portionGrams: res.portionGrams,
      by: res.memberName,
      memberId: res.memberId,
      petId: res.petId,       // <- this line
    );

    await FeedingRepo.instance.add(feeding);
    setState(() => _lastSaved = feeding);

    // Show a snackbar with undo option
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text('Feeding saved: ${feeding.foodType} · ${feeding.portionGrams} g'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            final last = _lastSaved;
            if (last != null) {
              await FeedingRepo.instance.delete(last.id);
              setState(() => _lastSaved = null);
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Main home screen UI
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Show last saved feeding if available
            if (_lastSaved != null) ...[
              Text('Last saved: ${_lastSaved!.foodType} · ${_lastSaved!.portionGrams} g'),
              const SizedBox(height: 12),
            ],
          FutureBuilder<String>(
            future: _factFuture,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal:16, vertical: 8),
                  child: LinearProgressIndicator(),
                );
              }
              if (snap.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: OutlinedButton.icon(
                    onPressed: _retryFact, // retry
                    icon: const Icon(Icons.refresh),
                    label: const Text('Load cat tip'),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal:16, vertical: 8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text('Tip: ${snap.data}'),
                  ),
                ),
              );
            },
          ),
            FilledButton.icon(
              onPressed: _openFeedNow,
              icon: const Icon(Icons.pets),
              label: const Text('Feed Now'),
            ),
            const SizedBox(height: 24),
            // Placeholder text
            const Text('Home – quick “Feed Now” actions will go here.'),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
