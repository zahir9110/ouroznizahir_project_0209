import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/events/presentation/pages/events_feed_page.dart'; // NOUVEAU
import '../../features/tickets/presentation/pages/tickets_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  MainScaffoldState createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const MapPage(),
    const EventsFeedPage(), // NOUVEAU - Index 2
    const TicketsPage(),    // Décalé à index 3
    const ProfilePage(),    // Décalé à index 4
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      label: "Accueil",
      activeIcon: Icon(Icons.home),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.map_outlined),
      label: "Carte",
      activeIcon: Icon(Icons.map),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.event_outlined), // NOUVEAU
      label: "Événements",
      activeIcon: Icon(Icons.event),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.confirmation_number_outlined),
      label: "Billets",
      activeIcon: Icon(Icons.confirmation_number),
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      label: "Profil",
      activeIcon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
        type: BottomNavigationBarType.fixed, // Important pour 5 items
      ),
    );
  }
}