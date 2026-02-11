import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:benin_experience/core/theme/app_colors.dart';
import 'package:benin_experience/core/models/organizer.dart';
import 'package:benin_experience/core/widgets/organizer_widgets.dart';
import 'package:benin_experience/core/widgets/revenue_charts.dart';
import 'package:benin_experience/core/widgets/dashboard_notifications.dart';
import 'package:benin_experience/core/widgets/boost_payment_modal.dart';
import 'package:benin_experience/core/mock/mock_data_b2b2c.dart';
import '../../../organizer_offers/presentation/pages/my_offers_page.dart';
import '../../../organizer_offers/presentation/pages/create_offer_page.dart';

/// Dashboard Home Page - Page principale du dashboard organisateur
/// Affiche les statistiques clés, revenus, bookings, etc.
class OrganizerDashboardPage extends StatelessWidget {
  final Organizer organizer;
  final DashboardStats stats;

  const OrganizerDashboardPage({
    super.key,
    required this.organizer,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          'Dashboard PRO',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              debugPrint('⚙️ Settings');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // TODO: Refresh data
          await Future.delayed(const Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Organizer info + badge
              _buildOrganizerHeader(),

              SizedBox(height: 24.h),

              // Period selector
              Text(
                'Ce mois',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: 12.h),

              // Stats cards grid (2x2)
              _buildStatsGrid(),

              SizedBox(height: 24.h),

              // Revenue line chart (7 days)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.surfaceGray,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '📈 Revenus des 7 derniers jours',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    RevenueLineChart(
                      dailyRevenues: MockDataB2B2C.mockDailyRevenues,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Bookings bar chart (top 5 offers)
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.surfaceGray,
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎟️ Top 5 offres par réservations',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    BookingsBarChart(
                      offerBookings: MockDataB2B2C.mockOfferBookings,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Notifications dashboard
              _buildNotificationsSection(),

              SizedBox(height: 24.h),

              // Next payout info
              _buildNextPayoutCard(),

              SizedBox(height: 24.h),

              // Top regions
              _buildTopRegionsCard(),

              SizedBox(height: 24.h),

              // Quick actions
              _buildQuickActions(context),

              SizedBox(height: 80.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizerHeader() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.surfaceGray,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar/Icon
          Container(
            width: 48.r,
            height: 48.r,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFFF59E0B)],
              ),
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Center(
              child: Text(
                organizer.businessName[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  organizer.businessName,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    OrganizerBadgeWidget(organizer: organizer),
                    if (organizer.ratingCount > 0) ...[
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.star,
                        size: 14.r,
                        color: AppColors.accent,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        organizer.displayRating,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        ' (${organizer.ratingCount})',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12.h,
      crossAxisSpacing: 12.w,
      childAspectRatio: 1.3,
      children: [
        DashboardStatCard(
          value: '${stats.monthlyRevenue.toStringAsFixed(0)}',
          label: 'XOF Revenus',
          icon: Icons.account_balance_wallet_outlined,
          color: AppColors.primary,
          onTap: () {
            debugPrint('💰 Navigate to earnings');
          },
        ),
        DashboardStatCard(
          value: '${stats.monthlyBookings}',
          label: 'Billets vendus',
          icon: Icons.confirmation_number_outlined,
          color: AppColors.accent,
          onTap: () {
            debugPrint('🎟️ Navigate to bookings');
          },
        ),
        DashboardStatCard(
          value: '${(stats.confirmationRate).toStringAsFixed(1)}%',
          label: 'Taux confirm.',
          icon: Icons.check_circle_outline,
          color: const Color(0xFF10B981),
        ),
        DashboardStatCard(
          value: stats.averageRating.toStringAsFixed(1),
          label: 'Note moyenne',
          icon: Icons.star_outline,
          color: AppColors.accent,
          subtitle: '⭐',
          onTap: () {
            debugPrint('⭐ Navigate to reviews');
          },
        ),
      ],
    );
  }

  Widget _buildNextPayoutCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.payments_outlined,
                size: 24.r,
                color: Colors.white,
              ),
              SizedBox(width: 8.w),
              Text(
                'Paiements à venir',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            '${stats.nextPayoutAmount.toStringAsFixed(0)} XOF',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          if (stats.nextPayoutDate != null)
            Text(
              'Prochain versement: ${_formatDate(stats.nextPayoutDate!)}',
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withOpacity(0.9),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopRegionsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.surfaceGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📍 Top régions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          ...stats.bookingsByRegion.entries.take(3).map((entry) {
            final totalBookings = stats.bookingsByRegion.values
                .reduce((sum, value) => sum + value);
            final percentage = (entry.value / totalBookings * 100);

            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            _quickActionChip(
              icon: Icons.add_circle_outline,
              label: 'Nouvelle offre',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateOfferPage(
                      organizerId: organizer.id,
                    ),
                  ),
                );
              },
            ),
            _quickActionChip(
              icon: Icons.inventory_2_outlined,
              label: 'Mes offres',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyOffersPage(
                      organizerId: organizer.id,
                    ),
                  ),
                );
              },
            ),
            _quickActionChip(
              icon: Icons.bolt,
              label: '🚀 Booster',
              gradient: const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
              ),
              onTap: () {
                _showBoostModal(context);
              },
            ),
            _quickActionChip(
              icon: Icons.bar_chart,
              label: 'Analytics',
              onTap: () {
                debugPrint('📊 View analytics');
              },
            ),
            _quickActionChip(
              icon: Icons.qr_code_scanner,
              label: 'Scanner ticket',
              onTap: () {
                debugPrint('📷 Scan ticket');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _quickActionChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Gradient? gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: gradient == null ? Colors.white : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(20.r),
          border: gradient == null
              ? Border.all(
                  color: AppColors.primary,
                  width: 1.5,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18.r,
              color: gradient == null ? AppColors.primary : Colors.white,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: gradient == null ? AppColors.primary : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    // Mock notifications (TODO: remplacer par vraies données)
    final mockNotifications = [
      DashboardNotification(
        id: '1',
        type: NotificationType.newBooking,
        title: 'Nouvelle réservation',
        message: 'Festival Jazz de Cotonou - 2 billets',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        actionLabel: 'Voir',
      ),
      DashboardNotification(
        id: '2',
        type: NotificationType.lowStock,
        title: 'Stock faible',
        message: 'Villa Papillon - Plus que 3 places',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
        actionLabel: 'Gérer',
      ),
      DashboardNotification(
        id: '3',
        type: NotificationType.newReview,
        title: 'Nouvel avis',
        message: 'Tour de Ouidah - ⭐⭐⭐⭐⭐ (5/5)',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      DashboardNotification(
        id: '4',
        type: NotificationType.payoutReady,
        title: 'Paiement disponible',
        message: '28,500 XOF prêt à être transféré',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        actionLabel: 'Retirer',
      ),
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.surfaceGray,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '🔔 Notifications',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  debugPrint('📱 Voir toutes les notifications');
                },
                child: Text(
                  'Voir toutes',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          DashboardNotificationsList(
            notifications: mockNotifications,
            maxVisible: 4,
            onMarkAllRead: () {
              debugPrint('✅ Marquer toutes comme lues');
            },
            onNotificationTap: (notification) {
              debugPrint('👆 Notification tap: ${notification.id}');
            },
          ),
        ],
      ),
    );
  }

  void _showBoostModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BoostPaymentModal(
        offerId: 'offer_123', // TODO: use real offer ID
        offerTitle: 'Festival Jazz de Cotonou',
        onBoostSelected: (option) {
          debugPrint('🚀 Boost selected: ${option.name} - ${option.price} XOF');
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Fév',
      'Mar',
      'Avr',
      'Mai',
      'Jun',
      'Jul',
      'Aoû',
      'Sep',
      'Oct',
      'Nov',
      'Déc'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
