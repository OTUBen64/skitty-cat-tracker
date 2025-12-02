import 'package:flutter/material.dart';
import '../services/notifs.dart';
import '../data/pet_repo.dart';
import '../models/pet.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  //  Reminders 
  Future<void> _enableReminders() async {
    await Notifs.instance.scheduleDaily(
      'breakfast', 8, 0, 'Breakfast time', 'Log the morning feeding',
    );
    await Notifs.instance.scheduleDaily(
      'dinner', 18, 0, 'Dinner time', 'Log the evening feeding',
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Daily reminders enabled (8:00 AM & 6:00 PM)')),
    );
  }

  Future<void> _disableReminders() async {
    await Notifs.instance.cancelAll();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All reminders disabled')),
    );
  }

  // Pets manager 
  Future<void> _addPetDialog() async {
    final nameCtrl = TextEditingController();
    String species = 'Cat';
    final formKey = GlobalKey<FormState>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Pet'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Enter a name' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: species,
                items: const [
                  DropdownMenuItem(value: 'Cat', child: Text('Cat')),
                  DropdownMenuItem(value: 'Dog', child: Text('Dog')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                decoration: const InputDecoration(labelText: 'Species'),
                onChanged: (v) => species = v ?? 'Cat',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (ok == true) {
      final id = PetRepo.instance.nextId();
      final pet = Pet(id: id, name: nameCtrl.text.trim(), species: species);
      await PetRepo.instance.put(pet);
      if (mounted) setState(() {});
    }
  }

  Future<void> _deletePet(Pet p) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete pet'),
        content: Text('Delete "${p.name}"? This won’t remove existing logs.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await PetRepo.instance.delete(p.id);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final pets = PetRepo.instance.all();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Pets section
        Row(
          children: [
            const Text('Pets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const Spacer(),
            FilledButton.icon(
              onPressed: _addPetDialog,
              icon: const Icon(Icons.add),
              label: const Text('Add Pet'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (pets.isEmpty)
          const Text('No pets yet. Add one to start logging by pet.')
        else
          ...pets.map((p) => Card(
                child: ListTile(
                  leading: const Icon(Icons.pets_outlined),
                  title: Text(p.name),
                  subtitle: Text(p.species),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Delete',
                    onPressed: () => _deletePet(p),
                  ),
                ),
              )),

        const SizedBox(height: 24),

        //  Reminders section 
        const Text('Reminders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _enableReminders,
          child: const Text('Enable 8:00 AM & 6:00 PM reminders'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: _disableReminders,
          child: const Text('Disable all reminders'),
        ),
      ],
    );
  }
}
