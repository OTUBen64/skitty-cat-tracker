import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app_router.dart';
import 'models/feeding.dart';
import 'data/feeding_repo.dart';
import 'services/notifs.dart';
/// Main entry point for the Skitty app
Future<void> main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive database
  await Hive.initFlutter();
  Hive.registerAdapter(FeedingAdapter());
  await Hive.openBox<Feeding>(FeedingRepo.boxName);
  // Initialize notifications
  await Notifs.instance.init();
  // Start the app
  runApp(const SkittyApp());
}

/// Root widget for the Skitty app
class SkittyApp extends StatelessWidget {
  const SkittyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set up MaterialApp with router and theme
    return MaterialApp.router(
      title: 'Skitty - Cat Feeding Tracker',
      routerConfig: AppRouter.router,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C5CE7),
        useMaterial3: true,
      ),
    );
  }
}
