import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/verification_bloc.dart';
import '../document_uploader.dart';

/// Étape 5 : Photos du lieu (Question 3 - Confiance immédiate - REQUIS)
/// Couleur thématique : Vert (#4CAF50)
class MediaStep extends StatelessWidget {
  final VoidCallback onNext;

  const MediaStep({
    super.key,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        // Cast state to VerificationInProgress to access properties
        final progressState = state is VerificationInProgress 
            ? state 
            : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
            
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
                      Icons.photo_camera,
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
                              'Photos de votre lieu',
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
                                color: const Color(0xFF4CAF50),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'Requis',
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Montrez l\'authenticité de votre activité',
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
              SizedBox(height: 24.h),

              // Impact
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      const Color(0xFF4CAF50).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFF4CAF50)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: const Color(0xFF4CAF50), size: 32.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '📈 +500% de réservations',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Les profils avec photos authentiques reçoivent 5x plus de demandes',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Façade/Extérieur
              Text(
                '1. Façade ou extérieur * (minimum 1 photo)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Montrez où les visiteurs vont arriver',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              SecureDocumentUploader(
                title: 'Façade',
                description: 'Photo claire de l\'entrée ou de la devanture',
                type: DocumentType.locationPhoto,
                existingUrl: progressState.placePhotos.isNotEmpty ? progressState.placePhotos[0] : null,
                onUploaded: (url) {
                  context.read<VerificationBloc>().add(
                    VerificationDraftSaved(),
                  );
                },
                onProgress: (progress) {},
              ),
              SizedBox(height: 24.h),

              // Intérieur/Activité
              Text(
                '2. Intérieur ou activité en cours (recommandé)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Montrez votre espace de travail, vos produits ou services',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              SecureDocumentUploader(
                title: 'Activité',
                description: 'Photo de votre travail, atelier, boutique...',
                type: DocumentType.activityPhoto,
                existingUrl: progressState.placePhotos.length > 1 ? progressState.placePhotos[1] : null,
                onUploaded: (url) {
                  context.read<VerificationBloc>().add(
                    VerificationDraftSaved(),
                  );
                },
                onProgress: (progress) {},
              ),
              SizedBox(height: 24.h),

              // Photo 3 (optionnelle)
              Text(
                '3. Vue supplémentaire (optionnel)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Produits phares, équipe, détails culturels...',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              SecureDocumentUploader(
                title: 'Autre vue',
                description: 'Photo complémentaire de votre choix',
                type: DocumentType.activityPhoto,
                existingUrl: progressState.placePhotos.length > 2 ? progressState.placePhotos[2] : null,
                onUploaded: (url) {
                  context.read<VerificationBloc>().add(
                    VerificationDraftSaved(),
                  );
                },
                onProgress: (progress) {},
              ),
              SizedBox(height: 32.h),

              // Conseils photos
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFFF9800)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tips_and_updates, color: const Color(0xFFFF9800), size: 24.sp),
                        SizedBox(width: 8.w),
                        Text(
                          'Conseils pour de bonnes photos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE65100),
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildTip('✅ Lumière naturelle du jour'),
                    _buildTip('✅ Cadrage large et net'),
                    _buildTip('✅ Montrez l\'authenticité (évitez les filtres)'),
                    _buildTip('❌ Évitez les photos floues ou sombres'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: Colors.grey[800],
        ),
      ),
    );
  }
}
