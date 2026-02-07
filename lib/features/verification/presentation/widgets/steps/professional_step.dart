import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/verification_bloc.dart';

/// Étape 2 : Légitimité métier (Question 2)
/// Valide que l'utilisateur a une activité professionnelle légitime
class ProfessionalStep extends StatefulWidget {
  final VoidCallback onNext;

  const ProfessionalStep({
    super.key,
    required this.onNext,
  });

  @override
  State<ProfessionalStep> createState() => _ProfessionalStepState();
}

class _ProfessionalStepState extends State<ProfessionalStep> {
  String? _selectedProfessionalType;
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _businessNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Titre de l'étape
              const Text(
                'Votre activité professionnelle',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Aidez-nous à comprendre votre métier pour mieux vous mettre en valeur',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Type d'activité
              const Text(
                'Type d\'activité *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _buildProfessionChip('Artisan', Icons.handyman),
                  _buildProfessionChip('Guide touristique', Icons.tour),
                  _buildProfessionChip('Restaurant', Icons.restaurant),
                  _buildProfessionChip('Hôtel', Icons.hotel),
                  _buildProfessionChip('Transport', Icons.directions_car),
                  _buildProfessionChip('Événementiel', Icons.event),
                  _buildProfessionChip('Autre', Icons.more_horiz),
                ],
              ),
              const SizedBox(height: 24),

              // Nom de l'entreprise/activité
              const Text(
                'Nom de votre entreprise/activité *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _businessNameController,
                decoration: InputDecoration(
                  hintText: 'Ex: Chez Honoré, Tissage Traditionnel...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.business),
                ),
                onChanged: (value) {
                  // TODO: Dispatch update event
                },
              ),
              const SizedBox(height: 24),

              // Description
              const Text(
                'Description de votre activité *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Décrivez ce que vous proposez aux voyageurs...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  // TODO: Dispatch update event
                },
              ),
              const SizedBox(height: 32),

              // Conseils IA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFF9800)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: const Color(0xFFFF9800),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Conseil IA',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE65100),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Mentionnez votre spécialité locale (Ex: "Artisan spécialisé dans le bronze du royaume du Dahomey") pour un meilleur score de pertinence culturelle.',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
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

  Widget _buildProfessionChip(String label, IconData icon) {
    final isSelected = _selectedProfessionalType == label;
    
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedProfessionalType = selected ? label : null;
        });
        // TODO: Dispatch update event
      },
      selectedColor: const Color(0xFFFF9800).withValues(alpha: 0.2),
      backgroundColor: Colors.grey[100],
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFFFF9800) : Colors.grey[700],
      ),
    );
  }
}
