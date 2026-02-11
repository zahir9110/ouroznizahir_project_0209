import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:benin_experience/core/theme/be_theme.dart';
import 'package:benin_experience/core/widgets/be_bottom_nav.dart';
import 'package:benin_experience/features/demo/presentation/pages/demo_feed_page.dart';

/// Benin Experience - Demo App
/// Application de démonstration du nouveau design system
void main() {
  runApp(const BEDesignSystemDemo());
}

class BEDesignSystemDemo extends StatelessWidget {
  const BEDesignSystemDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 11 Pro
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Bōken',
          debugShowCheckedModeBanner: false,
          theme: BETheme.light,
          home: const MainScaffold(),
        );
      },
    );
  }
}

/// Main Scaffold avec bottom navigation
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DemoFeedPage(),
    const DemoMapPage(),
    const DemoEventsPage(),
    const DemoTicketsPage(),
    const DemoProfilePage(),
  ];

  late final List<BEBottomNavItem> _navItems;

  @override
  void initState() {
    super.initState();
    _navItems = [
      BEBottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Accueil',
      ),
      BEBottomNavItem(
        icon: Icons.map_outlined,
        activeIcon: Icons.map,
        label: 'Carte',
      ),
      BEBottomNavItem(
        icon: Icons.celebration_outlined,
        activeIcon: Icons.celebration,
        label: 'Événements',
        badgeCount: 3,
      ),
      BEBottomNavItem(
        icon: Icons.confirmation_number_outlined,
        activeIcon: Icons.confirmation_number,
        label: 'Billets',
      ),
      BEBottomNavItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profil',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BEBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: _navItems,
      ),
    );
  }
}

/// Placeholder pages
class DemoMapPage extends StatelessWidget {
  const DemoMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Carte')),
    );
  }
}

class DemoEventsPage extends StatelessWidget {
  const DemoEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Événements')),
    );
  }
}

class DemoTicketsPage extends StatelessWidget {
  const DemoTicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Billets')),
    );
  }
}

class DemoProfilePage extends StatelessWidget {
  const DemoProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Profil')),
    );
  }
}
