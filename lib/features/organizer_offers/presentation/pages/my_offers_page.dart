import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/offer.dart';
import '../../../../core/mock/mock_data_b2b2c.dart';
import '../../../../core/widgets/organizer_widgets.dart';
import '../widgets/my_offer_card.dart';
import 'create_offer_page.dart';

/// Page "Mes Offres" - Liste des offres de l'organisateur
class MyOffersPage extends StatefulWidget {
  final String organizerId;

  const MyOffersPage({
    super.key,
    required this.organizerId,
  });

  @override
  State<MyOffersPage> createState() => _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'all'; // all, published, draft, paused

  // Mock offers (en prod, vient du BLoC/Repository)
  List<Offer> _offers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadOffers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadOffers() {
    // En prod: fetchOffers(widget.organizerId)
    setState(() {
      _offers = MockDataB2B2C.mockOffers
          .where((offer) => offer.organizerId == 'org_001')
          .toList();
    });
  }

  List<Offer> get _filteredOffers {
    if (_selectedFilter == 'all') return _offers;
    return _offers.where((offer) => offer.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final publishedCount = _offers.where((o) => o.status == 'published').length;
    final draftCount = _offers.where((o) => o.status == 'draft').length;
    final pausedCount = _offers.where((o) => o.status == 'paused').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Mes Offres',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: _showFilterMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          // 📊 Stats rapides
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _QuickStat(
                  value: _offers.length.toString(),
                  label: 'Total',
                  color: AppColors.primary,
                ),
                _QuickStat(
                  value: publishedCount.toString(),
                  label: 'Publiées',
                  color: AppColors.primaryGreen,
                ),
                _QuickStat(
                  value: draftCount.toString(),
                  label: 'Brouillons',
                  color: AppColors.textSecondary,
                ),
                _QuickStat(
                  value: pausedCount.toString(),
                  label: 'En pause',
                  color: AppColors.accent,
                ),
              ],
            ),
          ),

          // 🔖 Filtres tabs
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textTertiary,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle: TextStyle(fontSize: 14.sp),
            onTap: (index) {
              setState(() {
                _selectedFilter = ['all', 'published', 'draft', 'paused'][index];
              });
            },
            tabs: const [
              Tab(text: 'Toutes'),
              Tab(text: 'Publiées'),
              Tab(text: 'Brouillons'),
              Tab(text: 'En pause'),
            ],
          ),

          SizedBox(height: 8.h),

          // 📱 Liste des offres
          Expanded(
            child: _filteredOffers.isEmpty
                ? Center(
                    child: EmptyStateWidget(
                      icon: Icons.inventory_2_outlined,
                      title: _getEmptyTitle(),
                      subtitle: _getEmptySubtitle(),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      _loadOffers();
                    },
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      itemCount: _filteredOffers.length,
                      itemBuilder: (context, index) {
                        final offer = _filteredOffers[index];
                        return MyOfferCard(
                          offer: offer,
                          onTap: () => _viewOfferDetails(offer),
                          onEdit: () => _editOffer(offer),
                          onDelete: () => _deleteOffer(offer),
                          onBoost: () => _boostOffer(offer),
                          onToggleStatus: () => _toggleOfferStatus(offer),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),

      // 🎯 FAB Créer offre
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToCreateOffer,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Nouvelle offre',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getEmptyTitle() {
    switch (_selectedFilter) {
      case 'published':
        return 'Aucune offre publiée';
      case 'draft':
        return 'Aucun brouillon';
      case 'paused':
        return 'Aucune offre en pause';
      default:
        return 'Aucune offre créée';
    }
  }

  String _getEmptySubtitle() {
    switch (_selectedFilter) {
      case 'published':
        return 'Publiez une offre pour commencer à recevoir des réservations';
      case 'draft':
        return 'Vos brouillons apparaîtront ici';
      case 'paused':
        return 'Les offres mises en pause apparaîtront ici';
      default:
        return 'Créez votre première offre et commencez à vendre';
    }
  }

  void _showFilterMenu() {
    // TODO: Implement advanced filters (category, date, price range)
    debugPrint('🔍 Show filter menu');
  }

  void _navigateToCreateOffer() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOfferPage(
          organizerId: widget.organizerId,
        ),
      ),
    ).then((_) => _loadOffers());
  }

  void _viewOfferDetails(Offer offer) {
    debugPrint('👁️ View details: ${offer.title}');
    // TODO: Navigate to offer detail page
  }

  void _editOffer(Offer offer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOfferPage(
          organizerId: widget.organizerId,
          editingOffer: offer,
        ),
      ),
    ).then((_) => _loadOffers());
  }

  void _deleteOffer(Offer offer) {
    setState(() {
      _offers.removeWhere((o) => o.id == offer.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Offre "${offer.title}" supprimée'),
        action: SnackBarAction(
          label: 'Annuler',
          onPressed: () {
            setState(() {
              _offers.add(offer);
            });
          },
        ),
      ),
    );
  }

  void _boostOffer(Offer offer) {
    debugPrint('⚡ Boost offer: ${offer.title}');
    // TODO: Navigate to boost payment page
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booster votre offre'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choisissez un type de boost :',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.h),
            _BoostOption(
              title: 'Feed 7 jours',
              price: '2000 XOF',
              description: 'Apparaît en haut du feed pendant 7 jours',
            ),
            _BoostOption(
              title: 'Guide 30 jours',
              price: '5000 XOF',
              description: 'Apparaît dans la section "Guide" pendant 30 jours',
            ),
            _BoostOption(
              title: 'Top expérience',
              price: '10000 XOF',
              description: 'Mise en avant maximum pendant 30 jours',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
        ],
      ),
    );
  }

  void _toggleOfferStatus(Offer offer) {
    final newStatus = offer.status == 'published' ? 'paused' : 'published';
    
    setState(() {
      final index = _offers.indexWhere((o) => o.id == offer.id);
      if (index != -1) {
        // Note: Offer is immutable, so we'd need to create a new instance
        // For demo, just show snackbar
        debugPrint('Toggle status: ${offer.status} -> $newStatus');
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          newStatus == 'published'
              ? 'Offre publiée avec succès'
              : 'Offre mise en pause',
        ),
      ),
    );
  }
}

class _QuickStat extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _QuickStat({
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}

class _BoostOption extends StatelessWidget {
  final String title;
  final String price;
  final String description;

  const _BoostOption({
    required this.title,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.divider),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}
