import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/feeding.dart';

class FeedingRepo {
  FeedingRepo._();
  static final instance = FeedingRepo._();

  static const boxName = 'feedings_v2'; 
  Box<Feeding> get _box => Hive.box<Feeding>(boxName);

  Future<void> add(Feeding f) => _box.put(f.id.toString(), f);  
  Future<void> delete(int id) => _box.delete(id.toString());    

  List<Feeding> listNewestFirst() {
    final items = _box.values.toList();
    items.sort((a, b) => b.when.compareTo(a.when));
    return items;
  }

  ValueListenable<Box<Feeding>> listenable() => _box.listenable();
}
