# 🔐 Backend RBAC - Démarrage Rapide

## 🎯 3 Types d'Utilisateurs

| Rôle | Authentifié | Peut Lire | Peut Interagir | Peut Publier Offres |
|------|------------|-----------|----------------|---------------------|
| **GUEST** | ❌ | ✅ | ❌ | ❌ |
| **USER** | ✅ | ✅ | ✅ | ❌ |
| **ORGANIZER** | ✅ | ✅ | ✅ | ✅ |

---

## 📚 Documentation Complète

### 🏗️ Architecture & Concepts
📄 **[BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md)**
- Vision produit détaillée
- Règles d'autorisation par rôle
- Schéma Firestore Rules complet
- Exemples d'implémentation Flutter

### 🗄️ Base de Données
📄 **[FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)**
- Structure de 11 collections
- Champs et types détaillés
- Indexes composites requis
- Contraintes et validations

### 🚀 Intégration Pratique
📄 **[BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md)**
- Patterns d'utilisation
- Exemples de code concrets
- Tests et validation
- Checklist de déploiement

### 📦 Résumé Complet
📄 **[BACKEND_STRUCTURE_SUMMARY.md](./BACKEND_STRUCTURE_SUMMARY.md)**
- Vue d'ensemble de tout le système
- Relations entre fichiers
- Exemples rapides
- Références utiles

---

## ⚡ Quick Start (5 minutes)

### 1️⃣ Déployer les règles Firestore
```bash
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### 2️⃣ Configurer le DI
Créer `lib/core/di/service_locator.dart`:
```dart
import 'package:get_it/get_it.dart';
import 'package:benin_experience/core/services/auth_service.dart';
import 'package:benin_experience/core/utils/permission_guard.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => PermissionGuard(sl()));
}
```

Dans `main.dart`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await setupServiceLocator();  // ← Ajouter cette ligne
  runApp(const MyApp());
}
```

### 3️⃣ Utiliser dans l'UI
```dart
import 'package:benin_experience/core/utils/permission_guard.dart';
import 'package:benin_experience/core/di/service_locator.dart';

class MyWidget extends StatelessWidget {
  final PermissionGuard _guard = sl<PermissionGuard>();
  
  Future<void> _onLikePressed() async {
    if (!await _guard.canLike()) {
      _showAuthDialog('Inscrivez-vous pour liker');
      return;
    }
    // Continuer...
  }
}
```

---

## 📁 Fichiers Créés

### 📄 Documentation (4 fichiers)
- `BACKEND_RBAC_ARCHITECTURE.md` - Architecture complète
- `FIRESTORE_SCHEMA.md` - Schéma base de données
- `BACKEND_INTEGRATION_GUIDE.md` - Guide pratique
- `BACKEND_STRUCTURE_SUMMARY.md` - Résumé

### 🔧 Code Flutter (3 fichiers)
- `lib/core/services/auth_service.dart` - Service d'authentification + enum UserRole
- `lib/core/utils/permission_guard.dart` - Guard de permissions
- `lib/core/constants/auth_constants.dart` - Constantes (12KB)

### 🔒 Configuration Firebase (2 fichiers)
- `firestore.rules` - Règles de sécurité
- `firestore.indexes.json` - Indexes composites

---

## 🎯 Permissions Par Action

| Action | GUEST | USER | ORGANIZER |
|--------|-------|------|-----------|
| Voir lieux | ✅ | ✅ | ✅ |
| Voir avis | ✅ | ✅ | ✅ |
| Liker | ❌ | ✅ | ✅ |
| Commenter | ❌ | ✅ | ✅ |
| Noter un lieu | ❌ | ✅ | ✅ |
| Publier un avis | ❌ | ✅ | ✅ |
| Envoyer un message | ❌ | ✅ | ✅ |
| Sauvegarder favoris | ❌ | ✅ | ✅ |
| Publier une offre | ❌ | ❌ | ✅ |
| Dashboard stats | ❌ | ❌ | ✅ |

---

## 🔐 Exemple Complet

```dart
class PlaceDetailPage extends StatelessWidget {
  final PermissionGuard _guard = sl<PermissionGuard>();
  final AuthService _authService = sl<AuthService>();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserRole>(
      stream: _authService.roleStream,
      builder: (context, snapshot) {
        final role = snapshot.data ?? UserRole.guest;
        
        return Column(
          children: [
            // Bouton visible seulement si peut interagir
            if (role.canInteract)
              ElevatedButton(
                onPressed: _likePlace,
                child: const Text('❤️ J\'aime'),
              ),
            
            // CTA pour les guests
            if (role.isGuest)
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: const Text('S\'inscrire pour interagir'),
              ),
          ],
        );
      },
    );
  }
  
  Future<void> _likePlace() async {
    // Double vérification (sécurité)
    if (!await _guard.requireUserRole(
      onUnauthorized: () => _showAuthDialog(),
    )) return;
    
    // Continuer avec le like
    await _placeService.likePlace(placeId);
  }
}
```

---

## ✅ Checklist d'Implémentation

### Backend
- [x] Documentation architecture
- [x] Firestore Rules sécurisées
- [x] Schéma collections
- [x] Indexes optimisés

### Code Flutter
- [x] AuthService + UserRole enum
- [x] PermissionGuard
- [x] Constantes d'autorisation
- [ ] Configuration DI
- [ ] Intégration dans UI existante

### UI/UX
- [ ] Dialogs d'authentification
- [ ] Affichage conditionnel par rôle
- [ ] Messages d'erreur
- [ ] Flow d'inscription

### Tests
- [ ] Tests Firestore Rules
- [ ] Tests unitaires services
- [ ] Tests d'intégration
- [ ] Tests de sécurité

---

## 🆘 Besoin d'Aide ?

1. **Architecture générale** → `BACKEND_RBAC_ARCHITECTURE.md`
2. **Structure base de données** → `FIRESTORE_SCHEMA.md`
3. **Comment intégrer** → `BACKEND_INTEGRATION_GUIDE.md`
4. **Vue d'ensemble** → `BACKEND_STRUCTURE_SUMMARY.md`

---

## 🚀 Prochaines Étapes

1. Déployer les règles: `firebase deploy --only firestore`
2. Configurer le DI dans `main.dart`
3. Intégrer les guards dans l'UI existante
4. Tester avec Firebase Emulator
5. Implémenter les Cloud Functions pour compteurs

---

**Tout est prêt ! Le backend est structuré, sécurisé et prêt à scaler.** 🎉
