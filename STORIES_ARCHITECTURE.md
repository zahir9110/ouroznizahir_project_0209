# 🎬 ARCHITECTURE STORIES - BENIN EXPERIENCE
## Documentation complète de la feature Stories

---

## 📐 ARCHITECTURE OVERVIEW

### **Pattern**: Clean Architecture (Domain → Data → Presentation)
### **State Management**: BLoC/Cubit
### **Backend**: Firebase (Firestore + Storage + Cloud Functions)
### **Inspiration UX**: Instagram Stories + TikTok

---

## 🗂️ STRUCTURE DES FICHIERS

```
lib/features/stories/
├── domain/
│   ├── entities/
│   │   ├── story.dart                    ✅ Story principale
│   │   ├── story_segment.dart            ✅ Segment photo/vidéo
│   │   ├── story_cta.dart                ✅ Call-to-Action
│   │   └── story_analytics.dart          ✅ Analytics (vues, interactions)
│   ├── repositories/
│   │   └── stories_repository.dart       ✅ Contrat abstrait
│   └── usecases/
│       ├── create_story.dart             ✅ Créer une story
│       ├── get_following_stories.dart    ✅ Feed stories suivis
│       ├── view_story.dart               ✅ Enregistrer vue
│       ├── delete_story.dart             ✅ Supprimer story
│       └── get_story_analytics.dart      ✅ Récupérer analytics
├── data/
│   ├── datasources/
│   │   └── stories_remote_datasource.dart ✅ Firestore + Storage
│   ├── models/
│   │   └── story_model.dart              ✅ Conversion Firestore
│   └── repositories/
│       └── stories_repository_impl.dart   ✅ Implémentation repository
└── presentation/
    ├── bloc/
    │   ├── stories_feed_bloc.dart        ✅ Feed horizontal
    │   ├── story_viewer_bloc.dart        ✅ Viewer plein écran
    │   └── story_creator_bloc.dart       ⏳ À implémenter (Phase 2)
    ├── pages/
    │   ├── stories_feed_bar.dart         ✅ Barre horizontale
    │   ├── story_viewer_page.dart        ✅ Plein écran
    │   └── story_creator_page.dart       ⏳ À implémenter
    └── widgets/
        ├── story_ring.dart               ✅ Cercle avec gradient
        ├── story_progress_bar.dart       ✅ Barres progression
        ├── story_cta_button.dart         ✅ Bouton CTA
        └── story_segment_viewer.dart     ✅ Viewer image/vidéo
```

---

## 🗄️ SCHÉMA FIRESTORE

### **Collection: `stories/`**
```typescript
{
  storyId: {
    // Créateur
    userId: string,
    userDisplayName: string,
    userPhotoUrl: string,
    
    // Dates
    createdAt: Timestamp,
    expiresAt: Timestamp,           // +24h auto-expiration
    
    // Type
    type: 'standard' | 'event_promo' | 'ticket_sale',
    
    // Liens (optionnels)
    eventId?: string,
    eventTitle?: string,
    ticketId?: string,
    ticketPrice?: number,
    ticketCurrency: 'XOF',
    
    // Segments (photos/vidéos)
    segments: [
      {
        id: string,
        type: 'image' | 'video',
        mediaUrl: string,
        thumbnailUrl?: string,
        duration: number,            // secondes
        order: number,
      }
    ],
    
    // CTA
    cta?: {
      type: 'buy_ticket' | 'chat' | 'view_event' | 'visit_profile',
      text: string,
      targetId: string,
    },
    
    // Analytics
    viewsCount: number,
    completionCount: number,
    interactionsCount: number,
    
    // Géoloc
    location?: GeoPoint,
    locationCity?: string,
    
    // Statut
    status: 'active' | 'expired' | 'deleted',
    isVerified: boolean,
    isFlagged: boolean,
  }
}
```

### **Sous-collection: `stories/{storyId}/viewers/`**
```typescript
{
  userId: {
    viewedAt: Timestamp,
    viewedSegments: number[],       // indices segments vus
    completedFully: boolean,
    interacted: boolean,
    interactionType?: string,
  }
}
```

### **Collection dénormalisée: `users/{userId}/stories_feed/`**
```typescript
{
  storyId: {
    userId: string,
    userDisplayName: string,
    userPhotoUrl: string,
    hasNewContent: boolean,
    lastSegmentSeen: number,
    updatedAt: Timestamp,
  }
}
```

---

## ⚙️ CLOUD FUNCTIONS (TypeScript)

### **1. Créer story + Fanout followers**
```typescript
// functions/src/stories/create_story.ts
export const createStory = functions.firestore
  .document('stories/{storyId}')
  .onCreate(async (snapshot, context) => {
    const story = snapshot.data();
    const userId = story.userId;
    
    // Récupérer followers
    const followersSnapshot = await db
      .collection('users')
      .doc(userId)
      .collection('followers')
      .get();
    
    // Fanout (écriture dénormalisée)
    const batch = db.batch();
    
    followersSnapshot.forEach(doc => {
      const followerRef = db
        .collection('users')
        .doc(doc.id)
        .collection('stories_feed')
        .doc(snapshot.id);
      
      batch.set(followerRef, {
        userId,
        userDisplayName: story.userDisplayName,
        userPhotoUrl: story.userPhotoUrl,
        hasNewContent: true,
        updatedAt: FieldValue.serverTimestamp(),
      });
    });
    
    await batch.commit();
  });
```

### **2. Nettoyage automatique (expirées)**
```typescript
// functions/src/stories/cleanup_expired.ts
export const cleanupExpiredStories = functions.pubsub
  .schedule('every 2 hours')
  .onRun(async (context) => {
    const now = new Date();
    
    const expiredSnapshot = await db
      .collection('stories')
      .where('status', '==', 'active')
      .where('expiresAt', '<', now)
      .limit(100)
      .get();
    
    const batch = db.batch();
    
    expiredSnapshot.forEach(doc => {
      batch.update(doc.ref, { status: 'expired' });
    });
    
    await batch.commit();
    console.log(`✅ ${expiredSnapshot.size} stories nettoyées`);
  });
```

---

## 🎯 FLUX UTILISATEURS

### **Flux 1: Voir les Stories**
```
1. User ouvre app → HomePage
2. Barre horizontale en haut (StoriesFeedBar)
3. Cercles avec gradient (nouveaux = bleu, vus = gris)
4. Tap sur cercle → StoryViewerPage (plein écran)
5. Segments défilent auto (5s image, durée vidéo)
6. Tap gauche = segment précédent
7. Tap droit = segment suivant
8. Long press = pause
9. Swipe bas = fermer
10. Enregistrement vue en temps réel
```

### **Flux 2: Poster une Story**
```
1. User clique "+" dans barre
2. Ouvre caméra ou galerie (image_picker)
3. Sélectionne photos/vidéos (max 10)
4. Ajoute texte, stickers
5. Si événement lié → sélectionne
6. Si billet à vendre → saisit prix
7. Ajoute CTA ("Acheter", "Discuter")
8. Upload médias → Storage
9. Cloud Function → fanout followers
10. Story apparaît dans feed
```

### **Flux 3: Story Billet à Vendre**
```
1. Organisateur poste story type "ticket_sale"
2. Segments = photos événement
3. CTA = "Acheter 15,000 FCFA"
4. Viewer clique CTA
5. Ouvre fiche billet (modal)
6. Option 1: Achat direct
7. Option 2: "Discuter" → DM
8. Après vente → story mise à jour "Vendu"
```

---

## 📱 WIDGETS UI CLÉS

### **StoryRing** (Cercle avec gradient)
- Gradient Instagram (rouge → jaune) si nouveau
- Gris si tout vu
- Photo profil au centre

### **StoryProgressBar** (Barres en haut)
- N barres = N segments
- Animation auto selon durée
- Pause/Resume avec long press

### **StoryCTAButton** (Bouton action)
- Centré en bas de l'écran
- Couleur selon type (vert = acheter, orange = discuter)
- Icône + texte

### **StorySegmentViewer** (Image/Vidéo)
- Utilise `cached_network_image` pour images
- Utilise `video_player` pour vidéos
- Fit: contain (pas de crop)

---

## 🔐 SÉCURITÉ FIRESTORE

```typescript
// firestore.rules
match /stories/{storyId} {
  // Lecture: stories actives uniquement
  allow read: if resource.data.status == 'active' 
    && request.time < resource.data.expiresAt;
  
  // Création: user authentifié
  allow create: if request.auth != null 
    && request.resource.data.userId == request.auth.uid;
  
  // Suppression: propriétaire uniquement
  allow delete: if request.auth.uid == resource.data.userId;
  
  // Viewers (enregistrement vues)
  match /viewers/{viewerId} {
    allow write: if request.auth.uid == viewerId;
    allow read: if request.auth.uid == get(/databases/$(database)/documents/stories/$(storyId)).data.userId;
  }
}

// Feed utilisateur
match /users/{userId}/stories_feed/{storyId} {
  allow read: if request.auth.uid == userId;
  allow write: if false; // Écrit uniquement par Cloud Functions
}
```

---

## 🎨 RECOMMANDATIONS UX

### **Performance**
- Précharger segment suivant (n+1)
- Compression vidéos (max 720p)
- Thumbnails pour vidéos
- Cache images avec `cached_network_image`

### **Engagement**
- Notif push "X a posté une story"
- Badge rouge sur cercle si nouveau
- Analytics visibles pour créateurs
- Swipe up pour découvrir plus (Phase 2)

### **Accessibilité**
- Sous-titres auto pour vidéos
- Alternatives textuelles pour images
- Contrastes élevés pour CTA

---

## 📦 MVP vs PHASE 2

### **✅ MVP (Fonctionnel)**
- [x] Voir stories suivis (barre horizontale)
- [x] Viewer plein écran avec segments
- [x] Enregistrement vues + analytics
- [x] CTA basiques (acheter, discuter)
- [x] Expiration 24h automatique
- [x] Stories liées à événements/billets

### **⏳ PHASE 2 (Avancé)**
- [ ] Créateur de story (caméra + galerie)
- [ ] Filtres et stickers
- [ ] Mentions @utilisateur
- [ ] Stories highlights (permanentes)
- [ ] Réponses privées aux stories
- [ ] Stories géolocalisées (discovery)
- [ ] Analytics détaillés (taux sortie, heat maps)
- [ ] Stories sponsorisées (organisateurs pro)

---

## 🔧 DÉPENDANCES REQUISES

Ajouter dans `pubspec.yaml`:
```yaml
dependencies:
  video_player: ^2.8.0          # Lecture vidéos
  image_picker: ^1.2.1          # Caméra/galerie
  uuid: ^4.5.2                  # ID uniques segments
```

---

## 🚀 INTÉGRATION DANS L'APP

### **1. Ajouter dans HomePage**
```dart
// lib/features/home/presentation/pages/home_page.dart
CustomScrollView(
  slivers: [
    SliverToBoxAdapter(
      child: StoriesFeedBar(currentUserId: 'demo_user'),
    ),
    // ... reste du feed
  ],
)
```

### **2. Register dans DI (locator.dart)**
```dart
// Stories
sl.registerLazySingleton<StoriesRemoteDataSource>(
  () => StoriesRemoteDataSourceImpl(
    firestore: sl(),
    storage: sl(),
  ),
);

sl.registerLazySingleton<StoriesRepository>(
  () => StoriesRepositoryImpl(remoteDataSource: sl()),
);

sl.registerLazySingleton(() => GetFollowingStories(sl()));
sl.registerLazySingleton(() => ViewStory(sl()));

sl.registerFactory(() => StoriesFeedBloc(getFollowingStories: sl()));
sl.registerFactory(() => StoryViewerBloc(viewStory: sl()));
```

---

## 🎯 NEXT STEPS

1. **Tester l'architecture** avec données mockées
2. **Implémenter créateur de story** (Phase 2)
3. **Ajouter analytics avancés**
4. **Optimiser performance** (preload, cache)
5. **A/B testing** CTA (couleurs, textes)
6. **Intégration billets** avec vérification
7. **Modération contenu** (IA + manuel)

---

## 📞 SUPPORT & MAINTENANCE

- **Monitoring**: Firebase Performance + Analytics
- **Crash reporting**: Firebase Crashlytics
- **Logs**: Cloud Functions logs pour fanout
- **Coûts**: Storage vidéos (max 100MB/story)

---

✅ **ARCHITECTURE STORIES COMPLÈTE ET PRÊTE POUR MVP** 🎬
