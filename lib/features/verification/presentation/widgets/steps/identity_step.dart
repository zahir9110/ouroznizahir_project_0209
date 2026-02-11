import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/verification_bloc.dart';
import '../document_uploader.dart';

/// Étape 1 : Identité (Question 1 - Cette personne existe vraiment ?)
/// Couleur thématique : Bleu (#2196F3)
class IdentityStep extends StatefulWidget {
  final VoidCallback onNext;

  const IdentityStep({
    super.key,
    required this.onNext,
  });

  @override
  State<IdentityStep> createState() => _IdentityStepState();
}

class _IdentityStepState extends State<IdentityStep> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        final progressState = state is VerificationInProgress 
            ? state 
            : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
            
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // En-tête avec icône
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        color: const Color(0xFF2196F3),
                        size: 32.sp,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Votre identité',
                            style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Informations personnelles vérifiables',
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

                // Nom complet
                Text(
                  'Nom complet *',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    hintText: 'Ex: Honoré AGOSSOU',
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF2196F3)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le nom complet est requis';
                    }
                    if (value.trim().split(' ').length < 2) {
                      return 'Veuillez entrer nom et prénom(s)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    context.read<VerificationBloc>().add(
                      VerificationDraftSaved(),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Téléphone
                Text(
                  'Numéro de téléphone *',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: '+229 XX XX XX XX',
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.phone_outlined, color: Color(0xFF2196F3)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Le numéro de téléphone est requis';
                    }
                    // Validation Bénin: +229 suivi de 8 chiffres
                    final benin = RegExp(r'^\+229\s?\d{8}$');
                    if (!benin.hasMatch(value.replaceAll(' ', ''))) {
                      return 'Format invalide (+229 XX XX XX XX)';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    context.read<VerificationBloc>().add(
                      VerificationDraftSaved(),
                    );
                  },
                ),
                SizedBox(height: 24.h),

                // Email (optionnel)
                Text(
                  'Email (optionnel)',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'votre.email@exemple.com',
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2196F3)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Format email invalide';
                      }
                    }
                    return null;
                  },
                  onChanged: (value) {
                    context.read<VerificationBloc>().add(
                      VerificationDraftSaved(),
                    );
                  },
                ),
                SizedBox(height: 32.h),

                // Upload photo d'identité
                Text(
                  'Pièce d\'identité *',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Carte d\'identité nationale, passeport ou permis de conduire',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 12.h),
                SecureDocumentUploader(
                  title: 'Pièce d\'identité',
                  description: 'Photo claire et lisible (recto)',
                  type: DocumentType.idCard,
                  existingUrl: null,
                  onUploaded: (url) {
                    context.read<VerificationBloc>().add(
                      VerificationDraftSaved(),
                    );
                  },
                  onProgress: (progress) {},
                ),
                SizedBox(height: 24.h),

                // Conseil sécurité
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.security,
                        color: const Color(0xFF4CAF50),
                        size: 24.sp,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Vos données sont sécurisées',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2E7D32),
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Documents chiffrés et accessibles uniquement à l\'équipe de vérification.',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Indicateur de validation
                if (progressState.stepIdentityValid)
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 20),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            'Identité complète et valide',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.green[800],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}