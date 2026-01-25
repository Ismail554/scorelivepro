import 'package:flutter/material.dart';
import 'package:scorelivepro/views/favorites_views/favorites_screen.dart';
import 'package:scorelivepro/views/home_views/home_screen.dart';
import 'package:scorelivepro/views/league_views/leagues_screen.dart';
import 'package:scorelivepro/views/news_views/news_screen.dart';
import 'package:scorelivepro/views/settings/settings_screen.dart';
import 'package:scorelivepro/services/socket_service.dart';
import 'package:scorelivepro/widget/navigation/custom_bottom_nav_bar.dart';

/// Main Navigation Screen with Bottom Navigation Bar
class MainNavigationScreen extends StatefulWidget {
  final int? initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 0;

    // Initialize socket connection (public access)
    SocketService.instance.connectSocket("");
  }

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
