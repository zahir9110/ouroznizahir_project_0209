# 🔐 BŌKEN - Architecture Backend RBAC (Firebase/Firestore)

## 🌍 VISION PRODUIT

Bōken est un **guide d'aventure ouvert à tous** :

### 🔓 Exploration Libre (GUEST - sans inscription)
- ✅ Carte touristique détaillée
- ✅ Consultation des lieux (musées, spots dating, activités, hébergements)
- ✅ Lecture des notes globales et avis existants
- ❌ **Pas d'interactions sociales**

### 🎒 Dimension Sociale (USER - inscrit)
- ✅ Toutes les permissions Guest
- ✅ Messagerie
- ✅ Likes, commentaires, partages
- ✅ Notation des lieux
- ✅ Publication d'avis
- ✅ Sauvegarde de lieux favoris

### 🏢 Dimension PRO (ORGANIZER)
- ✅ Toutes les permissions User
- ✅ Publication d'offres / expériences
- ✅ Dashboard avec statistiques
- ✅ Gestion des réservations

---

## 👥 TYPES D'UTILISATEURS

### 1️⃣ GUEST (non authentifié)
```dart
// Pas d'entrée dans Firestore
// Accès lecture seule aux données publiques
role: null
authenticated: false
```

**Permissions:**
- ✅ `GET /places`
- ✅ `GET /map/markers`
- ✅ `GET /places/:id/reviews`
- ✅ `GET /places/:id/ratings`
- ❌ Toute opération d'écriture
- ❌ Toute interaction sociale

---

### 2️⃣ USER (inscrit standard)
```dart
role: 'user'
authenticated: true
```

**Permissions:**
- ✅ Toutes les permissions GUEST
- ✅ POST message
- ✅ POST like / comment / share
- ✅ POST rating / review
- ✅ POST favorite (sauvegarde lieux)

---

### 3️⃣ ORGANIZER (professionnel)
```dart
role: 'organizer'
authenticated: true
```

**Permissions:**
- ✅ Toutes les permissions USER
- ✅ POST offers
- ✅ GET dashboard stats
- ✅ GET bookings
- ✅ POST offer updates

---

## 🗄️ STRUCTURE FIRESTORE

### Collection: `users`
```typescript
{
  uid: string,                    // Firebase Auth UID
  email: string,
  displayName: string,
  photoURL?: string,
  role: 'user' | 'organizer',     // GUEST n'est pas stocké
  bio?: string,
  phone?: string,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `uid` (automatic)
- `email`
- `role`

---

### Collection: `places`
```typescript
{
  id: string,
  name: string,
  type: 'museum' | 'dating' | 'activity' | 'lodging' | 'restaurant' | 'attraction',
  location: {
    lat: number,
    lng: number,
    address: string,
    city: string,
    region: string
  },
  description: string,
  images: string[],
  tags: string[],
  averageRating: number,          // Calculé
  ratingCount: number,            // Calculé
  isPublished: boolean,
  organizerId?: string,           // Si créé par un organizer
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `type`
- `location` (geohash)
- `isPublished`
- `organizerId`

---

### Collection: `ratings`
```typescript
{
  id: string,
  placeId: string,
  userId: string,
  score: number,                  // 1-5
  createdAt: Timestamp
}
```

**Règle métier:** 1 rating par user/place (composite unique)

**Indexes:**
- `placeId + userId` (composite unique)
- `placeId`
- `userId`

---

### Collection: `reviews`
```typescript
{
  id: string,
  placeId: string,
  userId: string,
  userName: string,               // Dénormalisé pour perf
  userPhoto?: string,             // Dénormalisé
  content: string,
  rating: number,                 // Snapshot du rating
  images?: string[],
  likes: number,                  // Compteur dénormalisé
  commentsCount: number,          // Compteur dénormalisé
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `placeId + createdAt`
- `userId`

---

### Collection: `messages`
```typescript
{
  id: string,
  senderId: string,
  receiverId: string,
  content: string,
  type: 'text' | 'image' | 'location',
  isRead: boolean,
  createdAt: Timestamp
}
```

**Indexes:**
- `senderId + receiverId + createdAt` (composite)
- `receiverId + isRead`

---

### Collection: `likes`
```typescript
{
  id: string,
  userId: string,
  targetType: 'review' | 'comment' | 'post',
  targetId: string,
  createdAt: Timestamp
}
```

**Règle métier:** 1 like par user/target (composite unique)

**Indexes:**
- `userId + targetType + targetId` (composite unique)
- `targetType + targetId`

---

### Collection: `comments`
```typescript
{
  id: string,
  userId: string,
  userName: string,               // Dénormalisé
  userPhoto?: string,             // Dénormalisé
  targetType: 'review' | 'post',
  targetId: string,
  content: string,
  createdAt: Timestamp
}
```

**Indexes:**
- `targetType + targetId + createdAt`
- `userId`

---

### Collection: `shares`
```typescript
{
  id: string,
  userId: string,
  targetType: 'place' | 'review' | 'post',
  targetId: string,
  createdAt: Timestamp
}
```

**Indexes:**
- `userId + createdAt`
- `targetType + targetId`

---

### Collection: `favorites`
```typescript
{
  id: string,
  userId: string,
  placeId: string,
  createdAt: Timestamp
}
```

**Règle métier:** 1 favorite par user/place (composite unique)

**Indexes:**
- `userId + placeId` (composite unique)
- `userId + createdAt`

---

### Collection: `offers` (ORGANIZER uniquement)
```typescript
{
  id: string,
  organizerId: string,
  organizerName: string,          // Dénormalisé
  title: string,
  description: string,
  type: 'experience' | 'tour' | 'activity' | 'accommodation',
  price: number,
  currency: string,
  capacity: number,
  location: {
    lat: number,
    lng: number,
    address: string
  },
  images: string[],
  schedule: {
    startDate: Timestamp,
    endDate: Timestamp,
    duration: string              // "2h", "1 jour", etc.
  },
  tags: string[],
  isPublished: boolean,
  bookingsCount: number,          // Compteur dénormalisé
  averageRating: number,          // Calculé
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `organizerId`
- `type + isPublished`
- `isPublished + createdAt`

---

### Collection: `bookings` (ORGANIZER)
```typescript
{
  id: string,
  offerId: string,
  userId: string,
  organizerId: string,
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed',
  participants: number,
  totalAmount: number,
  paymentStatus: 'pending' | 'paid' | 'refunded',
  paymentId?: string,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `offerId`
- `userId + createdAt`
- `organizerId + status`

---

## 🔐 RÈGLES D'AUTORISATION FIRESTORE

### Fonctions Helper
```javascript
// firestore.rules

function isAuthenticated() {
  return request.auth != null;
}

function isUser() {
  return isAuthenticated() && 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'user';
}

function isOrganizer() {
  return isAuthenticated() && 
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'organizer';
}

function isUserOrOrganizer() {
  return isUser() || isOrganizer();
}

function isOwner(userId) {
  return isAuthenticated() && request.auth.uid == userId;
}
```

---

### Collection: `users`
```javascript
match /users/{userId} {
  // Tout le monde peut lire les profils publics (pour afficher auteurs d'avis, etc.)
  allow read: if true;
  
  // Seul l'utilisateur peut créer/modifier son propre profil
  allow create: if isAuthenticated() && request.auth.uid == userId;
  allow update: if isOwner(userId);
  
  // Pas de suppression directe (soft delete via Cloud Functions)
  allow delete: if false;
}
```

---

### Collection: `places`
```javascript
match /places/{placeId} {
  // ✅ GUEST: Lecture libre des lieux publiés
  allow read: if resource.data.isPublished == true;
  
  // ✅ ORGANIZER: Peut lire ses propres lieux non publiés
  allow read: if isOrganizer() && resource.data.organizerId == request.auth.uid;
  
  // ✅ ORGANIZER: Peut créer des lieux
  allow create: if isOrganizer();
  
  // ✅ ORGANIZER: Peut modifier ses propres lieux
  allow update: if isOrganizer() && resource.data.organizerId == request.auth.uid;
  
  // ❌ Pas de suppression directe
  allow delete: if false;
}
```

---

### Collection: `ratings`
```javascript
match /ratings/{ratingId} {
  // ✅ GUEST: Lecture libre des notes
  allow read: if true;
  
  // ✅ USER/ORGANIZER: Peut noter un lieu
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid &&
                   request.resource.data.score >= 1 && 
                   request.resource.data.score <= 5;
  
  // ✅ USER/ORGANIZER: Peut modifier sa propre note
  allow update: if isOwner(resource.data.userId);
  
  // ✅ USER/ORGANIZER: Peut supprimer sa propre note
  allow delete: if isOwner(resource.data.userId);
}
```

---

### Collection: `reviews`
```javascript
match /reviews/{reviewId} {
  // ✅ GUEST: Lecture libre des avis
  allow read: if true;
  
  // ✅ USER/ORGANIZER: Peut publier un avis
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut modifier son propre avis
  allow update: if isOwner(resource.data.userId);
  
  // ✅ USER/ORGANIZER: Peut supprimer son propre avis
  allow delete: if isOwner(resource.data.userId);
}
```

---

### Collection: `messages`
```javascript
match /messages/{messageId} {
  // ✅ USER/ORGANIZER: Peut lire les messages où il est sender OU receiver
  allow read: if isUserOrOrganizer() && 
                 (resource.data.senderId == request.auth.uid || 
                  resource.data.receiverId == request.auth.uid);
  
  // ✅ USER/ORGANIZER: Peut envoyer un message
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.senderId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut marquer comme lu (si receiver)
  allow update: if isOwner(resource.data.receiverId) && 
                   request.resource.data.diff(resource.data).affectedKeys().hasOnly(['isRead']);
  
  // ❌ Pas de suppression directe
  allow delete: if false;
}
```

---

### Collection: `likes`
```javascript
match /likes/{likeId} {
  // ✅ Lecture libre (pour compter les likes)
  allow read: if true;
  
  // ✅ USER/ORGANIZER: Peut liker
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut supprimer son propre like
  allow delete: if isOwner(resource.data.userId);
  
  // ❌ Pas de modification
  allow update: if false;
}
```

---

### Collection: `comments`
```javascript
match /comments/{commentId} {
  // ✅ Lecture libre
  allow read: if true;
  
  // ✅ USER/ORGANIZER: Peut commenter
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut modifier son propre commentaire
  allow update: if isOwner(resource.data.userId);
  
  // ✅ USER/ORGANIZER: Peut supprimer son propre commentaire
  allow delete: if isOwner(resource.data.userId);
}
```

---

### Collection: `shares`
```javascript
match /shares/{shareId} {
  // ✅ Lecture libre (pour compter les partages)
  allow read: if true;
  
  // ✅ USER/ORGANIZER: Peut partager
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut supprimer son propre partage
  allow delete: if isOwner(resource.data.userId);
  
  // ❌ Pas de modification
  allow update: if false;
}
```

---

### Collection: `favorites`
```javascript
match /favorites/{favoriteId} {
  // ✅ USER/ORGANIZER: Peut lire ses propres favoris
  allow read: if isOwner(resource.data.userId);
  
  // ✅ USER/ORGANIZER: Peut sauvegarder un lieu
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut supprimer un favori
  allow delete: if isOwner(resource.data.userId);
  
  // ❌ Pas de modification
  allow update: if false;
}
```

---

### Collection: `offers`
```javascript
match /offers/{offerId} {
  // ✅ GUEST: Lecture libre des offres publiées
  allow read: if resource.data.isPublished == true;
  
  // ✅ ORGANIZER: Peut lire ses propres offres non publiées
  allow read: if isOrganizer() && resource.data.organizerId == request.auth.uid;
  
  // ✅ ORGANIZER: Peut créer une offre
  allow create: if isOrganizer() && 
                   request.resource.data.organizerId == request.auth.uid;
  
  // ✅ ORGANIZER: Peut modifier ses propres offres
  allow update: if isOrganizer() && resource.data.organizerId == request.auth.uid;
  
  // ✅ ORGANIZER: Peut supprimer ses propres offres
  allow delete: if isOrganizer() && resource.data.organizerId == request.auth.uid;
}
```

---

### Collection: `bookings`
```javascript
match /bookings/{bookingId} {
  // ✅ USER/ORGANIZER: Peut lire ses propres réservations (en tant que user)
  allow read: if isUserOrOrganizer() && resource.data.userId == request.auth.uid;
  
  // ✅ ORGANIZER: Peut lire les réservations de ses offres
  allow read: if isOrganizer() && resource.data.organizerId == request.auth.uid;
  
  // ✅ USER/ORGANIZER: Peut créer une réservation
  allow create: if isUserOrOrganizer() && 
                   request.resource.data.userId == request.auth.uid;
  
  // ✅ ORGANIZER: Peut modifier le statut des réservations de ses offres
  allow update: if isOrganizer() && 
                   resource.data.organizerId == request.auth.uid &&
                   request.resource.data.diff(resource.data).affectedKeys().hasOnly(['status', 'updatedAt']);
  
  // ❌ Pas de suppression directe
  allow delete: if false;
}
```

---

## 📊 TABLEAU RÉCAPITULATIF DES PERMISSIONS

| Collection   | GUEST Read | GUEST Write | USER Read | USER Write | ORGANIZER Read | ORGANIZER Write |
|-------------|-----------|-------------|-----------|-----------|----------------|-----------------|
| `users`     | ✅         | ❌          | ✅         | ✅ (own)   | ✅             | ✅ (own)        |
| `places`    | ✅         | ❌          | ✅         | ❌         | ✅             | ✅ (own)        |
| `ratings`   | ✅         | ❌          | ✅         | ✅         | ✅             | ✅              |
| `reviews`   | ✅         | ❌          | ✅         | ✅         | ✅             | ✅              |
| `messages`  | ❌         | ❌          | ✅ (own)   | ✅         | ✅ (own)       | ✅              |
| `likes`     | ✅         | ❌          | ✅         | ✅         | ✅             | ✅              |
| `comments`  | ✅         | ❌          | ✅         | ✅         | ✅             | ✅              |
| `shares`    | ✅         | ❌          | ✅         | ✅         | ✅             | ✅              |
| `favorites` | ❌         | ❌          | ✅ (own)   | ✅         | ✅ (own)       | ✅              |
| `offers`    | ✅         | ❌          | ✅         | ❌         | ✅             | ✅ (own)        |
| `bookings`  | ❌         | ❌          | ✅ (own)   | ✅         | ✅ (related)   | ✅ (related)    |

---

## 🔧 IMPLÉMENTATION FLUTTER

### 1️⃣ User Role Enum
```dart
// lib/core/models/user_role.dart
enum UserRole {
  guest,
  user,
  organizer;

  bool get isGuest => this == UserRole.guest;
  bool get isUser => this == UserRole.user;
  bool get isOrganizer => this == UserRole.organizer;
  
  bool get canInteract => this != UserRole.guest;
  bool get canPublishOffers => this == UserRole.organizer;
  
  static UserRole fromString(String? role) {
    if (role == null) return UserRole.guest;
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.guest,
    );
  }
}
```

---

### 2️⃣ Auth Service
```dart
// lib/core/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  // Current user
  User? get currentUser => _auth.currentUser;
  
  // Get user role
  Future<UserRole> getUserRole() async {
    final user = currentUser;
    if (user == null) return UserRole.guest;
    
    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return UserRole.guest;
    
    return UserRole.fromString(doc.data()?['role']);
  }
  
  // Check if user can interact (not guest)
  Future<bool> canInteract() async {
    final role = await getUserRole();
    return role.canInteract;
  }
  
  // Check if user can publish offers
  Future<bool> canPublishOffers() async {
    final role = await getUserRole();
    return role.canPublishOffers;
  }
  
  // Sign in with email
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  
  // Register with email
  Future<UserCredential> registerWithEmail(
    String email,
    String password,
    String displayName,
    UserRole role,
  ) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Create user document in Firestore
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    return credential;
  }
  
  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
```

---

### 3️⃣ Permission Guard
```dart
// lib/core/utils/permission_guard.dart
import 'package:benin_experience/core/services/auth_service.dart';

class PermissionGuard {
  final AuthService _authService;
  
  PermissionGuard(this._authService);
  
  // Require authentication
  Future<bool> requireAuth({String? message}) async {
    if (_authService.currentUser == null) {
      // Show login dialog
      if (message != null) {
        // TODO: Show dialog with message
      }
      return false;
    }
    return true;
  }
  
  // Require user role (not guest)
  Future<bool> requireUserRole({String? message}) async {
    if (!await requireAuth(message: message)) return false;
    
    final canInteract = await _authService.canInteract();
    if (!canInteract) {
      // Show "inscription requise" dialog
      if (message != null) {
        // TODO: Show dialog
      }
      return false;
    }
    return true;
  }
  
  // Require organizer role
  Future<bool> requireOrganizerRole({String? message}) async {
    if (!await requireAuth(message: message)) return false;
    
    final canPublish = await _authService.canPublishOffers();
    if (!canPublish) {
      // Show "compte organisateur requis" dialog
      if (message != null) {
        // TODO: Show dialog
      }
      return false;
    }
    return true;
  }
}
```

---

### 4️⃣ Usage Example
```dart
// Dans un widget
class PlaceDetailPage extends StatelessWidget {
  final PermissionGuard _permissionGuard = sl<PermissionGuard>();
  
  Future<void> _submitReview() async {
    // ✅ Vérifier que l'utilisateur peut interagir
    if (!await _permissionGuard.requireUserRole(
      message: 'Inscrivez-vous pour publier un avis',
    )) {
      return;
    }
    
    // Continuer avec la soumission de l'avis
    // ...
  }
  
  Future<void> _likePlace() async {
    // ✅ Vérifier que l'utilisateur peut interagir
    if (!await _permissionGuard.requireUserRole(
      message: 'Inscrivez-vous pour liker',
    )) {
      return;
    }
    
    // Continuer avec le like
    // ...
  }
}
```

---

## 🚀 SCALABILITÉ & PERFORMANCE

### Indexes Firestore Requis
```bash
# Créer via Firebase Console ou CLI
firebase firestore:indexes:create

# Indexes composites:
# - ratings: placeId + userId (unique)
# - reviews: placeId + createdAt
# - messages: senderId + receiverId + createdAt
# - likes: userId + targetType + targetId (unique)
# - favorites: userId + placeId (unique)
# - offers: type + isPublished
```

### Compteurs Dénormalisés (Cloud Functions)
```typescript
// Mettre à jour les compteurs après chaque action
// Exemples:
// - places.ratingCount, places.averageRating
// - reviews.likes, reviews.commentsCount
// - offers.bookingsCount
```

### Cache Strategy
- Client-side cache via `SharedPreferences` pour données statiques
- Firestore persistence activée
- Cache des listes avec TTL (Time To Live)

---

## ✅ CHECKLIST IMPLÉMENTATION

- [ ] Créer enum `UserRole`
- [ ] Implémenter `AuthService`
- [ ] Implémenter `PermissionGuard`
- [ ] Déployer règles Firestore sécurisées
- [ ] Créer indexes Firestore
- [ ] Implémenter Cloud Functions pour compteurs
- [ ] Tester permissions côté client
- [ ] Tester règles Firestore (Firebase Emulator)
- [ ] Documenter flows d'inscription (User vs Organizer)
- [ ] Ajouter dialogs d'auth dans UI

---

## 📝 NOTES IMPORTANTES

1. **Guest = Non Authentifié**
   - Pas de document dans Firestore
   - Détection côté client: `FirebaseAuth.currentUser == null`

2. **Upgrade User → Organizer**
   - Simple update du champ `role` dans le document `users`
   - Peut nécessiter un process de vérification (KYC)

3. **Sécurité**
   - Toutes les règles sont vérifiées côté serveur (Firestore Rules)
   - Les guards côté client sont pour UX uniquement (pas de sécurité réelle)
   - Toujours valider côté backend/Firestore

4. **Monitoring**
   - Firebase Analytics pour tracking des actions
   - Monitoring des échecs de permissions (logs Firestore)
   - Alertes sur tentatives d'accès non autorisées
