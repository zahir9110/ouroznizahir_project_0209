import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/story.dart';
import '../../domain/entities/story_segment.dart';
import '../../domain/entities/story_cta.dart';
import '../../domain/repositories/stories_repository.dart';
import '../models/story_model.dart';

abstract class StoriesRemoteDataSource {
  Stream<List<StoryModel>> getFollowingStories(String userId);
  Future<List<StoryModel>> getUserStories(String userId);
  Future<StoryModel> getStoryById(String storyId);
  
  Future<String> createStory({
    required String userId,
    required List<StorySegmentUpload> segments,
    required StoryType type,
    String? eventId,
    String? ticketId,
    StoryCTA? cta,
  });
  
  Future<void> recordView({
    required String storyId,
    required String viewerId,
    required int segmentIndex,
    required bool completed,
  });
  
  Future<void> recordInteraction({
    required String storyId,
    required String userId,
    required StoryCTAType ctaType,
  });
  
  Future<void> deleteStory(String storyId, String userId);
  
  Stream<List<StoryModel>> getActiveStoriesNearby({
    required GeoPoint location,
    double radiusKm = 50,
  });
}

class StoriesRemoteDataSourceImpl implements StoriesRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  StoriesRemoteDataSourceImpl({
    required this.firestore,
    required this.storage,
  });

  @override
  Stream<List<StoryModel>> getFollowingStories(String userId) {
    try {
      // Récupérer depuis collection dénormalisée stories_feed
      return firestore
          .collection('users')
          .doc(userId)
          .collection('stories_feed')
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .asyncMap((feedSnapshot) async {
        final List<StoryModel> stories = [];

        for (final feedDoc in feedSnapshot.docs) {
          final storyId = feedDoc.id;
          final storyDoc =
              await firestore.collection('stories').doc(storyId).get();

          if (storyDoc.exists &&
              storyDoc.data()?['status'] == 'active') {
            stories.add(StoryModel.fromFirestore(storyDoc));
          }
        }

        return stories;
      });
    } catch (e) {
      throw ServerException('Erreur récupération stories: $e');
    }
  }

  @override
  Future<List<StoryModel>> getUserStories(String userId) async {
    try {
      final snapshot = await firestore
          .collection('stories')
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => StoryModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException('Erreur récupération stories utilisateur: $e');
    }
  }

  @override
  Future<StoryModel> getStoryById(String storyId) async {
    try {
      final doc = await firestore.collection('stories').doc(storyId).get();

      if (!doc.exists) {
        throw const ServerException('Story introuvable');
      }

      return StoryModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Erreur récupération story: $e');
    }
  }

  @override
  Future<String> createStory({
    required String userId,
    required List<StorySegmentUpload> segments,
    required StoryType type,
    String? eventId,
    String? ticketId,
    StoryCTA? cta,
  }) async {
    try {
      // Upload médias vers Storage
      final uploadedSegments = await _uploadSegments(userId, segments);

      // Créer document story
      final storyRef = firestore.collection('stories').doc();
      final expiresAt = DateTime.now().add(const Duration(hours: 24));

      // TODO: Récupérer infos utilisateur depuis users/{userId}
      final userDoc = await firestore.collection('users').doc(userId).get();
      final userData = userDoc.data() ?? {};

      final story = StoryModel(
        id: storyRef.id,
        userId: userId,
        userDisplayName: userData['displayName'] as String? ?? 'Utilisateur',
        userPhotoUrl: userData['photoUrl'] as String? ?? '',
        createdAt: DateTime.now(),
        expiresAt: expiresAt,
        type: type,
        eventId: eventId,
        ticketId: ticketId,
        segments: uploadedSegments,
        cta: cta,
        isVerified: userData['isVerified'] as bool? ?? false,
      );

      await storyRef.set(story.toFirestore());

      // Fanout aux followers (via Cloud Function pour meilleure perf)
      // La Cloud Function écoutera la création et propagera

      return storyRef.id;
    } catch (e) {
      throw ServerException('Erreur création story: $e');
    }
  }

  @override
  Future<void> recordView({
    required String storyId,
    required String viewerId,
    required int segmentIndex,
    required bool completed,
  }) async {
    try {
      final viewerRef = firestore
          .collection('stories')
          .doc(storyId)
          .collection('viewers')
          .doc(viewerId);

      await firestore.runTransaction((transaction) async {
        final viewerDoc = await transaction.get(viewerRef);

        if (!viewerDoc.exists) {
          // Première vue
          transaction.set(viewerRef, {
            'viewedAt': FieldValue.serverTimestamp(),
            'viewedSegments': [segmentIndex],
            'completedFully': completed,
            'interacted': false,
          });

          // Incrémenter compteur
          final storyRef = firestore.collection('stories').doc(storyId);
          transaction.update(storyRef, {
            'viewsCount': FieldValue.increment(1),
          });
        } else {
          // Mise à jour
          transaction.update(viewerRef, {
            'viewedSegments': FieldValue.arrayUnion([segmentIndex]),
            'completedFully': completed,
          });

          if (completed) {
            final storyRef = firestore.collection('stories').doc(storyId);
            transaction.update(storyRef, {
              'completionCount': FieldValue.increment(1),
            });
          }
        }
      });
    } catch (e) {
      throw ServerException('Erreur enregistrement vue: $e');
    }
  }

  @override
  Future<void> recordInteraction({
    required String storyId,
    required String userId,
    required StoryCTAType ctaType,
  }) async {
    try {
      await firestore.runTransaction((transaction) async {
        final storyRef = firestore.collection('stories').doc(storyId);
        transaction.update(storyRef, {
          'interactionsCount': FieldValue.increment(1),
        });

        final viewerRef = storyRef.collection('viewers').doc(userId);
        transaction.update(viewerRef, {
          'interacted': true,
          'interactionType': ctaType.toFirestoreString(),
        });
      });
    } catch (e) {
      throw ServerException('Erreur enregistrement interaction: $e');
    }
  }

  @override
  Future<void> deleteStory(String storyId, String userId) async {
    try {
      await firestore.collection('stories').doc(storyId).update({
        'status': 'deleted',
      });

      // TODO: Supprimer médias Storage (optionnel)
    } catch (e) {
      throw ServerException('Erreur suppression story: $e');
    }
  }

  @override
  Stream<List<StoryModel>> getActiveStoriesNearby({
    required GeoPoint location,
    double radiusKm = 50,
  }) {
    try {
      // TODO: Implémenter géoquery avec geohash ou extension Firestore
      // Pour l'instant, on récupère toutes les stories actives
      return firestore
          .collection('stories')
          .where('status', isEqualTo: 'active')
          .orderBy('createdAt', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StoryModel.fromFirestore(doc))
              .toList());
    } catch (e) {
      throw ServerException('Erreur récupération stories nearby: $e');
    }
  }

  /// Upload segments vers Storage
  Future<List<StorySegment>> _uploadSegments(
    String userId,
    List<StorySegmentUpload> uploads,
  ) async {
    final List<StorySegment> segments = [];

    for (int i = 0; i < uploads.length; i++) {
      final upload = uploads[i];
      final segmentId = const Uuid().v4();
      final extension = upload.localPath.split('.').last;
      final storagePath =
          'stories/$userId/$segmentId.$extension';

      final file = File(upload.localPath);
      final uploadTask = storage.ref(storagePath).putFile(file);

      await uploadTask;
      final downloadUrl = await storage.ref(storagePath).getDownloadURL();

      segments.add(StorySegment(
        id: segmentId,
        type: upload.type,
        mediaUrl: downloadUrl,
        duration: upload.duration,
        order: i,
      ));
    }

    return segments;
  }
}
