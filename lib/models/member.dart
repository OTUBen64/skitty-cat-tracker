import 'package:hive/hive.dart';

class Member {
  final int id;
  final String name;

  Member({required this.id, required this.name});
}

class MemberAdapter extends TypeAdapter<Member> {
  @override
  final int typeId = 2;

  @override
  Member read(BinaryReader reader) {
    final id = reader.read() as int;
    final name = reader.read() as String;
    return Member(id: id, name: name);
  }

  @override
  void write(BinaryWriter writer, Member obj) {
    writer
      ..write(obj.id)
      ..write(obj.name);
  }
}
