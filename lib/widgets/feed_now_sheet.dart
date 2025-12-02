import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/member_repo.dart';
import '../data/pet_repo.dart';
import '../models/member.dart';
import '../models/pet.dart';

class FeedNowResult {
  final String foodType;
  final int portionGrams;
  final DateTime when;
  final int memberId;
  final int petId;
  final String memberName; // for display

  FeedNowResult(
    this.foodType,
    this.portionGrams,
    this.when,
    this.memberId,
    this.petId,
    this.memberName,
  );
}

class FeedNowSheet extends StatefulWidget {
  const FeedNowSheet({super.key});

  @override
  State<FeedNowSheet> createState() => _FeedNowSheetState();
}

class _FeedNowSheetState extends State<FeedNowSheet> {
  final _formKey = GlobalKey<FormState>();
  String _foodType = 'Wet';
  int _portion = 60;
  DateTime _when = DateTime.now();

  late List<Member> _members;
  late List<Pet> _pets;
  int _memberId = 1;
  int _petId = 1;

  @override
  void initState() {
    super.initState();
    _members = MemberRepo.instance.all();
    _pets = PetRepo.instance.all();
    if (_members.isNotEmpty) _memberId = _members.first.id;
    if (_pets.isNotEmpty) _petId = _pets.first.id;
  }

  Future<void> _pickDateTime() async {
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDate: _when,
    );
    if (d == null) return;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_when),
    );
    if (t == null) return;
    setState(() {
      _when = DateTime(d.year, d.month, d.day, t.hour, t.minute);
    });
  }

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('EEE, MMM d – h:mm a');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4, width: 40,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text('Log Feeding', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),

              // Member
              DropdownButtonFormField<int>(
                value: _memberId,
                items: _members.map((m) => DropdownMenuItem(
                  value: m.id,
                  child: Text(m.name),
                )).toList(),
                decoration: const InputDecoration(labelText: 'Who fed'),
                onChanged: (v) => setState(() => _memberId = v ?? _memberId),
              ),

              // Pet
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: _petId,
                items: _pets.map((p) => DropdownMenuItem(
                  value: p.id,
                  child: Text(p.name),
                )).toList(),
                decoration: const InputDecoration(labelText: 'Which pet'),
                onChanged: (v) => setState(() => _petId = v ?? _petId),
              ),

              // Food type
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _foodType,
                items: const [
                  DropdownMenuItem(value: 'Wet', child: Text('Wet')),
                  DropdownMenuItem(value: 'Dry', child: Text('Dry')),
                  DropdownMenuItem(value: 'Treat', child: Text('Treat')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
                ],
                decoration: const InputDecoration(labelText: 'Food type'),
                onChanged: (v) => setState(() => _foodType = v ?? 'Wet'),
              ),

              // Portion (grams)
              TextFormField(
                initialValue: _portion.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Portion (grams)'),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  if (n == null || n <= 0) return 'Enter a positive number';
                  return null;
                },
                onSaved: (v) => _portion = int.parse(v!),
              ),

              // Time
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Time'),
                subtitle: Text(df.format(_when)),
                trailing: TextButton.icon(
                  onPressed: _pickDateTime,
                  icon: const Icon(Icons.schedule),
                  label: const Text('Pick'),
                ),
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        final member = _members.firstWhere((m) => m.id == _memberId);
                        Navigator.pop(
                          context,
                          FeedNowResult(
                            _foodType, _portion, _when, _memberId, _petId, member.name,
                          ),
                        );
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
