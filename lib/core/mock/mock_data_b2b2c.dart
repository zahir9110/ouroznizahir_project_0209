import 'package:benin_experience/core/models/user_type.dart';
import 'package:benin_experience/core/models/offer.dart';
import 'package:benin_experience/core/models/organizer.dart';

/// Mock Data pour tester l'UI avec le nouveau modèle B2B2C
class MockDataB2B2C {
  // Mock Offers (anciennes events transformées)
  static final List<Offer> mockOffers = [
    Offer(
      id: '1',
      organizerId: 'org_001',
      category: OfferCategory.event,
      title: 'Festival de Jazz Porto-Novo 2026',
      description:
          'Grand festival de jazz annuel réunissant les meilleurs artistes locaux et internationaux.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800',
      ],
      locationName: 'Porto-Novo',
      latitude: 6.4969,
      longitude: 2.6289,
      priceMin: 5000,
      priceMax: 15000,
      currency: 'XOF',
      eventDate: DateTime.now().add(const Duration(days: 15)),
      eventEndDate: DateTime.now().add(const Duration(days: 17)),
      capacity: 500,
      availableSpots: 234,
      status: 'published',
      isFeatured: true,
      boostExpiresAt: DateTime.now().add(const Duration(days: 5)),
      viewsCount: 1245,
      likesCount: 234,
      bookingsCount: 266,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      updatedAt: DateTime.now(),
      organizerName: 'Culture Porto',
      organizerAvatar:
          'https://ui-avatars.com/api/?name=Culture+Porto&background=2563EB&color=fff',
      organizerBadge: BadgeLevel.verified,
      organizerRating: 4.8,
    ),
    Offer(
      id: '2',
      organizerId: 'org_002',
      category: OfferCategory.tour,
      title: 'Visite guidée - Route des Esclaves Ouidah',
      description:
          'Découvrez l\'histoire poignante de la traite négrière à travers un parcours historique guidé.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
      ],
      locationName: 'Ouidah',
      latitude: 6.3622,
      longitude: 2.0852,
      priceMin: 3000,
      currency: 'XOF',
      status: 'published',
      isFeatured: false,
      viewsCount: 856,
      likesCount: 145,
      bookingsCount: 89,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now(),
      organizerName: 'Ouidah Tours',
      organizerAvatar:
          'https://ui-avatars.com/api/?name=Ouidah+Tours&background=F59E0B&color=fff',
      organizerBadge: BadgeLevel.verified,
      organizerRating: 4.9,
    ),
    Offer(
      id: '3',
      organizerId: 'org_003',
      category: OfferCategory.accommodation,
      title: 'Villa Papillon - Hébergement de charme',
      description:
          'Villa traditionnelle rénovée avec piscine, située en plein cœur de Cotonou.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      ],
      locationName: 'Cotonou',
      latitude: 6.3703,
      longitude: 2.3912,
      priceMin: 25000,
      priceMax: 45000,
      currency: 'XOF',
      checkInTime: '14:00',
      checkOutTime: '11:00',
      amenities: ['WiFi', 'Piscine', 'Parking', 'Climatisation', 'Petit-déj'],
      status: 'published',
      isFeatured: false,
      viewsCount: 2134,
      likesCount: 456,
      bookingsCount: 145,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now(),
      organizerName: 'Villa Papillon',
      organizerAvatar:
          'https://ui-avatars.com/api/?name=Villa+Papillon&background=10B981&color=fff',
      organizerBadge: BadgeLevel.premium,
      organizerRating: 4.7,
    ),
    Offer(
      id: '4',
      organizerId: 'org_004',
      category: OfferCategory.transport,
      title: 'Transfert aéroport Cotonou',
      description:
          'Service de transport privé climatisé depuis l\'aéroport Cardinal Bernardin Gantin.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1449965408869-eaa3f722e40d?w=800',
      ],
      locationName: 'Cotonou',
      latitude: 6.3703,
      longitude: 2.3912,
      priceMin: 8000,
      priceMax: 15000,
      currency: 'XOF',
      vehicleType: 'Berline climatisée',
      routeFrom: 'Aéroport Cardinal Bernardin Gantin',
      routeTo: 'Centre-ville Cotonou',
      status: 'published',
      isFeatured: false,
      viewsCount: 543,
      likesCount: 67,
      bookingsCount: 234,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
      organizerName: 'Benin Transfer',
      organizerAvatar:
          'https://ui-avatars.com/api/?name=Benin+Transfer&background=8B5CF6&color=fff',
      organizerBadge: BadgeLevel.verified,
      organizerRating: 4.6,
    ),
    Offer(
      id: '5',
      organizerId: 'org_005',
      category: OfferCategory.site,
      title: 'Palais Royal d\'Abomey',
      description:
          'Découvrez le patrimoine mondial de l\'UNESCO, ancien siège du royaume du Dahomey.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1563656353898-febc9270a0f8?w=800',
      ],
      locationName: 'Abomey',
      latitude: 7.1826,
      longitude: 1.9910,
      priceMin: 2000,
      currency: 'XOF',
      status: 'published',
      isFeatured: true,
      boostExpiresAt: DateTime.now().add(const Duration(days: 10)),
      viewsCount: 3456,
      likesCount: 678,
      bookingsCount: 456,
      createdAt: DateTime.now().subtract(const Duration(days: 90)),
      updatedAt: DateTime.now(),
      organizerName: 'Musée Abomey',
      organizerAvatar:
          'https://ui-avatars.com/api/?name=Musée+Abomey&background=DC2626&color=fff',
      organizerBadge: BadgeLevel.enterprise,
      organizerRating: 4.9,
    ),
    Offer(
      id: '6',
      organizerId: 'org_001',
      category: OfferCategory.event,
      title: 'Concert Angélique Kidjo - Cotonou',
      description:
          'Concert exceptionnel de la diva béninoise, lauréate de 5 Grammy Awards.',
      mediaUrls: [
        'https://images.unsplash.com/photo-1540039155733-5bb30b53aa14?w=800',
      ],
      locationName: 'Cotonou',
      latitude: 6.3703,
      longitude: 2.3912,
      priceMin: 10000,
      priceMax: 50000,
      currency: 'XOF',
      eventDate: DateTime.now().add(const Duration(days: 30)),
      capacity: 2000,
      availableSpots: 0,
      status: 'sold_out',
      isFeatured: true,
      viewsCount: 8234,
      likesCount: 1456,
      bookingsCount: 2000,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now(),
      organizerName: 'Culture Porto',
      organizerAvatar:
          'https://ui-avatars.com/api/?name=Culture+Porto&background=2563EB&color=fff',
      organizerBadge: BadgeLevel.verified,
      organizerRating: 4.8,
    ),
  ];

  // Mock Dashboard Stats
  static final DashboardStats mockDashboardStats = DashboardStats(
    monthlyRevenue: 234500,
    monthlyBookings: 45,
    confirmationRate: 98.2,
    averageRating: 4.8,
    topOffers: [
      OfferPerformance(
        offerId: '1',
        offerTitle: 'Festival Porto-Novo',
        revenue: 85000,
        bookingsCount: 17,
        conversionRate: 12.5,
      ),
      OfferPerformance(
        offerId: '2',
        offerTitle: 'Tour Ouidah',
        revenue: 52000,
        bookingsCount: 13,
        conversionRate: 8.3,
      ),
      OfferPerformance(
        offerId: '3',
        offerTitle: 'Villa Papillon',
        revenue: 31000,
        bookingsCount: 7,
        conversionRate: 5.2,
      ),
    ],
    bookingsByRegion: {
      'Cotonou': 20,
      'Porto-Novo': 13,
      'Ouidah': 8,
      'Abomey': 4,
    },
    nextPayoutDate: DateTime.now().add(const Duration(days: 5)),
    nextPayoutAmount: 215740, // 234500 - 8% commission
  );

  // Mock Revenus journaliers (7 derniers jours) - pour graphique
  static final List<double> mockDailyRevenues = [
    28500, // Lundi
    31200, // Mardi
    27800, // Mercredi
    35400, // Jeudi
    42100, // Vendredi
    38900, // Samedi
    30600, // Dimanche
  ];

  // Mock Bookings par offre - pour graphique bar
  static final Map<String, int> mockOfferBookings = {
    'Festival Jazz': 17,
    'Tour Ouidah': 13,
    'Villa Papillon': 7,
    'Transport VIP': 5,
    'Concert Palais': 3,
  };
}
