import '../../domain/entities/ai_enrichment.dart';

class AIEnrichmentModel extends AIEnrichment {
  const AIEnrichmentModel({
    required super.enhancedDescription,
    required super.culturalTags,
    required super.activityTypes,
    required super.culturalScore,
    required super.attractivenessScore,
    required super.embedding,
    required super.targetAudience,
    required super.localInsight,
  });

  /// Conversion depuis Map Firestore
  factory AIEnrichmentModel.fromMap(Map<String, dynamic> map) {
    return AIEnrichmentModel(
      enhancedDescription: map['enhancedDescription'] ?? '',
      culturalTags: List<String>.from(map['culturalTags'] ?? []),
      activityTypes: List<String>.from(map['activityTypes'] ?? []),
      culturalScore: (map['culturalScore'] ?? 0).toDouble(),
      attractivenessScore: (map['attractivenessScore'] ?? 0).toDouble(),
      embedding: List<double>.from(map['embedding'] ?? []),
      targetAudience: map['targetAudience'] ?? '',
      localInsight: map['localInsight'] ?? '',
    );
  }

  /// Conversion vers Map Firestore
  Map<String, dynamic> toMap() {
    return {
      'enhancedDescription': enhancedDescription,
      'culturalTags': culturalTags,
      'activityTypes': activityTypes,
      'culturalScore': culturalScore,
      'attractivenessScore': attractivenessScore,
      'embedding': embedding,
      'targetAudience': targetAudience,
      'localInsight': localInsight,
    };
  }
}
