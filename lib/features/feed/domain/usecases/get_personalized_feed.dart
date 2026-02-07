import '../../data/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

// TODO: Implement these classes
class FeedRepository {
  Stream<List<FeedPost>> getNearbyPosts(String commune, {required int radiusKm}) async* {
    yield [];
  }
  
  Stream<List<FeedPost>> getCulturalHighlights({required int limit}) async* {
    yield [];
  }
  
  Stream<List<FeedPost>> getFollowingPosts() async* {
    yield [];
  }
  
  Stream<List<FeedPost>> getRegionalTrending(String department) async* {
    yield [];
  }
}

class LocationService {
  Future<GeoPoint> getCurrentLocation() async {
    return const GeoPoint(6.3703, 2.3912); // Cotonou coords par défaut
  }
  
  Future<Commune> getCommuneFromCoords(GeoPoint coords) async {
    return Commune(name: 'Cotonou', department: 'Littoral');
  }
}

class UserPreferencesService {
  // TODO: Implement user preferences
}

class Commune {
  final String name;
  final String department;
  
  Commune({required this.name, required this.department});
}

class GetPersonalizedFeed {
  final FeedRepository repository;
  final LocationService locationService;
  final UserPreferencesService preferences;

  GetPersonalizedFeed(this.repository, this.locationService, this.preferences);

  Stream<List<FeedPost>> call(FeedQuery query) async* {
    final userLocation = await locationService.getCurrentLocation();
    final userCommune = await locationService.getCommuneFromCoords(userLocation);
    
    // 1. Récupération parallèle de plusieurs sources
    final streams = [
      // A. Proximité immédiate (commune actuelle)
      _getNearbyPosts(userCommune, radiusKm: 5),
      
      // B. Découvertes culturelles ( tout le Bénin, score élevé)
      _getCulturalHighlights(limit: 5),
      
      // C. Posts des comptes suivis
      _getFollowingPosts(),
      
      // D. Trending par région proche
      _getRegionalTrending(userCommune.department),
    ];

    // 2. Fusion intelligente (pas juste concaténation)
    // Écouter tous les streams et fusionner les résultats
    await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
      final lists = await Future.wait(streams.map((s) => s.first).toList());
      yield _mergeAndRank(lists, userLocation, userCommune);
    }
  }
  
  Stream<List<FeedPost>> _getNearbyPosts(Commune commune, {required int radiusKm}) {
    return repository.getNearbyPosts(commune.name, radiusKm: radiusKm);
  }
  
  Stream<List<FeedPost>> _getCulturalHighlights({required int limit}) {
    return repository.getCulturalHighlights(limit: limit);
  }
  
  Stream<List<FeedPost>> _getFollowingPosts() {
    return repository.getFollowingPosts();
  }
  
  Stream<List<FeedPost>> _getRegionalTrending(String department) {
    return repository.getRegionalTrending(department);
  }

  List<FeedPost> _mergeAndRank(
    List<List<FeedPost>> sources,
    GeoPoint userLocation,
    Commune userCommune,
  ) {
    final allPosts = sources.expand((l) => l).toList();
    
    // Déduplication
    final uniquePosts = {for (var p in allPosts) p.id: p}.values.toList();
    
    // Scoring personnalisé
    final scored = uniquePosts.map((post) {
      double score = 0;
      
      // A. Proximité (40%)
      if (post.context.commune == userCommune.name) {
        score += 0.4;
      } else if (post.context.department == userCommune.department) {
        score += 0.2;
      }
      
      // B. Fraîcheur (20%)
      final age = DateTime.now().difference(post.createdAt);
      if (age.inHours < 24) {
        score += 0.2;
      } else if (age.inDays < 3) {
        score += 0.1;
      }
      
      // C. Valeur culturelle (20%)
      if (post.badges.contains('cultural_heritage')) score += 0.2;
      if (post.author.badges.contains('community_verified')) score += 0.1;
      
      // D. Engagement qualité (20%)
      final engagementRate = post.engagement.likes / max(post.engagement.views, 1);
      score += (engagementRate * 0.2).clamp(0, 0.2);
      
      // Pénalité: trop vu = moins pertinent
      if (post.engagement.isLikedByMe) score *= 0.8;
      
      return ScoredPost(post, score);
    }).toList();
    
    // Tri par score décroissant
    scored.sort((a, b) => b.score.compareTo(a.score));
    
    // Diversification: pas plus de 2 posts du même auteur consécutifs
    return _diversify(scored.map((s) => s.post).toList());
  }

  List<FeedPost> _diversify(List<FeedPost> posts) {
    final result = <FeedPost>[];
    final lastAuthors = <String>[];
    
    for (final post in posts) {
      if (lastAuthors.contains(post.authorId) && 
          lastAuthors.where((a) => a == post.authorId).length >= 2) {
        // Reporter ce post plus loin
        continue;
      }
      
      result.add(post);
      lastAuthors.add(post.authorId);
      if (lastAuthors.length > 5) lastAuthors.removeAt(0);
    }
    
    return result;
  }
}

class ScoredPost {
  final FeedPost post;
  final double score;
  ScoredPost(this.post, this.score);
}
