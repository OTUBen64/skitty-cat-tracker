import 'package:hive/hive.dart';


/// Simple feeding record stored in Hive.
class Feeding {
  final int id;                // unique id 
  final DateTime when;         // feeding time
  final String foodType;       // Wet / Dry / Treat / Other
  final int portionGrams;      // grams
  final String by;             // who logged it (for now: Ben/myself)

  Feeding({
    required this.id,
    required this.when,
    required this.foodType,
    required this.portionGrams,
    required this.by,
  });
}

/// Manual Hive adapter.
class FeedingAdapter extends TypeAdapter<Feeding> {
  @override
  final int typeId = 1;

  @override
  Feeding read(BinaryReader reader) {
    final id = reader.read() as int;                 
    final when = reader.read() as DateTime;         
    final foodType = reader.read() as String;
    final portionGrams = reader.read() as int;
    final by = reader.read() as String;
    return Feeding(
      id: id,
      when: when,
      foodType: foodType,
      portionGrams: portionGrams,
      by: by,
    );
  }

  @override
  void write(BinaryWriter writer, Feeding obj) {
    writer
      ..write(obj.id)                               
      ..write(obj.when)                             
      ..write(obj.foodType)
      ..write(obj.portionGrams)
      ..write(obj.by);
  }
}