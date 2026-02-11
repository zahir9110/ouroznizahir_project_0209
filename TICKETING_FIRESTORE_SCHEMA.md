# 🎟️ SCHÉMA FIRESTORE - BILLETTERIE SOCIALE

## Vue d'ensemble

Système de billetterie permettant aux professionnels vérifiés de vendre des tickets pour événements, visites guidées, activités culturelles, etc. avec features sociales (partage, commentaires, recommandations).

---

## 📊 Collections principales

### 1. `tickets/` - Tickets individuels

```typescript
{
  ticketId: string,                    // ID auto-généré
  eventId: string,                      // Référence vers events/
  sellerId: string,                     // Professionnel vérifié
  
  // Informations du ticket
  type: 'single' | 'group' | 'vip' | 'standard' | 'premium',
  title: string,                        // "Visite guidée du Palais Royal"
  description: string,                  // Description détaillée
  
  // Prix et disponibilité
  price: {
    amount: number,                     // 5000 (en FCFA)
    currency: 'XOF',
    originalPrice?: number,             // Prix barré si promo
    discount?: {
      percentage: number,               // 20
      validUntil: timestamp,
    }
  },
  
  stock: {
    total: number,                      // 100
    available: number,                  // 87
    reserved: number,                   // 8 (panier mais pas payé)
    sold: number,                       // 5
  },
  
  // Validité temporelle
  validity: {
    startDate: timestamp,               // Date de début de validité
    endDate: timestamp,                 // Date de fin
    specificDates?: timestamp[],        // [2026-02-15, 2026-02-16] (dates précises)
    daysOfWeek?: number[],              // [1,3,5] = Lun/Mer/Ven
    timeSlots?: {
      start: string,                    // "09:00"
      end: string,                      // "12:00"
      maxPerSlot: number,               // 20
    }[]
  },
  
  // Localisation
  location: {
    name: string,                       // "Palais Royal d'Abomey"
    address: string,
    city: string,
    region: string,
    coordinates: geopoint,              // GeoPoint(6.456, 2.345)
    meetingPoint?: string,              // "Devant l'entrée principale"
  },
  
  // Inclusions (ce qui est compris)
  includes: string[],                   // ["Guide francophone", "Eau minérale", "Photos souvenir"]
  excludes: string[],                   // ["Transport", "Repas"]
  
  // Conditions
  conditions: {
    minAge?: number,                    // 12
    maxGroupSize?: number,              // 15
    requiresID: boolean,                // true
    cancellationPolicy: 'flexible' | 'moderate' | 'strict',
    refundableUntil?: timestamp,        // 48h avant
  },
  
  // Features sociales
  social: {
    views: number,                      // 1234
    likes: number,                      // 89
    shares: number,                     // 23
    bookings: number,                   // 45
    rating: number,                     // 4.7
    reviewCount: number,                // 12
  },
  
  // Médias
  media: {
    coverImage: string,                 // URL principale
    images: string[],                   // Galerie photos
    videoUrl?: string,                  // Vidéo de présentation
  },
  
  // Tags et catégorisation
  tags: string[],                       // ["culture", "histoire", "patrimoine"]
  category: 'culture' | 'nature' | 'sport' | 'gastronomie' | 'aventure' | 'wellness',
  
  // Statut
  status: 'active' | 'paused' | 'soldout' | 'expired' | 'cancelled',
  featured: boolean,                    // Mis en avant
  verified: boolean,                    // Ticket vérifié par admin
  
  // Métadonnées
  createdAt: timestamp,
  updatedAt: timestamp,
  createdBy: string,                    // sellerId
}
```

**Index composites nécessaires:**
```
- sellerId + status + createdAt (DESC)
- eventId + status + price.amount (ASC)
- category + status + social.rating (DESC)
- location.city + status + validity.startDate (ASC)
```

---

### 2. `events/` - Événements et activités

```typescript
{
  eventId: string,
  organizerId: string,                  // Professionnel vérifié
  
  // Informations principales
  title: string,                        // "Festival des Masques d'Abomey"
  slug: string,                         // "festival-masques-abomey-2026"
  description: string,
  shortDescription: string,             // Pour aperçus
  
  // Type d'événement
  type: 'festival' | 'tour' | 'workshop' | 'exhibition' | 'concert' | 'sport',
  duration: {
    value: number,                      // 3
    unit: 'hours' | 'days' | 'weeks',
  },
  
  // Période
  schedule: {
    startDate: timestamp,
    endDate: timestamp,
    isRecurring: boolean,
    recurrence?: {
      frequency: 'daily' | 'weekly' | 'monthly',
      daysOfWeek?: number[],
      endsOn?: timestamp,
    }
  },
  
  // Localisation
  venue: {
    name: string,
    address: string,
    city: string,
    region: string,
    coordinates: geopoint,
    capacity?: number,                  // 500
  },
  
  // Types de tickets disponibles
  ticketTypes: {
    ticketId: string,                   // Référence
    name: string,                       // "VIP", "Standard"
    available: number,
  }[],
  
  // Prix range (pour affichage)
  priceRange: {
    min: number,                        // 2000
    max: number,                        // 15000
    currency: 'XOF',
  },
  
  // Médias
  media: {
    coverImage: string,
    banner: string,                     // Image large pour header
    gallery: string[],
    promoVideo?: string,
  },
  
  // Features sociales
  social: {
    attendees: number,                  // Nombre de participants
    interested: number,                 // "Je suis intéressé"
    shares: number,
    rating: number,
    reviewCount: number,
  },
  
  // Partenaires
  sponsors?: {
    name: string,
    logo: string,
    website?: string,
  }[],
  
  // Tags
  tags: string[],
  category: string,
  
  // Statut
  status: 'draft' | 'published' | 'ongoing' | 'completed' | 'cancelled',
  featured: boolean,
  trending: boolean,                    // Calculé par Cloud Function
  
  // Métadonnées
  createdAt: timestamp,
  updatedAt: timestamp,
  publishedAt?: timestamp,
}
```

---

### 3. `bookings/` - Réservations/Achats

```typescript
{
  bookingId: string,
  userId: string,
  ticketId: string,
  eventId: string,
  sellerId: string,
  
  // Détails du ticket au moment de l'achat (snapshot)
  ticketSnapshot: {
    title: string,
    type: string,
    price: number,
    validFrom: timestamp,
    validUntil: timestamp,
  },
  
  // Participants
  participants: {
    fullName: string,
    email?: string,
    phone?: string,
    age?: number,
    idNumber?: string,                  // Si requis
  }[],
  
  // Paiement
  payment: {
    method: 'momo' | 'wave' | 'moov' | 'card' | 'cash',
    amount: number,
    currency: 'XOF',
    transactionId: string,
    operatorReference?: string,         // Référence opérateur mobile money
    status: 'pending' | 'completed' | 'failed' | 'refunded',
    paidAt?: timestamp,
    refundedAt?: timestamp,
    refundReason?: string,
  },
  
  // QR Code pour validation
  qrCode: {
    data: string,                       // bookingId crypté
    imageUrl: string,                   // QR généré
    secret: string,                     // Pour validation offline
  },
  
  // Validation
  validation: {
    isValidated: boolean,
    validatedAt?: timestamp,
    validatedBy?: string,               // ID du validateur
    validationLocation?: geopoint,
  },
  
  // Statut de la réservation
  status: 'pending' | 'confirmed' | 'used' | 'cancelled' | 'expired' | 'refunded',
  
  // Notifications
  notificationsSent: {
    confirmation: boolean,
    reminder24h: boolean,
    reminder1h: boolean,
    postEvent: boolean,
  },
  
  // Review
  hasReviewed: boolean,
  reviewId?: string,
  
  // Métadonnées
  createdAt: timestamp,
  updatedAt: timestamp,
  expiresAt: timestamp,
}
```

**Index:**
```
- userId + status + createdAt (DESC)
- ticketId + status + createdAt (DESC)
- sellerId + status + payment.paidAt (DESC)
- qrCode.data (pour validation rapide)
```

---

### 4. `reviews/` - Avis clients

```typescript
{
  reviewId: string,
  bookingId: string,                    // Seuls les acheteurs peuvent commenter
  userId: string,
  ticketId: string,
  eventId: string,
  sellerId: string,
  
  // Note
  rating: number,                       // 1-5
  
  // Détails
  title?: string,                       // "Expérience inoubliable !"
  comment: string,
  
  // Notes détaillées
  breakdown?: {
    quality: number,                    // 5
    value: number,                      // 4 (rapport qualité/prix)
    service: number,                    // 5
    accuracy: number,                   // 5 (correspond à la description)
  },
  
  // Médias
  photos?: string[],
  
  // Réponse du vendeur
  sellerResponse?: {
    comment: string,
    respondedAt: timestamp,
    respondedBy: string,
  },
  
  // Modération
  status: 'pending' | 'approved' | 'rejected' | 'flagged',
  flaggedBy?: string[],
  flagReason?: string,
  
  // Utilité
  helpfulCount: number,                 // "Cet avis m'a aidé"
  
  // Métadonnées
  createdAt: timestamp,
  updatedAt: timestamp,
  verifiedPurchase: boolean,            // true (lié à un booking)
}
```

---

### 5. `carts/` - Paniers d'achat

```typescript
{
  cartId: string,                       // userId (1 panier par user)
  userId: string,
  
  items: {
    ticketId: string,
    quantity: number,
    priceAtAdd: number,                 // Prix au moment de l'ajout
    selectedDate?: timestamp,           // Date choisie si multiple
    selectedTimeSlot?: string,          // "09:00-12:00"
    addedAt: timestamp,
    reservedUntil: timestamp,           // Expire après 15 min
  }[],
  
  // Totaux
  subtotal: number,
  discounts: {
    code: string,
    amount: number,
    type: 'percentage' | 'fixed',
  }[],
  total: number,
  
  // Promo codes appliqués
  promoCodes: string[],
  
  // Métadonnées
  updatedAt: timestamp,
  expiresAt: timestamp,                 // Auto-nettoyage après 24h
}
```

---

### 6. `promo_codes/` - Codes promotionnels

```typescript
{
  promoId: string,
  code: string,                         // "BENIN2026" (index unique)
  
  // Type de réduction
  discount: {
    type: 'percentage' | 'fixed',
    value: number,                      // 20 (%) ou 1000 (FCFA)
    maxDiscount?: number,               // Plafond si pourcentage
  },
  
  // Conditions d'utilisation
  conditions: {
    minPurchase?: number,               // Montant minimum
    maxUses?: number,                   // 100 utilisations max
    usesPerUser?: number,               // 1 fois par user
    validFrom: timestamp,
    validUntil: timestamp,
    
    // Applicabilité
    applicableTo?: {
      ticketIds?: string[],
      sellerIds?: string[],
      categories?: string[],
      eventIds?: string[],
    }
  },
  
  // Statistiques
  stats: {
    totalUses: number,
    totalDiscount: number,              // Montant total remisé
    uniqueUsers: number,
  },
  
  // Créateur
  createdBy: string,                    // Admin ou sellerId
  status: 'active' | 'paused' | 'expired',
  
  createdAt: timestamp,
}
```

**Index:**
```
- code (unique)
- status + validUntil (ASC)
```

---

### 7. `favorites/` - Tickets favoris

```typescript
{
  favoriteId: string,
  userId: string,
  ticketId: string,
  
  // Métadonnées
  addedAt: timestamp,
  
  // Notifications
  notifyOnDiscount: boolean,
  notifyOnAvailability: boolean,        // Si soldout actuellement
}
```

**Index:**
```
- userId + addedAt (DESC)
- ticketId (pour compter les favoris)
```

---

### 8. `notifications/` - Notifications utilisateur

```typescript
{
  notificationId: string,
  userId: string,
  
  type: 'booking_confirmed' | 'reminder_24h' | 'reminder_1h' | 
        'ticket_available' | 'price_drop' | 'review_request' |
        'seller_response' | 'refund_processed',
  
  title: string,
  body: string,
  
  // Données associées
  data: {
    bookingId?: string,
    ticketId?: string,
    eventId?: string,
    deepLink?: string,                  // benin://ticket/abc123
  },
  
  // Statut
  read: boolean,
  readAt?: timestamp,
  
  // Canaux
  channels: {
    push: boolean,
    email: boolean,
    sms: boolean,
  },
  sentAt: timestamp,
  
  createdAt: timestamp,
}
```

---

### 9. `analytics_events/` - Événements analytics

```typescript
{
  eventId: string,
  userId?: string,                      // null si anonyme
  sessionId: string,
  
  eventType: 'ticket_view' | 'ticket_share' | 'ticket_like' |
             'add_to_cart' | 'remove_from_cart' | 
             'checkout_start' | 'purchase_complete' |
             'review_submit' | 'favorite_add',
  
  // Contexte
  ticketId?: string,
  sellerId?: string,
  category?: string,
  
  // Données spécifiques
  properties: map<string, any>,
  
  // Provenance
  source: {
    platform: 'ios' | 'android' | 'web',
    appVersion: string,
    referrer?: string,
  },
  
  timestamp: timestamp,
}
```

---

## 🔐 Règles de sécurité Firestore

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper functions
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    function isVerifiedSeller() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isVerified == true;
    }
    
    // Tickets - Lecture publique, écriture vendeurs vérifiés
    match /tickets/{ticketId} {
      allow read: if resource.data.status == 'active';
      allow create: if isVerifiedSeller() && 
                       request.resource.data.sellerId == request.auth.uid;
      allow update: if isVerifiedSeller() && 
                       resource.data.sellerId == request.auth.uid;
      allow delete: if isVerifiedSeller() && 
                       resource.data.sellerId == request.auth.uid;
    }
    
    // Events - Lecture publique, écriture organisateurs vérifiés
    match /events/{eventId} {
      allow read: if resource.data.status in ['published', 'ongoing'];
      allow create, update: if isVerifiedSeller() && 
                               request.resource.data.organizerId == request.auth.uid;
    }
    
    // Bookings - Privé à l'utilisateur et au vendeur
    match /bookings/{bookingId} {
      allow read: if isOwner(resource.data.userId) || 
                     isOwner(resource.data.sellerId);
      allow create: if isAuthenticated() && 
                       request.resource.data.userId == request.auth.uid;
      allow update: if isOwner(resource.data.userId) || 
                       (isOwner(resource.data.sellerId) && 
                        request.resource.data.diff(resource.data).affectedKeys()
                          .hasOnly(['validation', 'status']));
    }
    
    // Reviews - Lecture publique, écriture acheteurs vérifiés
    match /reviews/{reviewId} {
      allow read: if resource.data.status == 'approved';
      allow create: if isAuthenticated() && 
                       request.resource.data.userId == request.auth.uid &&
                       exists(/databases/$(database)/documents/bookings/$(request.resource.data.bookingId));
      allow update: if isOwner(resource.data.userId) ||
                       (isOwner(resource.data.sellerId) && 
                        request.resource.data.diff(resource.data).affectedKeys()
                          .hasOnly(['sellerResponse']));
    }
    
    // Carts - Privé à l'utilisateur
    match /carts/{cartId} {
      allow read, write: if isOwner(cartId);
    }
    
    // Favorites - Privé à l'utilisateur
    match /favorites/{favoriteId} {
      allow read, write: if isOwner(resource.data.userId);
    }
    
    // Promo codes - Lecture authentifiée
    match /promo_codes/{promoId} {
      allow read: if isAuthenticated() && resource.data.status == 'active';
      allow write: if false; // Géré côté serveur
    }
    
    // Notifications - Privé à l'utilisateur
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId);
      allow update: if isOwner(resource.data.userId) && 
                       request.resource.data.diff(resource.data).affectedKeys()
                         .hasOnly(['read', 'readAt']);
    }
  }
}
```

---

## ⚡ Cloud Functions recommandées

### 1. `onTicketPurchase` - Traitement post-achat
```typescript
export const onTicketPurchase = functions.firestore
  .document('bookings/{bookingId}')
  .onCreate(async (snap, context) => {
    const booking = snap.data();
    
    // 1. Décrémenter stock ticket
    await decrementTicketStock(booking.ticketId, booking.participants.length);
    
    // 2. Générer QR Code
    const qrCode = await generateSecureQRCode(context.params.bookingId);
    await snap.ref.update({ qrCode });
    
    // 3. Envoyer notification confirmation
    await sendBookingConfirmation(booking.userId, booking);
    
    // 4. Créer événement analytics
    await logAnalytics('purchase_complete', booking);
  });
```

### 2. `scheduleReminders` - Rappels automatiques
```typescript
export const scheduleReminders = functions.pubsub
  .schedule('every 1 hours')
  .onRun(async (context) => {
    const now = Timestamp.now();
    const in24h = new Date(now.toDate().getTime() + 24 * 60 * 60 * 1000);
    const in1h = new Date(now.toDate().getTime() + 1 * 60 * 60 * 1000);
    
    // Rappel 24h
    const bookings24h = await getUpcomingBookings(in24h);
    for (const booking of bookings24h) {
      if (!booking.notificationsSent.reminder24h) {
        await sendReminder(booking, '24h');
      }
    }
    
    // Rappel 1h
    const bookings1h = await getUpcomingBookings(in1h);
    for (const booking of bookings1h) {
      if (!booking.notificationsSent.reminder1h) {
        await sendReminder(booking, '1h');
      }
    }
  });
```

### 3. `updateTicketSocial` - Agrégation stats sociales
```typescript
export const updateTicketSocial = functions.firestore
  .document('reviews/{reviewId}')
  .onWrite(async (change, context) => {
    const review = change.after.exists ? change.after.data() : null;
    
    if (!review) return; // Suppression
    
    // Recalculer moyenne + count
    const reviews = await getTicketReviews(review.ticketId);
    const avgRating = reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length;
    
    await db.doc(`tickets/${review.ticketId}`).update({
      'social.rating': avgRating,
      'social.reviewCount': reviews.length,
    });
  });
```

### 4. `cleanExpiredCarts` - Nettoyage paniers
```typescript
export const cleanExpiredCarts = functions.pubsub
  .schedule('every 30 minutes')
  .onRun(async () => {
    const expired = await db.collection('carts')
      .where('expiresAt', '<', Timestamp.now())
      .get();
    
    const batch = db.batch();
    expired.docs.forEach(doc => batch.delete(doc.ref));
    await batch.commit();
    
    logger.info(`Cleaned ${expired.size} expired carts`);
  });
```

---

## 🔍 Requêtes typiques optimisées

### Recherche tickets par ville + catégorie
```typescript
db.collection('tickets')
  .where('status', '==', 'active')
  .where('location.city', '==', 'Cotonou')
  .where('category', '==', 'culture')
  .orderBy('social.rating', 'desc')
  .limit(20);
```

### Tickets tendance (meilleurs ventes)
```typescript
db.collection('tickets')
  .where('status', '==', 'active')
  .where('featured', '==', true)
  .orderBy('social.bookings', 'desc')
  .limit(10);
```

### Historique achats utilisateur
```typescript
db.collection('bookings')
  .where('userId', '==', currentUserId)
  .where('status', 'in', ['confirmed', 'used'])
  .orderBy('createdAt', 'desc');
```

### Prochains événements dans une région
```typescript
db.collection('events')
  .where('venue.region', '==', 'Atlantique')
  .where('schedule.startDate', '>=', Timestamp.now())
  .orderBy('schedule.startDate', 'asc')
  .limit(15);
```

---

## 💡 Features sociales avancées

### Collection `user_interactions/` (optionnel)
```typescript
{
  interactionId: string,
  userId: string,
  targetType: 'ticket' | 'event' | 'seller',
  targetId: string,
  action: 'like' | 'share' | 'view' | 'interested',
  timestamp: timestamp,
}
```

### Collection `recommendations/` (ML-based)
```typescript
{
  recommendationId: string,
  userId: string,
  ticketIds: string[],                  // Top 20 recommandés
  algorithm: 'collaborative' | 'content-based' | 'hybrid',
  score: number[],                      // Scores de confiance
  generatedAt: timestamp,
  expiresAt: timestamp,                 // Recalculé toutes les 24h
}
```

---

**🎯 Points clés:**
- ✅ Stock management avec réservation temporaire (15 min)
- ✅ QR Codes sécurisés pour validation offline
- ✅ Support multi-dates et créneaux horaires
- ✅ Reviews uniquement post-achat (verified purchase)
- ✅ Notifications multi-canal (push/email/sms)
- ✅ Analytics détaillés pour vendeurs
- ✅ Promo codes flexibles avec conditions
- ✅ Paniers auto-expirés pour libérer stock
