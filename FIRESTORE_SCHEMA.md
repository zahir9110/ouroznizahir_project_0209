# 🗄️ Bōken - Schéma Collections Firestore

## Vue d'ensemble

Ce document décrit la structure détaillée de toutes les collections Firestore pour l'application Bōken, avec les règles de validation et les indexes requis.

---

## 📋 Collections Principales

### 1. `users`

**Description:** Profils utilisateurs (USER et ORGANIZER uniquement, pas GUEST)

**Structure:**
```typescript
{
  uid: string,                    // Firebase Auth UID (document ID)
  email: string,
  displayName: string,
  photoURL?: string,
  role: 'user' | 'organizer',     // GUEST n'est pas stocké
  bio?: string,
  phone?: string,
  location?: {
    city?: string,
    country?: string,
    coordinates?: GeoPoint
  },
  preferences?: {
    language: string,             // 'fr', 'en'
    notifications: boolean,
    newsletter: boolean
  },
  stats?: {
    reviewsCount: number,
    ratingsCount: number,
    favoritesCount: number,
    messagesCount: number
  },
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `email` (automatic unique)
- `role` (composite with createdAt for admin queries)

**Règles de validation:**
- `uid` doit correspondre au document ID
- `email` format valide
- `role` obligatoire parmi ['user', 'organizer']

---

### 2. `places`

**Description:** Lieux touristiques (musées, restaurants, activités, hébergements)

**Structure:**
```typescript
{
  id: string,                     // Auto-generated
  name: string,
  slug: string,                   // URL-friendly
  type: 'museum' | 'dating' | 'activity' | 'lodging' | 'restaurant' | 'attraction',
  category?: string,              // Sous-catégorie
  location: {
    lat: number,
    lng: number,
    address: string,
    city: string,
    region: string,
    country: string,
    postalCode?: string,
    geohash: string               // Pour queries géospatiales
  },
  description: string,
  shortDescription?: string,      // Pour les cartes
  images: string[],               // URLs Firebase Storage
  coverImage: string,             // URL principale
  
  contact?: {
    phone?: string,
    email?: string,
    website?: string,
    socialMedia?: {
      facebook?: string,
      instagram?: string,
      twitter?: string
    }
  },
  
  hours?: {
    monday?: string,
    tuesday?: string,
    wednesday?: string,
    thursday?: string,
    friday?: string,
    saturday?: string,
    sunday?: string
  },
  
  pricing?: {
    currency: string,             // 'XOF', 'EUR'
    range: 'free' | 'low' | 'medium' | 'high',
    details?: string
  },
  
  tags: string[],
  amenities?: string[],           // ['wifi', 'parking', 'accessible']
  
  // Stats dénormalisées
  averageRating: number,          // 0-5
  ratingCount: number,
  reviewsCount: number,
  favoritesCount: number,
  viewsCount: number,
  
  // Metadata
  isPublished: boolean,
  isFeatured: boolean,
  organizerId?: string,           // Si créé par un organizer
  verificationStatus: 'pending' | 'verified' | 'rejected',
  
  seo?: {
    metaTitle?: string,
    metaDescription?: string,
    keywords?: string[]
  },
  
  createdAt: Timestamp,
  updatedAt: Timestamp,
  publishedAt?: Timestamp
}
```

**Indexes:**
- `type + isPublished + createdAt` (composite)
- `location.geohash` (pour queries géospatiales)
- `organizerId + isPublished`
- `isFeatured + isPublished`
- `slug` (unique)

**Règles de validation:**
- `name` obligatoire (3-100 caractères)
- `location.lat` entre -90 et 90
- `location.lng` entre -180 et 180
- `averageRating` entre 0 et 5
- `type` parmi les valeurs autorisées

---

### 3. `ratings`

**Description:** Notes données aux lieux (1-5 étoiles)

**Structure:**
```typescript
{
  id: string,                     // Auto-generated
  placeId: string,
  placeName: string,              // Dénormalisé
  userId: string,
  userName: string,               // Dénormalisé
  score: number,                  // 1-5
  createdAt: Timestamp
}
```

**Règle métier:** 
- Un seul rating par user/place (contrainte applicative)
- Si l'utilisateur note à nouveau, on UPDATE le rating existant

**Indexes:**
- `placeId + userId` (composite unique) ⚠️ **IMPORTANT**
- `placeId + createdAt`
- `userId + createdAt`

**Règles de validation:**
- `score` entre 1 et 5 (entier)
- `placeId` et `userId` obligatoires

---

### 4. `reviews`

**Description:** Avis détaillés sur les lieux

**Structure:**
```typescript
{
  id: string,
  placeId: string,
  placeName: string,              // Dénormalisé
  userId: string,
  userName: string,               // Dénormalisé
  userPhoto?: string,             // Dénormalisé
  
  content: string,
  rating: number,                 // Snapshot du rating au moment de l'avis
  
  images?: string[],              // Photos de l'utilisateur
  
  // Stats dénormalisées
  likes: number,
  commentsCount: number,
  sharesCount: number,
  
  // Modération
  isPublished: boolean,
  moderationStatus: 'pending' | 'approved' | 'rejected',
  moderationNote?: string,
  
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

**Indexes:**
- `placeId + createdAt` (composite)
- `placeId + likes` (pour tri par popularité)
- `userId + createdAt`
- `isPublished + moderationStatus`

**Règles de validation:**
- `content` obligatoire (10-2000 caractères)
- `rating` entre 1 et 5
- Maximum 5 images par review

---

### 5. `messages`

**Description:** Messagerie privée entre utilisateurs

**Structure:**
```typescript
{
  id: string,
  senderId: string,
  senderName: string,             // Dénormalisé
  senderPhoto?: string,           // Dénormalisé
  receiverId: string,
  receiverName: string,           // Dénormalisé
  receiverPhoto?: string,         // Dénormalisé
  
  content: string,
  type: 'text' | 'image' | 'location' | 'offer',
  
  attachments?: {
    imageUrl?: string,
    location?: GeoPoint,
    offerId?: string
  },
  
  isRead: boolean,
  readAt?: Timestamp,
  
  // Soft delete
  deletedBySender: boolean,
  deletedByReceiver: boolean,
  
  createdAt: Timestamp
}
```

**Indexes:**
- `senderId + receiverId + createdAt` (composite)
- `receiverId + isRead + createdAt` (pour boîte de réception non lue)
- `senderId + createdAt`

**Règles de validation:**
- `content` obligatoire si type='text' (1-1000 caractères)
- `senderId != receiverId`

---

### 6. `likes`

**Description:** Likes sur reviews, comments, posts

**Structure:**
```typescript
{
  id: string,
  userId: string,
  targetType: 'review' | 'comment' | 'post',
  targetId: string,
  createdAt: Timestamp
}
```

**Règle métier:**
- Un seul like par user/target (contrainte applicative)

**Indexes:**
- `userId + targetType + targetId` (composite unique) ⚠️ **IMPORTANT**
- `targetType + targetId + createdAt`

---

### 7. `comments`

**Description:** Commentaires sur reviews ou posts

**Structure:**
```typescript
{
  id: string,
  userId: string,
  userName: string,               // Dénormalisé
  userPhoto?: string,             // Dénormalisé
  
  targetType: 'review' | 'post',
  targetId: string,
  
  content: string,
  
  // Stats dénormalisées
  likes: number,
  
  // Modération
  isPublished: boolean,
  moderationStatus: 'pending' | 'approved' | 'rejected',
  
  createdAt: Timestamp,
  updatedAt?: Timestamp
}
```

**Indexes:**
- `targetType + targetId + createdAt` (composite)
- `userId + createdAt`

**Règles de validation:**
- `content` obligatoire (1-500 caractères)

---

### 8. `shares`

**Description:** Partages de lieux, reviews, posts

**Structure:**
```typescript
{
  id: string,
  userId: string,
  targetType: 'place' | 'review' | 'post' | 'offer',
  targetId: string,
  platform?: 'facebook' | 'twitter' | 'whatsapp' | 'copy_link',
  createdAt: Timestamp
}
```

**Indexes:**
- `userId + createdAt`
- `targetType + targetId`

---

### 9. `favorites`

**Description:** Lieux sauvegardés par les utilisateurs

**Structure:**
```typescript
{
  id: string,
  userId: string,
  placeId: string,
  placeName: string,              // Dénormalisé
  placeImage?: string,            // Dénormalisé
  placeType: string,              // Dénormalisé
  
  // Organisation
  collection?: string,            // 'à visiter', 'favoris', etc.
  notes?: string,
  
  createdAt: Timestamp
}
```

**Règle métier:**
- Un seul favorite par user/place (contrainte applicative)

**Indexes:**
- `userId + placeId` (composite unique) ⚠️ **IMPORTANT**
- `userId + createdAt`
- `userId + collection`

---

### 10. `offers` (ORGANIZER uniquement)

**Description:** Offres / expériences proposées par les organisateurs

**Structure:**
```typescript
{
  id: string,
  organizerId: string,
  organizerName: string,          // Dénormalisé
  organizerPhoto?: string,        // Dénormalisé
  organizerBadge?: string,        // 'verified', 'premium'
  
  title: string,
  slug: string,
  description: string,
  shortDescription?: string,
  
  type: 'experience' | 'tour' | 'activity' | 'accommodation' | 'event',
  category?: string,
  
  pricing: {
    amount: number,
    currency: string,             // 'XOF', 'EUR'
    unit: 'person' | 'group' | 'night',
    discount?: {
      percentage: number,
      validUntil?: Timestamp
    }
  },
  
  capacity: {
    min: number,
    max: number
  },
  
  location: {
    lat: number,
    lng: number,
    address: string,
    city: string,
    region: string,
    geohash: string
  },
  
  images: string[],
  coverImage: string,
  
  schedule: {
    type: 'fixed' | 'flexible' | 'on_demand',
    startDate?: Timestamp,
    endDate?: Timestamp,
    duration: string,             // "2h", "1 jour", "3 nuits"
    availability?: string[]       // ['monday', 'wednesday']
  },
  
  included?: string[],            // Ce qui est inclus
  excluded?: string[],            // Ce qui n'est pas inclus
  requirements?: string[],        // Prérequis
  
  tags: string[],
  languages: string[],            // Langues supportées
  
  // Stats dénormalisées
  bookingsCount: number,
  averageRating: number,
  ratingCount: number,
  viewsCount: number,
  
  // Publication
  isPublished: boolean,
  isFeatured: boolean,
  verificationStatus: 'pending' | 'verified' | 'rejected',
  
  // Politique d'annulation
  cancellationPolicy?: {
    type: 'flexible' | 'moderate' | 'strict',
    details: string
  },
  
  createdAt: Timestamp,
  updatedAt: Timestamp,
  publishedAt?: Timestamp
}
```

**Indexes:**
- `organizerId + isPublished`
- `type + isPublished + createdAt`
- `isPublished + isFeatured`
- `location.geohash` (pour queries géospatiales)
- `slug` (unique)

**Règles de validation:**
- `title` obligatoire (3-100 caractères)
- `pricing.amount` >= 0
- `capacity.min` <= `capacity.max`

---

### 11. `bookings`

**Description:** Réservations d'offres

**Structure:**
```typescript
{
  id: string,
  offerId: string,
  offerTitle: string,             // Dénormalisé
  offerImage?: string,            // Dénormalisé
  
  userId: string,
  userName: string,               // Dénormalisé
  userEmail: string,              // Dénormalisé
  userPhone?: string,             // Dénormalisé
  
  organizerId: string,
  organizerName: string,          // Dénormalisé
  
  bookingDetails: {
    date?: Timestamp,
    participants: number,
    specialRequests?: string
  },
  
  pricing: {
    amount: number,
    currency: string,
    discount?: number,
    total: number
  },
  
  status: 'pending' | 'confirmed' | 'cancelled' | 'completed' | 'refunded',
  paymentStatus: 'pending' | 'paid' | 'refunded' | 'failed',
  paymentId?: string,
  
  // Communication
  messages?: {
    userId: string,
    message: string,
    createdAt: Timestamp
  }[],
  
  // Cancellation
  cancelledBy?: 'user' | 'organizer' | 'system',
  cancelledAt?: Timestamp,
  cancellationReason?: string,
  
  createdAt: Timestamp,
  updatedAt: Timestamp,
  confirmedAt?: Timestamp,
  completedAt?: Timestamp
}
```

**Indexes:**
- `offerId + createdAt`
- `userId + status + createdAt`
- `organizerId + status + createdAt`
- `status + paymentStatus`

**Règles de validation:**
- `participants` >= offer.capacity.min
- `participants` <= offer.capacity.max
- `pricing.total` calculé correctement

---

## 📊 Indexes Composites Requis

### Pour créer les indexes via Firebase CLI:

```bash
# ratings
firebase firestore:indexes --add collection=ratings field=placeId,userId

# reviews
firebase firestore:indexes --add collection=reviews field=placeId,createdAt
firebase firestore:indexes --add collection=reviews field=placeId,likes

# messages
firebase firestore:indexes --add collection=messages field=senderId,receiverId,createdAt
firebase firestore:indexes --add collection=messages field=receiverId,isRead,createdAt

# likes
firebase firestore:indexes --add collection=likes field=userId,targetType,targetId

# comments
firebase firestore:indexes --add collection=comments field=targetType,targetId,createdAt

# favorites
firebase firestore:indexes --add collection=favorites field=userId,placeId

# offers
firebase firestore:indexes --add collection=offers field=type,isPublished,createdAt

# bookings
firebase firestore:indexes --add collection=bookings field=organizerId,status,createdAt
```

---

## 🔄 Cloud Functions (Compteurs Dénormalisés)

### Triggers à implémenter:

1. **onRatingCreate/Update/Delete** → Recalculer `places.averageRating` et `places.ratingCount`
2. **onReviewCreate/Delete** → Incrémenter/décrémenter `places.reviewsCount`
3. **onLikeCreate/Delete** → Incrémenter/décrémenter `reviews.likes` ou `comments.likes`
4. **onCommentCreate/Delete** → Incrémenter/décrémenter `reviews.commentsCount`
5. **onFavoriteCreate/Delete** → Incrémenter/décrémenter `places.favoritesCount`
6. **onBookingCreate/Update** → Mettre à jour `offers.bookingsCount`
7. **onShareCreate** → Incrémenter `places.sharesCount` ou `reviews.sharesCount`

---

## 🔒 Contraintes Unicité (Application-level)

Ces contraintes doivent être gérées côté application car Firestore ne supporte pas les contraintes d'unicité natives:

1. **ratings**: `placeId + userId` unique
2. **likes**: `userId + targetType + targetId` unique
3. **favorites**: `userId + placeId` unique

**Implémentation recommandée:**
```dart
// Avant de créer un rating
final existingRating = await _firestore
  .collection('ratings')
  .where('placeId', isEqualTo: placeId)
  .where('userId', isEqualTo: userId)
  .limit(1)
  .get();

if (existingRating.docs.isNotEmpty) {
  // UPDATE existingRating
} else {
  // CREATE new rating
}
```

---

## 📝 Notes Importantes

1. **Dénormalisation**: Les données fréquemment affichées (userName, placeImage, etc.) sont dénormalisées pour éviter les reads multiples.

2. **Geohash**: Utiliser la bibliothèque `geoflutterfire` ou `geoflutterfire2` pour les queries géospatiales.

3. **Soft Delete**: Préférer le soft delete (champ `isDeleted: true`) plutôt que la suppression réelle.

4. **Pagination**: Toujours utiliser `limit()` et `startAfter()` pour les listes.

5. **Offline Persistence**: Activer la persistence Firestore côté client pour améliorer l'UX.

```dart
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true,
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);
```
