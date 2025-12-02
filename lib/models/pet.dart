import 'package:hive/hive.dart';

class Pet {
  final int id;
  final String name;
  final String species; 

  Pet({required this.id, required this.name, required this.species});
}

class PetAdapter extends TypeAdapter<Pet> {
  @override
  final int typeId = 3;

  @override
  Pet read(BinaryReader reader) {
    final id = reader.read() as int;
    final name = reader.read() as String;
    final species = reader.read() as String;
    return Pet(id: id, name: name, species: species);
  }

  @override
  void write(BinaryWriter writer, Pet obj) {
    writer
      ..write(obj.id)
      ..write(obj.name)
      ..write(obj.species);
  }
}
