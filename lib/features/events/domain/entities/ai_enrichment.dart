import 'package:equatable/equatable.dart';

/// Données d'enrichissement IA pour un événement
/// Généré par GPT-4 via Cloud Functions
class AIEnrichment extends Equatable {
  /// Description attractive générée par IA (3 phrases max)
  final String enhancedDescription;

  /// Tags culturels béninois
  /// Ex: ['vodun', 'danse_traditionnelle', 'gastronomie']
  final List<String> culturalTags;

  /// Types d'activités
  /// Ex: ['spectacle', 'atelier', 'festival']
  final List<String> activityTypes;

  /// Score authenticité culturelle (0-100)
  final double culturalScore;

  /// Score attractivité touristique (0-100)
  final double attractivenessScore;

  /// Vector embedding pour recherche sémantique
  final List<double> embedding;

  /// Public cible: 'familles', 'backpackers', 'luxury', 'couples'
  final String targetAudience;

  /// Conseil insider (1 phrase) pour vivre comme un local
  final String localInsight;

  const AIEnrichment({
    required this.enhancedDescription,
    required this.culturalTags,
    required this.activityTypes,
    required this.culturalScore,
    required this.attractivenessScore,
    required this.embedding,
    required this.targetAudience,
    required this.localInsight,
  });

  @override
  List<Object?> get props => [
        enhancedDescription,
        culturalTags,
        culturalScore,
        attractivenessScore,
      ];
}
