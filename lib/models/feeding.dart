import 'package:hive/hive.dart';

class Feeding {
  final int id;                // unique id
  final DateTime when;         // feeding time
  final String foodType;       // Wet / Dry / Treat / Other
  final int portionGrams;      // grams
  final String by;             // display name of who logged
  final int? memberId;         
  final int? petId;            

  Feeding({
    required this.id,
    required this.when,
    required this.foodType,
    required this.portionGrams,
    required this.by,
    this.memberId,
    this.petId,
  });

  Feeding copyWith({
    int? id,
    DateTime? when,
    String? foodType,
    int? portionGrams,
    String? by,
    int? memberId,
    int? petId,
  }) {
    return Feeding(
      id: id ?? this.id,
      when: when ?? this.when,
      foodType: foodType ?? this.foodType,
      portionGrams: portionGrams ?? this.portionGrams,
      by: by ?? this.by,
      memberId: memberId ?? this.memberId,
      petId: petId ?? this.petId,
    );
  }
}

class FeedingAdapter extends TypeAdapter<Feeding> {
  @override
  final int typeId = 1;

  @override
  Feeding read(BinaryReader reader) {
    // Store a field count for forward/backward compatibility
    final fieldCount = reader.read() as int? ?? 5;

    final id = reader.read() as int;
    final when = reader.read() as DateTime;
    final foodType = reader.read() as String;
    final portionGrams = reader.read() as int;
    final by = reader.read() as String;

    int? memberId;
    int? petId;

    if (fieldCount >= 6) {
      memberId = reader.read() as int?;
    }
    if (fieldCount >= 7) {
      petId = reader.read() as int?;
    }

    return Feeding(
      id: id,
      when: when,
      foodType: foodType,
      portionGrams: portionGrams,
      by: by,
      memberId: memberId,
      petId: petId,
    );
  }

  @override
  void write(BinaryWriter writer, Feeding obj) {
    // Write field count first
    writer.write(7);
    writer
      ..write(obj.id)
      ..write(obj.when)
      ..write(obj.foodType)
      ..write(obj.portionGrams)
      ..write(obj.by)
      ..write(obj.memberId)
      ..write(obj.petId);
  }
}
