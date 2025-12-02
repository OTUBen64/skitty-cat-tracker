import 'package:hive_flutter/hive_flutter.dart';
import '../models/member.dart';

class MemberRepo {
  MemberRepo._();
  static final instance = MemberRepo._();

  static const boxName = 'members';
  Box<Member> get _box => Hive.box<Member>(boxName);

  List<Member> all() => _box.values.toList();
  Future<void> put(Member m) => _box.put(m.id.toString(), m);
  bool get isEmpty => _box.isEmpty;
}
