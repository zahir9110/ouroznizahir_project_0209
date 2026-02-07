import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/verification_bloc.dart';

/// Étape 6 : Expérience et historique (Question 3 - Trust - OPTIONNEL)
/// Couleur thématique : Vert (#4CAF50)
class HistoryStep extends StatefulWidget {
  final VoidCallback onNext;
  final Function(VerificationState state) onSubmit;

  const HistoryStep({
    super.key,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  State<HistoryStep> createState() => _HistoryStepState();
}

class _HistoryStepState extends State<HistoryStep> {
  final _bioController = TextEditingController();
  final _achievementsController = TextEditingController();

  @override
  void dispose() {
    _bioController.dispose();
    _achievementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.history_edu,
                      color: const Color(0xFF4CAF50),
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Votre histoire',
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Optionnel',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Partagez votre expérience et passion',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Biographie
              Text(
                'Présentez-vous aux voyageurs',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Racontez votre parcours, votre passion pour votre métier, ce qui rend votre activité unique...',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _bioController,
                maxLines: 5,
                maxLength: 500,
                decoration: InputDecoration(
                  hintText: 'Ex: Artisan depuis 15 ans, j\'ai appris le tissage traditionnel avec ma grand-mère. Aujourd\'hui, je perpétue cette tradition en créant des pièces uniques inspirées des motifs royaux d\'Abomey...',
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                  ),
                ),
                onChanged: (value) {
                  context.read<VerificationBloc>().add(
                    VerificationFieldChanged(
                      field: 'biography',
                      value: value,
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),

              // Réalisations / Mentions
              Text(
                'Vos réalisations ou mentions (optionnel)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Prix, certifications, collaborations, articles de presse...',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: _achievementsController,
                maxLines: 4,
                maxLength: 300,
                decoration: InputDecoration(
                  hintText: 'Ex: Lauréat du concours d\'artisanat Bénin 2023, collaboration avec l\'Office du Tourisme...',
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 2),
                  ),
                ),
                onChanged: (value) {
                  context.read<VerificationBloc>().add(
                    VerificationFieldChanged(
                      field: 'achievements',
                      value: value,
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),

              // Récapitulatif de soumission
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      const Color(0xFF2196F3).withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: const Color(0xFF4CAF50)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, color: const Color(0xFF4CAF50), size: 48.sp),
                    SizedBox(height: 16.h),
                    Text(
                      'Prêt pour la vérification !',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Notre équipe examinera votre profil sous 24-48h',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildProgressSummary('Identité vérifiée', state.stepIdentityValid),
                    SizedBox(height: 8.h),
                    _buildProgressSummary('Légitimité établie', state.legitimacyValid),
                    SizedBox(height: 8.h),
                    _buildProgressSummary('Confiance renforcée', state.trustValid),
                    SizedBox(height: 20.h),
                    ElevatedButton.icon(
                      onPressed: state.isReadyForSubmission
                          ? () => widget.onSubmit(state)
                          : null,
                      icon: const Icon(Icons.send),
                      label: const Text('Soumettre ma demande'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Note finale
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 24.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        'Une fois vérifié, vous recevrez un email et pourrez commencer à recevoir des demandes de voyageurs. Vous pourrez modifier votre profil à tout moment.',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.blue[900],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSummary(String label, bool isComplete) {
    return Row(
      children: [
        Icon(
          isComplete ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isComplete ? const Color(0xFF4CAF50) : Colors.grey[400],
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: isComplete ? const Color(0xFF4CAF50) : Colors.grey[600],
            fontWeight: isComplete ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
