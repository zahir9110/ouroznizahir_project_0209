# 🚀 Guide d'Intégration Backend RBAC - Bōken

## 📋 Vue d'ensemble

Ce guide explique comment intégrer la nouvelle architecture backend RBAC dans votre application Flutter existante.

---

## ✅ Checklist d'Implémentation

### 1️⃣ Déploiement des Règles Firestore

```bash
# Déployer les nouvelles règles de sécurité
firebase deploy --only firestore:rules

# Vérifier le déploiement
firebase firestore:rules get
```

### 2️⃣ Configuration DI (Dependency Injection)

Créer ou modifier `lib/core/di/service_locator.dart`:

```dart
import 'package:get_it/get_it.dart';
import 'package:benin_experience/core/services/auth_service.dart';
import 'package:benin_experience/core/utils/permission_guard.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Services
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => PermissionGuard(sl<AuthService>()));
  
  // Autres services...
}
```

Appeler dans `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  // Configurer le DI
  await setupServiceLocator();
  
  runApp(const MyApp());
}
```

---

## 🔐 Patterns d'Utilisation

### Pattern 1: Vérifier les Permissions Avant une Action

```dart
import 'package:benin_experience/core/utils/permission_guard.dart';
import 'package:benin_experience/core/constants/auth_constants.dart';
import 'package:benin_experience/core/di/service_locator.dart';

class PlaceDetailPage extends StatelessWidget {
  final PermissionGuard _guard = sl<PermissionGuard>();
  
  Future<void> _likePlace() async {
    // ✅ Vérifier que l'utilisateur peut liker
    final canLike = await _guard.requireUserRole(
      onUnauthorized: () {
        _showAuthDialog(AuthMessages.requireAuthToLike);
      },
    );
    
    if (!canLike) return;
    
    // Continuer avec le like
    await _placeService.likePlace(placeId);
  }
  
  void _showAuthDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inscription requise'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }
}
```

---

### Pattern 2: Affichage Conditionnel des Boutons

```dart
import 'package:benin_experience/core/services/auth_service.dart';
import 'package:benin_experience/core/di/service_locator.dart';

class PlaceDetailPage extends StatelessWidget {
  final AuthService _authService = sl<AuthService>();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserRole>(
      stream: _authService.roleStream,
      builder: (context, snapshot) {
        final role = snapshot.data ?? UserRole.guest;
        
        return Column(
          children: [
            // ✅ Bouton visible seulement pour les utilisateurs inscrits
            if (role.canInteract)
              ElevatedButton(
                onPressed: _likePlace,
                child: const Text('❤️ J\'aime'),
              ),
            
            // ✅ Bouton visible seulement pour les guests
            if (role.isGuest)
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('S\'inscrire pour interagir'),
              ),
            
            // ✅ Bouton visible seulement pour les organisateurs
            if (role.canPublishOffers)
              ElevatedButton(
                onPressed: _createOffer,
                child: const Text('Créer une offre'),
              ),
          ],
        );
      },
    );
  }
}
```

---

### Pattern 3: Guard dans Navigation

```dart
import 'package:go_router/go_router.dart';
import 'package:benin_experience/core/utils/permission_guard.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/messages',
      redirect: (context, state) async {
        final guard = sl<PermissionGuard>();
        final canAccess = await guard.requireUserRole();
        return canAccess ? null : '/login';
      },
      builder: (context, state) => const MessagesPage(),
    ),
    
    GoRoute(
      path: '/dashboard',
      redirect: (context, state) async {
        final guard = sl<PermissionGuard>();
        final canAccess = await guard.requireOrganizerRole();
        return canAccess ? null : '/upgrade-to-organizer';
      },
      builder: (context, state) => const OrganizerDashboard(),
    ),
  ],
);
```

---

### Pattern 4: Contrainte d'Unicité (Rating)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:benin_experience/core/constants/auth_constants.dart';

class RatingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<void> ratePlace(String placeId, int score) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    
    // Vérifier si un rating existe déjà
    final existingRating = await _firestore
        .collection(FirestoreCollections.ratings)
        .where(FirestoreFields.placeId, isEqualTo: placeId)
        .where(FirestoreFields.userId, isEqualTo: userId)
        .limit(1)
        .get();
    
    if (existingRating.docs.isNotEmpty) {
      // UPDATE le rating existant
      await existingRating.docs.first.reference.update({
        'score': score,
        FirestoreFields.updatedAt: FieldValue.serverTimestamp(),
      });
    } else {
      // CREATE un nouveau rating
      await _firestore.collection(FirestoreCollections.ratings).add({
        FirestoreFields.placeId: placeId,
        FirestoreFields.userId: userId,
        'score': score,
        FirestoreFields.createdAt: FieldValue.serverTimestamp(),
      });
    }
  }
}
```

---

### Pattern 5: Lecture Publique (Guest)

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:benin_experience/core/constants/auth_constants.dart';

class PlaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// ✅ Cette méthode fonctionne même pour les GUESTS (non authentifiés)
  /// car les règles Firestore autorisent la lecture publique des places publiées
  Stream<List<Place>> getPublishedPlaces() {
    return _firestore
        .collection(FirestoreCollections.places)
        .where(FirestoreFields.isPublished, isEqualTo: true)
        .orderBy(FirestoreFields.createdAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Place.fromFirestore(doc))
            .toList());
  }
  
  /// ✅ Cette méthode fonctionne également pour les GUESTS
  Stream<List<Review>> getPlaceReviews(String placeId) {
    return _firestore
        .collection(FirestoreCollections.reviews)
        .where(FirestoreFields.placeId, isEqualTo: placeId)
        .orderBy(FirestoreFields.createdAt, descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Review.fromFirestore(doc))
            .toList());
  }
}
```

---

## 📱 Exemples d'UI avec Permissions

### Bouton "J'aime" avec Guard

```dart
class LikeButton extends StatefulWidget {
  final String targetId;
  final String targetType;
  
  const LikeButton({
    required this.targetId,
    required this.targetType,
  });
  
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  final PermissionGuard _guard = sl<PermissionGuard>();
  final AuthService _authService = sl<AuthService>();
  bool _isLiked = false;
  int _likeCount = 0;
  
  @override
  void initState() {
    super.initState();
    _checkIfLiked();
    _loadLikeCount();
  }
  
  Future<void> _toggleLike() async {
    // ✅ Vérifier les permissions
    final canLike = await _guard.canLike();
    if (!canLike) {
      _showAuthDialog();
      return;
    }
    
    setState(() => _isLiked = !_isLiked);
    
    if (_isLiked) {
      await _likeService.like(widget.targetId, widget.targetType);
    } else {
      await _likeService.unlike(widget.targetId, widget.targetType);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
      color: _isLiked ? Colors.red : Colors.grey,
      onPressed: _toggleLike,
    );
  }
  
  void _showAuthDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Inscription requise'),
        content: const Text(AuthMessages.requireAuthToLike),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/signup');
            },
            child: const Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }
  
  Future<void> _checkIfLiked() async {
    // Implémentation...
  }
  
  Future<void> _loadLikeCount() async {
    // Implémentation...
  }
}
```

---

### Formulaire d'Avis avec Validation

```dart
class ReviewForm extends StatefulWidget {
  final String placeId;
  
  const ReviewForm({required this.placeId});
  
  @override
  State<ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final PermissionGuard _guard = sl<PermissionGuard>();
  int _rating = 0;
  
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }
  
  Future<void> _checkPermissions() async {
    final canReview = await _guard.canReview();
    if (!canReview) {
      Navigator.pop(context);
      // Afficher dialog d'inscription
    }
  }
  
  Future<void> _submitReview() async {
    if (!_formKey.currentState!.validate()) return;
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez donner une note')),
      );
      return;
    }
    
    // ✅ Double vérification des permissions (sécurité)
    final canReview = await _guard.requireUserRole();
    if (!canReview) return;
    
    try {
      await _reviewService.createReview(
        placeId: widget.placeId,
        content: _contentController.text,
        rating: _rating,
      );
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avis publié avec succès')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Sélecteur d'étoiles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _rating = index + 1),
              );
            }),
          ),
          
          // Champ de texte
          TextFormField(
            controller: _contentController,
            maxLength: Limits.maxReviewLength,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Votre avis',
              hintText: 'Partagez votre expérience...',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un avis';
              }
              if (value.length < Limits.minReviewLength) {
                return 'L\'avis doit contenir au moins ${Limits.minReviewLength} caractères';
              }
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          // Bouton de soumission
          ElevatedButton(
            onPressed: _submitReview,
            child: const Text('Publier l\'avis'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🧪 Tests

### Test des Permissions

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:benin_experience/core/services/auth_service.dart';

void main() {
  group('UserRole Tests', () {
    test('Guest ne peut pas interagir', () {
      final role = UserRole.guest;
      expect(role.canInteract, false);
      expect(role.canLike, false);
      expect(role.canComment, false);
      expect(role.canRate, false);
    });
    
    test('User peut interagir', () {
      final role = UserRole.user;
      expect(role.canInteract, true);
      expect(role.canLike, true);
      expect(role.canComment, true);
      expect(role.canRate, true);
      expect(role.canPublishOffers, false);
    });
    
    test('Organizer peut tout faire', () {
      final role = UserRole.organizer;
      expect(role.canInteract, true);
      expect(role.canLike, true);
      expect(role.canPublishOffers, true);
      expect(role.canAccessDashboard, true);
    });
  });
}
```

### Test des Règles Firestore (via Firebase Emulator)

```bash
# Démarrer l'émulateur
firebase emulators:start --only firestore

# Dans un autre terminal, lancer les tests
flutter test integration_test/firestore_rules_test.dart
```

---

## 🚨 Points d'Attention

### 1. Sécurité Double-Couche

```dart
// ❌ NE PAS FAIRE - Se fier uniquement au client
Future<void> badLikePlace() async {
  // Pas de vérification côté client
  await _firestore.collection('likes').add({...});
  // ⚠️ Sera rejeté par Firestore Rules si l'utilisateur est guest
}

// ✅ FAIRE - Vérifier côté client ET laisser Firestore valider
Future<void> goodLikePlace() async {
  // Vérification côté client (UX)
  final canLike = await _guard.canLike();
  if (!canLike) {
    _showAuthDialog();
    return;
  }
  
  // Firestore Rules valide aussi côté serveur (sécurité)
  await _firestore.collection('likes').add({...});
}
```

### 2. Contraintes d'Unicité

```dart
// ✅ Toujours vérifier avant de créer un rating/like/favorite
final existing = await _firestore
    .collection('ratings')
    .where('placeId', isEqualTo: placeId)
    .where('userId', isEqualTo: userId)
    .limit(1)
    .get();

if (existing.docs.isNotEmpty) {
  // UPDATE
} else {
  // CREATE
}
```

### 3. Dénormalisation

```dart
// ✅ Toujours inclure les données dénormalisées
await _firestore.collection('reviews').add({
  'placeId': placeId,
  'userId': userId,
  'userName': user.displayName,  // ✅ Dénormalisé
  'userPhoto': user.photoURL,    // ✅ Dénormalisé
  'content': content,
  // ...
});
```

---

## 📚 Ressources Supplémentaires

- [BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md) - Architecture complète
- [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md) - Schéma des collections
- [firestore.rules](./firestore.rules) - Règles de sécurité

---

## 🎯 Prochaines Étapes

1. ✅ Déployer les règles Firestore
2. ✅ Configurer le DI
3. ✅ Implémenter les guards dans l'UI
4. ⏳ Créer les Cloud Functions pour les compteurs
5. ⏳ Ajouter les indexes Firestore composites
6. ⏳ Tester avec Firebase Emulator
7. ⏳ Implémenter les flows d'inscription (User vs Organizer)
8. ⏳ Créer les dialogs d'authentification
9. ⏳ Ajouter le monitoring des permissions
10. ⏳ Documentation utilisateur finale
