import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/verification_bloc.dart';
import '../widgets/steps/identity_step.dart';
import '../widgets/steps/professional_step.dart';
import '../widgets/steps/location_step.dart';
import '../widgets/steps/documents_step.dart';
import '../widgets/steps/media_step.dart';
import '../widgets/steps/history_step.dart';

class VerificationWizardPage extends StatefulWidget {
  const VerificationWizardPage({super.key});

  @override
  State<VerificationWizardPage> createState() => _VerificationWizardPageState();
}

class _VerificationWizardPageState extends State<VerificationWizardPage> {
  int _currentStep = 0;
  final PageController _pageController = PageController();

  // ============================================
  // 🎯 6 ÉTAPES ALIGNÉES SUR LES 3 QUESTIONS
  // ============================================
  final List<WizardStep> _steps = [
    // 👉 Question 1: Cette personne existe vraiment ?
    WizardStep(
      index: 0,
      title: 'Identité',
      subtitle: 'Qui êtes-vous ?',
      icon: Icons.badge_outlined,
      validationGetter: (state) {
        final s = state is VerificationInProgress ? state : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        return s.stepIdentityValid;
      },
      questionCategory: QuestionCategory.identity,
    ),
    
    // 👉 Question 2: Légitimité métier
    WizardStep(
      index: 1,
      title: 'Métier',
      subtitle: 'Votre activité',
      icon: Icons.work_outline,
      validationGetter: (state) {
        final s = state is VerificationInProgress ? state : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        return s.stepProfessionalValid;
      },
      questionCategory: QuestionCategory.legitimacy,
    ),
    
    // 👉 Question 2: Localisation vérifiable
    WizardStep(
      index: 2,
      title: 'Localisation',
      subtitle: 'Où vous trouvez-vous ?',
      icon: Icons.location_on_outlined,
      validationGetter: (state) {
        final s = state is VerificationInProgress ? state : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        return s.stepLocationValid;
      },
      questionCategory: QuestionCategory.legitimacy,
    ),
    
    // 👉 Question 2: Documents professionnels (optionnel mais booste)
    WizardStep(
      index: 3,
      title: 'Documents',
      subtitle: 'Justificatifs (optionnel)',
      icon: Icons.folder_open_outlined,
      validationGetter: (state) {
        final s = state is VerificationInProgress ? state : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        return s.stepDocumentsValid;
      },
      questionCategory: QuestionCategory.legitimacy,
      isOptional: true,
    ),
    
    // 👉 Question 3: Confiance immédiate (preuves visuelles)
    WizardStep(
      index: 4,
      title: 'Photos',
      subtitle: 'Votre lieu en images',
      icon: Icons.photo_camera_outlined,
      validationGetter: (state) {
        final s = state is VerificationInProgress ? state : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        return s.stepMediaValid;
      },
      questionCategory: QuestionCategory.trust,
      isRequiredForTrust: true,
    ),
    
    // 👉 Question 3: Historique et réputation
    WizardStep(
      index: 5,
      title: 'Expérience',
      subtitle: 'Votre historique (optionnel)',
      icon: Icons.star_outline,
      validationGetter: (state) {
        final s = state is VerificationInProgress ? state : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        return s.stepHistoryValid;
      },
      questionCategory: QuestionCategory.trust,
      isOptional: true,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _steps.length - 1) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToStep(int index) {
    // Navigation intelligente : permet de revenir en arrière librement
    // mais bloque l'avance si étape précédente invalide
    if (index <= _currentStep || _canAccessStep(index)) {
      setState(() => _currentStep = index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _canAccessStep(int targetIndex) {
    // Vérifie que toutes les étapes précédentes sont valides
    final state = context.read<VerificationBloc>().state;
    for (int i = 0; i < targetIndex; i++) {
      if (!_steps[i].validationGetter(state)) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerificationBloc, VerificationState>(
      listener: (context, state) {        final progressState = state is VerificationInProgress 
            ? state 
            : const VerificationInProgress(currentStep: 0, completionPercentage: 0);        // Auto-navigation si étape suivante devient valide
        if (progressState.submissionStatus == VerificationSubmissionStatus.success) {
          Navigator.of(context).pop(true);
        }
      },
      builder: (context, state) {
        final progressState = state is VerificationInProgress 
            ? state 
            : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
            
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          appBar: _buildAppBar(progressState),
          body: Column(
            children: [
              // 🎯 Indicateur de progression contextualisé
              _buildProgressHeader(progressState),
              
              // 📊 Stepper visuel avec couleurs par catégorie
              _buildStepper(progressState),
              
              // 📄 Contenu des étapes
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Contrôlé par boutons
                  children: [
                    IdentityStep(onNext: _nextStep),
                    ProfessionalStep(onNext: _nextStep),
                    LocationStep(onNext: _nextStep),
                    DocumentsStep(onNext: _nextStep),
                    MediaStep(onNext: _nextStep),
                    HistoryStep(onNext: _nextStep, onSubmit: _submit),
                  ],
                ),
              ),
              
              // 🧭 Navigation inférieure
              _buildBottomNavigation(progressState),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(VerificationInProgress state) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => _showExitConfirmation(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vérification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            '${(state.completionProgress * 100).toInt()}% complété',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        // Auto-save indicator
        if (state.lastSaved != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Sauvegardé ${state.lastSaved!.hour}:${state.lastSaved!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green[600],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProgressHeader(VerificationInProgress state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar avec segments colorés par catégorie
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                // Identity (Question 1) - Bleu
                Expanded(
                  flex: state.identityValid ? 33 : (state.fullName.isNotEmpty ? 15 : 5),
                  child: Container(
                    height: 6,
                    color: state.identityValid 
                        ? const Color(0xFF2196F3) 
                        : const Color(0xFFE3F2FD),
                  ),
                ),
                // Legitimacy (Question 2) - Orange
                Expanded(
                  flex: state.legitimacyValid ? 33 : (state.professionalType != null ? 20 : 10),
                  child: Container(
                    height: 6,
                    color: state.legitimacyValid 
                        ? const Color(0xFFFF9800) 
                        : const Color(0xFFFFF3E0),
                  ),
                ),
                // Trust (Question 3) - Vert
                Expanded(
                  flex: state.trustValid ? 34 : (state.placePhotos.isNotEmpty ? 20 : 10),
                  child: Container(
                    height: 6,
                    color: state.trustValid 
                        ? const Color(0xFF4CAF50) 
                        : const Color(0xFFE8F5E9),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Légende des questions
          Row(
            children: [
              _buildQuestionIndicator(
                'Identité', 
                state.identityValid, 
                const Color(0xFF2196F3),
                state.identityValid ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
              const SizedBox(width: 16),
              _buildQuestionIndicator(
                'Légitimité', 
                state.legitimacyValid, 
                const Color(0xFFFF9800),
                state.legitimacyValid ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
              const SizedBox(width: 16),
              _buildQuestionIndicator(
                'Confiance', 
                state.trustValid, 
                const Color(0xFF4CAF50),
                state.trustValid ? Icons.check_circle : Icons.radio_button_unchecked,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionIndicator(
    String label, 
    bool isValid, 
    Color color, 
    IconData icon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: isValid ? color : Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isValid ? color : Colors.grey[500],
            fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepper(VerificationInProgress state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _steps.map((step) {
          final isActive = step.index == _currentStep;
          final isCompleted = step.validationGetter(state);
          final isAccessible = _canAccessStep(step.index);
          
          return Expanded(
            child: GestureDetector(
              onTap: isAccessible ? () => _goToStep(step.index) : null,
              child: Column(
                children: [
                  // Cercle avec icône
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted 
                          ? step.questionCategory.color 
                          : isActive 
                              ? step.questionCategory.color.withValues(alpha: 0.2)
                              : Colors.grey[200],
                      border: isActive 
                          ? Border.all(color: step.questionCategory.color, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? Icon(Icons.check, size: 18, color: Colors.white)
                          : Icon(
                              step.icon, 
                              size: 18, 
                              color: isActive 
                                  ? step.questionCategory.color 
                                  : Colors.grey[500],
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Label abrégé
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? step.questionCategory.color : Colors.grey[600],
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  // Badge optionnel
                  if (step.isOptional)
                    Text(
                      'opt.',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.grey[400],
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNavigation(VerificationInProgress state) {
    final currentStepConfig = _steps[_currentStep];
    final isLastStep = _currentStep == _steps.length - 1;
    final canProceed = currentStepConfig.validationGetter(state);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Bouton retour
            if (_currentStep > 0)
              TextButton.icon(
                onPressed: _previousStep,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[700],
                ),
              )
            else
              const SizedBox(width: 80),
            
            const Spacer(),
            
            // Indicateur d'étape
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: currentStepConfig.questionCategory.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${_currentStep + 1}/${_steps.length}',
                style: TextStyle(
                  color: currentStepConfig.questionCategory.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const Spacer(),
            
            // Bouton suivant/soumettre
            ElevatedButton.icon(
              onPressed: canProceed 
                  ? (isLastStep ? () => _submit(state) : _nextStep)
                  : null,
              icon: Icon(isLastStep ? Icons.verified : Icons.arrow_forward),
              label: Text(isLastStep ? 'Soumettre' : 'Continuer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: currentStepConfig.questionCategory.color,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(VerificationState state) {
    final progressState = state is VerificationInProgress 
        ? state 
        : const VerificationInProgress(currentStep: 0, completionPercentage: 0);
        
    if (!progressState.isReadyForSubmission) {
      _showIncompleteDialog(context, progressState);
      return;
    }

    // Afficher récapitulatif IA avant soumission
    showDialog(
      context: context,
      builder: (context) => _buildSubmissionDialog(progressState),
    );
  }

  Widget _buildSubmissionDialog(VerificationInProgress state) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.psychology, color: const Color(0xFF9C27B0)),
          const SizedBox(width: 8),
          const Text('Analyse IA'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notre IA va analyser votre demande selon 3 critères :',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),
          _buildAIScoreRow('Pertinence culturelle', 50, Icons.temple_buddhist),
          const SizedBox(height: 8),
          _buildAIScoreRow('Cohérence localisation', 20, Icons.map),
          const SizedBox(height: 8),
          _buildAIScoreRow('Qualité documents', 30, Icons.description),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: const Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Vous recevrez une réponse sous 24h. En cas de doute, un réviseur manuel prendra le relais.',
                    style: TextStyle(fontSize: 12, color: Colors.green[800]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Modifier'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<VerificationBloc>().add(VerificationSubmitted());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
          ),
          child: const Text('Confirmer la soumission'),
        ),
      ],
    );
  }

  Widget _buildAIScoreRow(String label, int weight, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '$weight%',
            style: const TextStyle(
              color: Color(0xFF9C27B0),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _showIncompleteDialog(BuildContext context, VerificationInProgress state) {
    final missing = <String>[];
    if (!state.identityValid) missing.add('Identité complète');
    if (!state.legitimacyValid) missing.add('Localisation vérifiée');
    if (!state.trustValid) missing.add('Photos du lieu (min. 3)');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informations manquantes'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pour garantir la confiance des voyageurs, il manque :'),
            const SizedBox(height: 12),
            ...missing.map((m) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.orange[700], size: 18),
                  const SizedBox(width: 8),
                  Text(m),
                ],
              ),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Compris'),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quitter la vérification ?'),
        content: const Text('Vos informations sont sauvegardées automatiquement. Vous pourrez reprendre plus tard.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Rester'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Quitter', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// ============================================
// 🧩 CLASSES UTILITAIRES
// ============================================

enum QuestionCategory {
  identity(Color(0xFF2196F3)),      // Bleu - Question 1
  legitimacy(Color(0xFFFF9800)),     // Orange - Question 2  
  trust(Color(0xFF4CAF50));          // Vert - Question 3

  final Color color;
  const QuestionCategory(this.color);
}

class WizardStep {
  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool Function(VerificationState) validationGetter;
  final QuestionCategory questionCategory;
  final bool isOptional;
  final bool isRequiredForTrust;

  const WizardStep({
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.validationGetter,
    required this.questionCategory,
    this.isOptional = false,
    this.isRequiredForTrust = false,
  });
}