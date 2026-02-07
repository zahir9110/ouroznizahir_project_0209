import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/enriched_event.dart';
import 'ai_enrichment_model.dart';

class EnrichedEventModel extends EnrichedEvent {
  const EnrichedEventModel({
    required super.id,
    required super.rawTitle,
    required super.rawDescription,
    required super.startDate,
    required super.endDate,
    required super.location,
    required super.locationCity,
    required super.source,
    required super.aiData,
    required super.freshness,
    required super.lastUpdated,
    required super.createdAt,
  });

  /// Conversion depuis DocumentSnapshot Firestore
  factory EnrichedEventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EnrichedEventModel(
      id: doc.id,
      rawTitle: data['rawTitle'] ?? '',
      rawDescription: data['rawDescription'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      location: data['location'] as GeoPoint,
      locationCity: data['locationCity'] ?? '',
      source: data['source'] ?? 'unknown',
      aiData: AIEnrichmentModel.fromMap(data['aiData'] ?? {}),
      freshness: EventFreshness.values.firstWhere(
        (e) => e.toString().split('.').last == (data['freshness'] ?? 'live'),
        orElse: () => EventFreshness.live,
      ),
      lastUpdated: (data['lastUpdated'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  /// Conversion vers Map Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'rawTitle': rawTitle,
      'rawDescription': rawDescription,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'location': location,
      'locationCity': locationCity,
      'source': source,
      'aiData': (aiData as AIEnrichmentModel).toMap(),
      'freshness': freshness.toString().split('.').last,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'createdAt': Timestamp.fromDate(createdAt),

      // Index pour requêtes Firestore
      'startDateMillis': startDate.millisecondsSinceEpoch,
      'culturalScore': aiData.culturalScore,
      'attractivenessScore': aiData.attractivenessScore,
    };
  }
}
