import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// Option de boost pour une offre
class BoostOption {
  final String id;
  final String name;
  final int durationDays;
  final int price;
  final String currency;
  final String description;
  final List<String> features;
  final bool isPopular;

  BoostOption({
    required this.id,
    required this.name,
    required this.durationDays,
    required this.price,
    this.currency = 'XOF',
    required this.description,
    required this.features,
    this.isPopular = false,
  });

  String get displayPrice => '$price $currency';
  String get displayDuration =>
      durationDays == 1 ? '1 jour' : '$durationDays jours';
}

/// Modal de sélection de boost pour une offre
/// Affiche 3 options (Starter, Standard, Premium) avec features
class BoostPaymentModal extends StatefulWidget {
  final String offerId;
  final String offerTitle;
  final Function(BoostOption selectedOption)? onBoostSelected;

  const BoostPaymentModal({
    super.key,
    required this.offerId,
    required this.offerTitle,
    this.onBoostSelected,
  });

  @override
  State<BoostPaymentModal> createState() => _BoostPaymentModalState();
}

class _BoostPaymentModalState extends State<BoostPaymentModal> {
  BoostOption? _selectedOption;

  static final List<BoostOption> _boostOptions = [
    BoostOption(
      id: 'starter',
      name: 'Starter',
      durationDays: 3,
      price: 2000,
      description: 'Boost léger pour tester',
      features: [
        'Priorité feed pendant 3 jours',
        'Badge "Boost" visible',
        '+30% de visibilité estimée',
        'Analytics basiques',
      ],
    ),
    BoostOption(
      id: 'standard',
      name: 'Standard',
      durationDays: 7,
      price: 5000,
      description: 'Le plus populaire',
      features: [
        'Priorité feed pendant 7 jours',
        'Badge "Boost" visible',
        '+60% de visibilité estimée',
        'Analytics détaillées',
        'Push notifications ciblées',
      ],
      isPopular: true,
    ),
    BoostOption(
      id: 'premium',
      name: 'Premium',
      durationDays: 14,
      price: 10000,
      description: 'Maximum de visibilité',
      features: [
        'Priorité feed pendant 14 jours',
        'Badge "Boost" + Featured',
        '+100% de visibilité estimée',
        'Analytics détaillées + export',
        'Push notifications ciblées',
        'Support prioritaire',
        'Mise en avant homepage',
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Pré-sélectionner l'option Standard (populaire)
    _selectedOption = _boostOptions[1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2563EB), Color(0xFFF59E0B)],
                        ),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.bolt,
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booster votre offre',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            widget.offerTitle,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Le boost augmente la visibilité de votre offre dans le feed',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Options de boost
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: _boostOptions.map((option) {
                  return _buildBoostOption(option);
                }).toList(),
              ),
            ),
          ),

          // Actions
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: AppColors.divider, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Prix récapitulatif
                if (_selectedOption != null)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    margin: EdgeInsets.only(bottom: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total à payer',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          _selectedOption!.displayPrice,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                // Bouton continuer
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: _selectedOption == null ? null : _handleContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.divider,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continuer vers le paiement',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward, size: 18.r),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoostOption(BoostOption option) {
    final isSelected = _selectedOption?.id == option.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.05)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                // Radio
                Container(
                  width: 24.r,
                  height: 24.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: 2,
                    ),
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          size: 16.r,
                          color: Colors.white,
                        )
                      : null,
                ),

                SizedBox(width: 12.w),

                // Titre + badge populaire
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        option.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (option.isPopular) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFEF4444), Color(0xFFF59E0B)],
                            ),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            '🔥 Populaire',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Prix
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      option.displayPrice,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      option.displayDuration,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 8.h),

            // Description
            Text(
              option.description,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),

            SizedBox(height: 12.h),

            // Features
            ...option.features.map((feature) {
              return Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16.r,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        feature,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedOption == null) return;

    // Fermer le modal
    Navigator.pop(context);

    // Afficher le modal de paiement
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PaymentMethodModal(
        amount: _selectedOption!.price,
        currency: _selectedOption!.currency,
        boostOption: _selectedOption!,
        offerId: widget.offerId,
        onPaymentSuccess: () {
          widget.onBoostSelected?.call(_selectedOption!);
        },
      ),
    );
  }
}

/// Modal de sélection du moyen de paiement
class PaymentMethodModal extends StatelessWidget {
  final int amount;
  final String currency;
  final BoostOption boostOption;
  final String offerId;
  final VoidCallback? onPaymentSuccess;

  const PaymentMethodModal({
    super.key,
    required this.amount,
    required this.currency,
    required this.boostOption,
    required this.offerId,
    this.onPaymentSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Titre
          Text(
            'Choisir votre moyen de paiement',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: 8.h),

          // Montant
          Text(
            '$amount $currency',
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),

          SizedBox(height: 24.h),

          // Mobile Money
          _buildPaymentOption(
            context,
            icon: Icons.phone_android,
            title: 'Mobile Money',
            subtitle: 'MTN, Moov, Celtiis',
            gradient: const LinearGradient(
              colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
            ),
            onTap: () => _handlePayment(context, 'mobile_money'),
          ),

          SizedBox(height: 12.h),

          // Carte bancaire
          _buildPaymentOption(
            context,
            icon: Icons.credit_card,
            title: 'Carte bancaire',
            subtitle: 'Visa, Mastercard',
            gradient: const LinearGradient(
              colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
            ),
            onTap: () => _handlePayment(context, 'card'),
          ),

          SizedBox(height: 20.h),

          // Annuler
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: gradient.scale(0.1),
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24.r,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.r,
              color: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment(BuildContext context, String method) {
    // TODO: Intégrer Stripe ou Mobile Money API
    debugPrint('💳 Paiement via $method: $amount $currency');

    // Simuler paiement réussi
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                '✅ Boost activé ! Votre offre est maintenant prioritaire.',
                style: TextStyle(fontSize: 14.sp),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF10B981),
        duration: const Duration(seconds: 3),
      ),
    );

    onPaymentSuccess?.call();
  }
}

// Extension pour gradient scale
extension GradientScale on Gradient {
  Gradient scale(double opacity) {
    if (this is LinearGradient) {
      final lg = this as LinearGradient;
      return LinearGradient(
        colors: lg.colors.map((c) => c.withOpacity(opacity)).toList(),
        begin: lg.begin,
        end: lg.end,
      );
    }
    return this;
  }
}
