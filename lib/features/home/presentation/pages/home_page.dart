import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/mock/mock_data_b2b2c.dart';
import '../../../../core/models/offer.dart';
import '../../../../core/models/user_type.dart';
import '../../../../core/widgets/offer_card.dart';
import '../../../../core/widgets/location_filter.dart';
import '../../../../core/services/favorites_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../stories/presentation/pages/stories_feed_bar.dart';
import '../../../favorites/presentation/pages/favorites_page.dart';

class HomePage extends StatefulWidget {
  final FavoritesService favoritesService;
  
  const HomePage({super.key, required this.favoritesService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final Set<String> _likedOffers = {};
  final Set<String> _savedOffers = {};
  late TabController _tabController;
  OfferCategory? _selectedCategory;
  
  // Filtres géographiques (activés par défaut)
  BeninRegion _selectedRegion = BeninRegion.all;
  double _maxDistance = 50;
  bool _useUserLocation = true; // ✅ Activé par défaut
  bool _showLocationFilter = false;
  final LocationService _locationService = LocationService();
  bool _isLoadingLocation = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          switch (_tabController.index) {
            case 0:
              _selectedCategory = null;
              break;
            case 1:
              _selectedCategory = OfferCategory.event;
              break;
            case 2:
              _selectedCategory = OfferCategory.tour;
              break;
            case 3:
              _selectedCategory = OfferCategory.accommodation;
              break;
            case 4:
              _selectedCategory = OfferCategory.transport;
              break;
          }
        });
      }
    });
    
    // 🗺️ Charger position utilisateur au démarrage
    _loadUserLocation();
  }

  Future<void> _loadUserLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _useUserLocation = position != null;
        });
        
        if (position != null) {
          debugPrint('📍 Position chargée au démarrage: ${position.latitude}, ${position.longitude}');
        } else {
          debugPrint('⚠️ Permission localisation refusée - mode région par défaut');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _useUserLocation = false;
        });
      }
      debugPrint('❌ Erreur chargement position: $e');
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Offer> get _filteredOffers {
    var offers = _selectedCategory == null
        ? MockDataB2B2C.mockOffers
        : MockDataB2B2C.mockOffers
            .where((offer) => offer.category == _selectedCategory)
            .toList();

    // Filtrage géographique
    if (_selectedRegion != BeninRegion.all && _selectedRegion.latitude != null) {
      // TODO: Filtrer par région (nécessite latitude/longitude dans Offer)
      debugPrint('🗺️ Filtrage par région: ${_selectedRegion.displayName}');
    }

    // Tri par distance (si localisation utilisateur activée)
    if (_useUserLocation && _locationService.currentPosition != null) {
      offers.sort((a, b) {
        // TODO: Calculer distance réelle avec lat/lng des offres
        // Pour l'instant, tri aléatoire comme placeholder
        return 0;
      });
      debugPrint('📍 Tri par distance activé');
    }

    return offers;
  }

  int _getCategoryCount(OfferCategory? category) {
    if (category == null) return MockDataB2B2C.mockOffers.length;
    return MockDataB2B2C.mockOffers
        .where((offer) => offer.category == category)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // 🎯 AppBar minimal (Instagram-like)
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'bōken',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border, color: AppColors.textPrimary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesPage(
                    favoritesService: widget.favoritesService,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              _showLocationFilter ? Icons.filter_list : Icons.filter_list_outlined,
              color: AppColors.textPrimary,
            ),
            onPressed: () {
              setState(() {
                _showLocationFilter = !_showLocationFilter;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: AppColors.textPrimary),
            onPressed: () {
              debugPrint('🔔 Notifications');
            },
          ),
        ],
      ),
      
      body: CustomScrollView(
        slivers: [
          // 🎭 Stories (scroll horizontal)
          const SliverToBoxAdapter(
            child: StoriesFeedBar(currentUserId: 'user_current'),
          ),
      
      // 📍 Indicateur chargement localisation
      if (_isLoadingLocation)
        SliverToBoxAdapter(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            padding: EdgeInsets.all(12.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16.r,
                  height: 16.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    '🗺️ Recherche des offres près de vous...',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      
      // 🗺️ Filtres géographiques (conditionnel)
      if (_showLocationFilter)
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: LocationFilter(
              selectedRegion: _selectedRegion,
              maxDistance: _maxDistance,
              useUserLocation: _useUserLocation,
              onRegionChanged: (region) {
                setState(() {
                  _selectedRegion = region;
                });
              },
              onDistanceChanged: (distance) {
                setState(() {
                  _maxDistance = distance;
                });
              },
              onUseLocationChanged: (useLocation) async {
                if (useLocation) {
                  await _locationService.getCurrentPosition();
                }
                setState(() {
                  _useUserLocation = useLocation;
                });
              },
            ),
          ),
        ),
      
      // 🔍 Filtres par catégorie (TabBar)
      SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              height: 44.h,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Tout'),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _tabController.index == 0 
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${_getCategoryCount(null)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🎉 Événements'),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _tabController.index == 1
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${_getCategoryCount(OfferCategory.event)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🗺️ Visites'),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _tabController.index == 2
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${_getCategoryCount(OfferCategory.tour)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🏠 Hébergements'),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _tabController.index == 3
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${_getCategoryCount(OfferCategory.accommodation)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🚗 Transports'),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: _tabController.index == 4
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceGray,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${_getCategoryCount(OfferCategory.transport)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 📱 Feed vertical (offers avec CTA)
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final offer = _filteredOffers[index];
                  
                  return OfferCard(
                    offer: offer,
                    favoritesService: widget.favoritesService,
                    isLiked: _likedOffers.contains(offer.id),
                    isSaved: _savedOffers.contains(offer.id),
                    onTap: () {
                      debugPrint('👆 Tap on offer: ${offer.title}');
                      // TODO: Navigate to offer detail
                    },
                    onBookingPressed: () {
                      debugPrint('🎟️ Booking: ${offer.title}');
                      // TODO: Navigate to booking page
                      _showBookingBottomSheet(context, offer);
                    },
                    onLike: () {
                      setState(() {
                        if (_likedOffers.contains(offer.id)) {
                          _likedOffers.remove(offer.id);
                        } else {
                          _likedOffers.add(offer.id);
                        }
                      });
                    },
                    onSave: () {
                      setState(() {
                        if (_savedOffers.contains(offer.id)) {
                          _savedOffers.remove(offer.id);
                        } else {
                          _savedOffers.add(offer.id);
                        }
                      });
                    },
                  );
                },
                childCount: _filteredOffers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBookingBottomSheet(BuildContext context, Offer offer) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              offer.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              offer.displayPrice,
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  debugPrint('✅ Confirm booking');
                  // TODO: Navigate to payment
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Text(
                  'Continuer',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
