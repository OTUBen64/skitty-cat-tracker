import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
/// AppScaffold provides the main app layout with navigation
class AppScaffold extends StatelessWidget {
  const AppScaffold({super.key, required this.child});
  /// The main content widget for each route
  final Widget child;

  /// Maps route location to navigation index
  int _locationToIndex(String location) {
    if (location.startsWith('/history')) return 1;
    if (location.startsWith('/stats')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0; // /home
  }

  /// Handles navigation bar taps
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/history');
        break;
      case 2:
        context.go('/stats');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current route location and index
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    // Main scaffold with app bar, content, and navigation bar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skitty - Cat Feeding Tracker'),
      ),
      body: SafeArea(child: child),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (i) => _onItemTapped(context, i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.pets_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
