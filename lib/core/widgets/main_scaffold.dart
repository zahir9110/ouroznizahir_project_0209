import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/chat/presentation/pages/chat_list_page.dart';
import '../../features/tickets/presentation/pages/tickets_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/organizer_dashboard/presentation/pages/organizer_dashboard_page.dart';
import '../models/user_type.dart';
import '../models/user.dart';
import '../models/organizer.dart';
import '../mock/mock_data_b2b2c.dart';
import '../services/favorites_service.dart';

class MainScaffold extends StatefulWidget {
  /// Current user (normalement récupéré depuis BLoC/Provider)
  final User? currentUser;
  
  /// Organizer profile (si user.userType == organizer)
  final Organizer? organizerProfile;
  
  /// Service de favoris
  final FavoritesService favoritesService;

  const MainScaffold({
    super.key,
    this.currentUser,
    this.organizerProfile,
    required this.favoritesService,
  });

  @override
  MainScaffoldState createState() => MainScaffoldState();
}

class MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  bool get _isOrganizer =>
      widget.currentUser?.userType == UserType.organizer;

  late List<Widget> _pages;
  late List<BottomNavigationBarItem> _navItems;

  @override
  void initState() {
    super.initState();
    _buildNavigationItems();
  }

  @override
  void didUpdateWidget(MainScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentUser?.userType != widget.currentUser?.userType) {
      _buildNavigationItems();
    }
  }

  void _buildNavigationItems() {
    if (_isOrganizer) {
      // 🎯 ORGANIZER MODE: 6 tabs (avec Dashboard PRO)
      _pages = [
        HomePage(favoritesService: widget.favoritesService),
        const MapPage(),
        const ChatListPage(),
        OrganizerDashboardPage(
          organizer: widget.organizerProfile ?? _mockOrganizer,
          stats: MockDataB2B2C.mockDashboardStats,
        ),
        const TicketsPage(),
        const ProfilePage(),
      ];

      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Accueil",
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: "Carte",
          activeIcon: Icon(Icons.map),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Messages",
          activeIcon: Icon(Icons.chat_bubble),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          label: "Dashboard",
          activeIcon: Icon(Icons.dashboard),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number_outlined),
          label: "Billets",
          activeIcon: Icon(Icons.confirmation_number),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profil",
          activeIcon: Icon(Icons.person),
        ),
      ];
    } else {
      // 🎯 TRAVELER MODE: 5 tabs (sans Dashboard)
      _pages = [
        HomePage(favoritesService: widget.favoritesService),
        const MapPage(),
        const ChatListPage(),
        const TicketsPage(),
        const ProfilePage(),
      ];

      _navItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Accueil",
          activeIcon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.map_outlined),
          label: "Carte",
          activeIcon: Icon(Icons.map),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          label: "Messages",
          activeIcon: Icon(Icons.chat_bubble),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_number_outlined),
          label: "Billets",
          activeIcon: Icon(Icons.confirmation_number),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: "Profil",
          activeIcon: Icon(Icons.person),
        ),
      ];
    }
  }

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
        type: BottomNavigationBarType.fixed, // Important pour 6 items
      ),
    );
  }

  // Mock organizer pour démo (normalement vient de BLoC/Repository)
  static final Organizer _mockOrganizer = Organizer(
    id: 'org_001',
    userId: 'user_001',
    businessName: 'Culture Porto',
    businessType: 'Association culturelle',
    verificationStatus: VerificationStatus.approved,
    badgeLevel: BadgeLevel.verified,
    commissionRate: 8.0,
    totalRevenue: 234500,
    totalBookings: 45,
    ratingAverage: 4.8,
    ratingCount: 38,
    subscriptionTier: SubscriptionTier.free,
    createdAt: DateTime.now().subtract(const Duration(days: 90)),
    updatedAt: DateTime.now(),
  );
}