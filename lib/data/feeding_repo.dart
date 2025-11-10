import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/feeding.dart';

/// Repository for managing Feeding objects in Hive database
class FeedingRepo {
  /// Private constructor for singleton pattern
  FeedingRepo._();
  /// Singleton instance
  static final instance = FeedingRepo._();

  /// Name of the Hive box storing feedings
  static const boxName = 'feedings_v2'; 
  /// Returns the Hive box for Feeding objects
  Box<Feeding> get _box => Hive.box<Feeding>(boxName);

  /// Adds a Feeding object to the box
  Future<void> add(Feeding f) => _box.put(f.id.toString(), f);  
  /// Deletes a Feeding object by id
  Future<void> delete(int id) => _box.delete(id.toString());    

  /// Returns a list of Feeding objects sorted by newest first
  List<Feeding> listNewestFirst() {
    final items = _box.values.toList();
    items.sort((a, b) => b.when.compareTo(a.when));
    return items;
  }

  /// Returns a listenable for the Feeding box
  ValueListenable<Box<Feeding>> listenable() => _box.listenable();
}
