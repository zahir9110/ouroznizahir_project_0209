import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/verification_bloc.dart';
import '../document_uploader.dart';

/// Étape 4 : Documents professionnels (Question 2 - Légitimité - OPTIONNEL)
/// Couleur thématique : Orange (#FF9800)
class DocumentsStep extends StatelessWidget {
  final VoidCallback onNext;

  const DocumentsStep({
    super.key,
    required this.onNext,
  });

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
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.folder_open,
                      color: const Color(0xFFFF9800),
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
                              'Documents officiels',
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
                          'Renforcez votre crédibilité (recommandé)',
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

              // Avantage badge
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF9800).withValues(alpha: 0.1),
                      const Color(0xFFFF9800).withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFFF9800)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified, color: const Color(0xFFFF9800), size: 32.sp),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🏆 Badge "Professionnel Vérifié"',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Augmente votre visibilité de +300% et inspire confiance aux voyageurs',
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

              // Registre du commerce
              Text(
                'Registre du commerce (RCCM)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Si vous avez une entreprise formellement enregistrée',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              SecureDocumentUploader(
                title: 'RCCM',
                description: 'Registre du Commerce et du Crédit Mobilier',
                type: DocumentType.businessRegistration,
                existingUrl: null,
                onUploaded: (url) {
                  context.read<VerificationBloc>().add(
                    VerificationDraftSaved(),
                  );
                },
                onProgress: (progress) {},
              ),
              SizedBox(height: 24.h),

              // IFU
              Text(
                'Identifiant Fiscal Unique (IFU)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Attestation délivrée par la Direction Générale des Impôts',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              SecureDocumentUploader(
                title: 'IFU',
                description: 'Certificat fiscal professionnel',
                type: DocumentType.taxDocument,
                existingUrl: null,
                onUploaded: (url) {
                  context.read<VerificationBloc>().add(
                    VerificationDraftSaved(),
                  );
                },
                onProgress: (progress) {},
              ),
              SizedBox(height: 24.h),

              // Licence professionnelle (guides, taxis, etc.)
              Text(
                'Licence professionnelle (si applicable)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Carte de guide, permis transport, agrément tourisme...',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 12.h),
              SecureDocumentUploader(
                title: 'Licence',
                description: 'Document professionnel officiel',
                type: DocumentType.businessRegistration,
                existingUrl: null,
                onUploaded: (url) {
                  context.read<VerificationBloc>().add(
                    VerificationDraftSaved(),
                  );
                },
                onProgress: (progress) {},
              ),
              SizedBox(height: 32.h),

              // Rappel "Optionnel mais recommandé"
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
                        'Vous pouvez sauter cette étape si vous n\'avez pas de documents officiels. Votre profil sera quand même visible, mais avec un score de confiance légèrement inférieur.',
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
}
