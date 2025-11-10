import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          'Home – quick “Feed Now” actions will go here.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
