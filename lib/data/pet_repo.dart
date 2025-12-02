import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet.dart';

class PetRepo {
  PetRepo._();
  static final instance = PetRepo._();

  static const boxName = 'pets';
  Box<Pet> get _box => Hive.box<Pet>(boxName);

  List<Pet> all() => _box.values.toList();
  Future<void> put(Pet p) => _box.put(p.id.toString(), p);
  Future<void> delete(int id) => _box.delete(id.toString());
  bool get isEmpty => _box.isEmpty;

  int nextId() {
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return now; 
  }
}
