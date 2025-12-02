import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_router.dart';
import 'models/feeding.dart';
import 'models/member.dart';
import 'models/pet.dart';
import 'data/feeding_repo.dart';
import 'data/member_repo.dart';
import 'data/pet_repo.dart';
import 'services/notifs.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive
    ..registerAdapter(FeedingAdapter())
    ..registerAdapter(MemberAdapter())
    ..registerAdapter(PetAdapter());

  await Future.wait([
    Hive.openBox<Feeding>(FeedingRepo.boxName),
    Hive.openBox<Member>(MemberRepo.boxName),
    Hive.openBox<Pet>(PetRepo.boxName),
  ]);

  // Seed defaults (Ben + Skitty) if empty
  if (MemberRepo.instance.isEmpty) {
    await MemberRepo.instance.put(Member(id: 1, name: 'Ben'));
  }
  if (PetRepo.instance.isEmpty) {
    await PetRepo.instance.put(Pet(id: 1, name: 'Skitty', species: 'Cat'));
  }

  await Notifs.instance.init(); 

  runApp(const SkittyApp());
}

class SkittyApp extends StatelessWidget {
  const SkittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Skitty – Cat Feeding Tracker',
      routerConfig: AppRouter.router,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7),
        useMaterial3: true,
      ),
    );
  }
}
