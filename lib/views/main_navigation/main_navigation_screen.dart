import 'package:flutter/material.dart';
import 'package:scorelivepro/views/favorites_views/favorites_screen.dart';
import 'package:scorelivepro/views/home_views/home_screen.dart';
import 'package:scorelivepro/views/league_views/leagues_screen.dart';
import 'package:scorelivepro/views/news_views/news_screen.dart';
import 'package:scorelivepro/views/settings/settings_screen.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';

/// Main Navigation Screen with Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    const HomeScreen(), // Matches/Home
    const FavoritesScreen(),
    const NewsScreen(),
    const LeaguesScreen(),
    const SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
