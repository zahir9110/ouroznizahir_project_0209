# 📦 Structure Backend Complète - Bōken

## 📂 Fichiers Créés

### 📄 Documentation
1. **[BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md)**
   - Architecture complète Guest/User/Organizer
   - Règles d'autorisation détaillées
   - Schéma Firestore Rules
   - Exemples d'implémentation Flutter
   - Tableau récapitulatif des permissions

2. **[FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)**
   - Structure de toutes les collections Firestore
   - Champs détaillés avec types
   - Indexes composites requis
   - Règles de validation
   - Contraintes d'unicité
   - Notes sur la dénormalisation

3. **[BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md)**
   - Guide pratique d'intégration
   - Patterns d'utilisation
   - Exemples de code Flutter
   - Tests et validation
   - Points d'attention
   - Checklist de déploiement

---

### 🔧 Code Flutter

4. **[lib/core/services/auth_service.dart](./lib/core/services/auth_service.dart)**
   - Enum `UserRole` (guest, user, organizer)
   - Service d'authentification Firebase
   - Méthodes de vérification de rôles
   - Inscription avec rôle
   - Upgrade User → Organizer

5. **[lib/core/utils/permission_guard.dart](./lib/core/utils/permission_guard.dart)**
   - Guard de permissions
   - Vérifications requireAuth, requireUserRole, requireOrganizerRole
   - Callbacks pour actions non autorisées
   - Méthodes helper pour chaque permission

6. **[lib/core/constants/auth_constants.dart](./lib/core/constants/auth_constants.dart)**
   - Constantes de rôles
   - Messages d'erreur en français
   - Collections et champs Firestore
   - Types de lieux, offres, cibles
   - Statuts de réservation et paiement
   - Limites et contraintes
   - Durées de cache

---

### 🔒 Configuration Firebase

7. **[firestore.rules](./firestore.rules)**
   - Règles de sécurité Firestore complètes
   - Fonctions helper (isAuthenticated, isUser, isOrganizer, etc.)
   - Règles par collection avec commentaires
   - Validations côté serveur

8. **[firestore.indexes.json](./firestore.indexes.json)**
   - Indexes composites pour toutes les collections
   - Optimisations pour les queries fréquentes
   - Prêt pour déploiement avec Firebase CLI

---

## 🎯 Vision Produit Implémentée

### 🔓 GUEST (Non Inscrit)
✅ Exploration libre
- Carte touristique
- Liste des lieux
- Lecture des notes et avis
- Consultation des offres

❌ Pas d'interactions sociales
- Pas de messagerie
- Pas de likes/commentaires
- Pas de publication d'avis
- Pas de favoris

---

### 🎒 USER (Inscrit)
✅ Toutes les permissions Guest
✅ Interactions sociales complètes
- Messagerie
- Likes, commentaires, partages
- Notation des lieux
- Publication d'avis
- Sauvegarde de favoris
- Réservations d'offres

---

### 🏢 ORGANIZER (Professionnel)
✅ Toutes les permissions User
✅ Fonctionnalités PRO
- Publication d'offres/expériences
- Dashboard avec statistiques
- Gestion des réservations
- Accès aux analytics

---

## 🏗️ Architecture Technique

### Stack
- **Frontend:** Flutter
- **Backend:** Firebase (Firestore + Auth + Storage)
- **Base de données:** Firestore NoSQL
- **Authentification:** Firebase Auth
- **Sécurité:** Firestore Security Rules

### Patterns Utilisés
- **Clean Architecture:** Séparation concerns
- **RBAC:** Role-Based Access Control
- **Guard Pattern:** Vérification permissions
- **Dependency Injection:** get_it
- **State Management:** flutter_bloc
- **Dénormalisation:** Performance reads

---

## 🔐 Sécurité Double-Couche

### Côté Client (UX)
```dart
// Vérification avant action
final canLike = await _guard.canLike();
if (!canLike) {
  _showAuthDialog();
  return;
}
```

### Côté Serveur (Sécurité Réelle)
```javascript
// Firestore Rules
allow create: if isUserOrOrganizer() && 
                 request.resource.data.userId == request.auth.uid;
```

**Principe:** Ne jamais se fier uniquement au client. Firestore Rules = source de vérité.

---

## 📊 Collections Firestore

| Collection | Guest Read | Guest Write | User Write | Organizer Write |
|-----------|-----------|-------------|-----------|-----------------|
| places | ✅ (published) | ❌ | ❌ | ✅ (own) |
| ratings | ✅ | ❌ | ✅ | ✅ |
| reviews | ✅ | ❌ | ✅ | ✅ |
| messages | ❌ | ❌ | ✅ (own) | ✅ (own) |
| likes | ✅ | ❌ | ✅ | ✅ |
| comments | ✅ | ❌ | ✅ | ✅ |
| favorites | ❌ | ❌ | ✅ (own) | ✅ (own) |
| offers | ✅ (published) | ❌ | ❌ | ✅ (own) |
| bookings | ❌ | ❌ | ✅ (own) | ✅ (related) |

---

## 🚀 Déploiement

### 1. Déployer les règles Firestore
```bash
firebase deploy --only firestore:rules
```

### 2. Déployer les indexes
```bash
firebase deploy --only firestore:indexes
```

### 3. Vérifier le déploiement
```bash
firebase firestore:rules get
```

---

## 📝 Checklist de Migration

### Phase 1: Backend
- [x] Créer documentation architecture RBAC
- [x] Créer schéma Firestore complet
- [x] Implémenter Firestore Rules sécurisées
- [x] Configurer indexes composites
- [x] Créer guide d'intégration

### Phase 2: Code Flutter
- [x] Créer enum UserRole
- [x] Implémenter AuthService
- [x] Implémenter PermissionGuard
- [x] Créer constantes d'autorisation
- [ ] Configurer DI (service_locator)
- [ ] Implémenter guards dans l'UI existante

### Phase 3: UI/UX
- [ ] Créer dialogs d'authentification
- [ ] Implémenter affichage conditionnel par rôle
- [ ] Ajouter messages d'erreur en français
- [ ] Flow d'inscription User vs Organizer
- [ ] Boutons/actions avec guards

### Phase 4: Tests & Validation
- [ ] Tester règles Firestore (Firebase Emulator)
- [ ] Tests unitaires AuthService
- [ ] Tests unitaires PermissionGuard
- [ ] Tests d'intégration UI
- [ ] Tests de sécurité (tentatives d'accès non autorisées)

### Phase 5: Optimisation
- [ ] Implémenter Cloud Functions pour compteurs
- [ ] Configurer cache client
- [ ] Monitoring Firebase Analytics
- [ ] Logs d'erreurs de permissions
- [ ] Performance monitoring

---

## 🎓 Concepts Clés

### 1. Guest = Non Stocké
Les guests ne sont pas dans Firestore. Détection:
```dart
if (FirebaseAuth.instance.currentUser == null) {
  // Guest
}
```

### 2. Contraintes d'Unicité
Firestore ne supporte pas les contraintes d'unicité natives. Gestion côté application:
```dart
// Vérifier avant CREATE
final existing = await query.limit(1).get();
if (existing.docs.isNotEmpty) {
  // UPDATE
} else {
  // CREATE
}
```

### 3. Dénormalisation
Pour performances, dupliquer les données fréquemment lues:
```typescript
{
  userId: 'abc123',
  userName: 'Alice',      // Dénormalisé
  userPhoto: 'url...',    // Dénormalisé
  // ...
}
```

### 4. Indexes Composites
Requis pour queries avec multiple conditions:
```dart
// Nécessite index composite [placeId, createdAt]
.where('placeId', isEqualTo: placeId)
.orderBy('createdAt', descending: true)
```

---

## 🔗 Relations Entre Documents

```
users
  └─ (1:N) ratings
  └─ (1:N) reviews
  └─ (1:N) messages (sender)
  └─ (1:N) messages (receiver)
  └─ (1:N) likes
  └─ (1:N) comments
  └─ (1:N) favorites
  └─ (1:N) offers (if organizer)
  └─ (1:N) bookings

places
  └─ (1:N) ratings
  └─ (1:N) reviews
  └─ (1:N) favorites

offers
  └─ (1:N) bookings
```

---

## 💡 Exemples Rapides

### Vérifier si utilisateur peut commenter
```dart
final guard = sl<PermissionGuard>();
if (await guard.canComment()) {
  // Afficher formulaire de commentaire
}
```

### Afficher bouton conditionnel
```dart
StreamBuilder<UserRole>(
  stream: authService.roleStream,
  builder: (context, snapshot) {
    final role = snapshot.data ?? UserRole.guest;
    if (role.canPublishOffers) {
      return ElevatedButton(
        onPressed: _createOffer,
        child: const Text('Créer une offre'),
      );
    }
    return const SizedBox.shrink();
  },
)
```

### Créer un rating avec contrainte d'unicité
```dart
Future<void> ratePlace(String placeId, int score) async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  
  final existing = await _firestore
      .collection('ratings')
      .where('placeId', isEqualTo: placeId)
      .where('userId', isEqualTo: userId)
      .limit(1)
      .get();
  
  if (existing.docs.isNotEmpty) {
    await existing.docs.first.reference.update({'score': score});
  } else {
    await _firestore.collection('ratings').add({
      'placeId': placeId,
      'userId': userId,
      'score': score,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
```

---

## 🆘 Support & Références

### Documentation Firebase
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Auth](https://firebase.google.com/docs/auth)
- [Firestore Indexes](https://firebase.google.com/docs/firestore/query-data/indexing)

### Documentation Flutter
- [cloud_firestore](https://pub.dev/packages/cloud_firestore)
- [firebase_auth](https://pub.dev/packages/firebase_auth)
- [get_it](https://pub.dev/packages/get_it)

### Fichiers Projet
- Architecture: `BACKEND_RBAC_ARCHITECTURE.md`
- Schéma: `FIRESTORE_SCHEMA.md`
- Guide: `BACKEND_INTEGRATION_GUIDE.md`
- Code: `lib/core/services/`, `lib/core/utils/`, `lib/core/constants/`

---

## ✅ Résumé

L'architecture backend de Bōken est maintenant **complètement structurée** avec:

1. ✅ Vision produit claire (Guest → User → Organizer)
2. ✅ Règles de sécurité Firestore robustes
3. ✅ Schéma de base de données complet
4. ✅ Services Flutter prêts à l'emploi
5. ✅ Guards de permissions
6. ✅ Constantes et enums
7. ✅ Indexes optimisés
8. ✅ Documentation exhaustive
9. ✅ Exemples d'intégration
10. ✅ Guide de déploiement

**Prochaine étape:** Intégrer les services dans l'UI existante et déployer sur Firebase ! 🚀
