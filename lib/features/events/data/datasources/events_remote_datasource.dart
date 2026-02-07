import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../models/enriched_event_model.dart';

abstract class EventsRemoteDataSource {
  Stream<List<EnrichedEventModel>> getPersonalizedFeed({
    required String userId,
    required GeoPoint userLocation,
    int limit = 20,
  });

  Stream<List<EnrichedEventModel>> getCulturalGems();
  Stream<List<EnrichedEventModel>> getSpontaneousEvents(GeoPoint location);
  Future<EnrichedEventModel> getEventById(String eventId);
}

class EventsRemoteDataSourceImpl implements EventsRemoteDataSource {
  final FirebaseFirestore firestore;

  EventsRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<EnrichedEventModel>> getPersonalizedFeed({
    required String userId,
    required GeoPoint userLocation,
    int limit = 20,
  }) {
    try {
      final now = DateTime.now();
      final nextWeek = now.add(const Duration(days: 7));

      return firestore
          .collection('events')
          .where('freshness', isEqualTo: 'live')
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('startDate', isLessThan: Timestamp.fromDate(nextWeek))
          .orderBy('startDate')
          .limit(limit)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EnrichedEventModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw ServerException('Erreur récupération feed: $e');
    }
  }

  @override
  Stream<List<EnrichedEventModel>> getCulturalGems() {
    try {
      return firestore
          .collection('events')
          .where('freshness', isEqualTo: 'live')
          .where('culturalScore', isGreaterThan: 80)
          .orderBy('culturalScore', descending: true)
          .limit(10)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EnrichedEventModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw ServerException('Erreur récupération gems: $e');
    }
  }

  @override
  Stream<List<EnrichedEventModel>> getSpontaneousEvents(GeoPoint location) {
    try {
      final today = DateTime.now();
      final tomorrow = today.add(const Duration(days: 1));

      return firestore
          .collection('events')
          .where('freshness', isEqualTo: 'live')
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .where('startDate', isLessThan: Timestamp.fromDate(tomorrow))
          .orderBy('startDate')
          .limit(5)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => EnrichedEventModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw ServerException('Erreur récupération spontaneous: $e');
    }
  }

  @override
  Future<EnrichedEventModel> getEventById(String eventId) async {
    try {
      final doc = await firestore.collection('events').doc(eventId).get();

      if (!doc.exists) {
        throw const ServerException('Événement introuvable');
      }

      return EnrichedEventModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Erreur récupération événement: $e');
    }
  }
}
