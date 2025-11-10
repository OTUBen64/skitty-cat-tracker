import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_router.dart';
import 'models/feeding.dart';
import 'data/feeding_repo.dart';
import 'services/notifs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(FeedingAdapter());
  await Hive.openBox<Feeding>(FeedingRepo.boxName);
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
