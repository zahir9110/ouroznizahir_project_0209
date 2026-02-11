# 📚 Index Documentation Backend Bōken

Bienvenue dans la documentation complète de l'architecture backend RBAC de Bōken !

---

## 🚀 Démarrage Rapide

**Pour commencer immédiatement** → [BACKEND_README.md](./BACKEND_README.md)

Quick Start en 5 minutes avec les étapes essentielles pour déployer et intégrer le backend.

---

## 📖 Documentation Complète

### 1️⃣ Architecture & Vision Produit
📄 **[BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md)**

**Ce que vous y trouverez:**
- Vision produit détaillée (Guest → User → Organizer)
- Tableau récapitulatif des permissions par rôle
- Structure complète des 11 collections Firestore
- Règles de sécurité Firestore expliquées
- Exemples d'implémentation Flutter
- Services AuthService et PermissionGuard

**Quand le consulter:**
- Comprendre la logique métier complète
- Référence pour les règles d'autorisation
- Architecture des collections Firestore

---

### 2️⃣ Base de Données
📄 **[FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)**

**Ce que vous y trouverez:**
- Structure détaillée de chaque collection (11 collections)
- Tous les champs avec types TypeScript
- Indexes composites requis (25+ indexes)
- Règles de validation et contraintes
- Notes sur la dénormalisation
- Exemples de queries optimisées

**Quand le consulter:**
- Créer une nouvelle collection ou document
- Comprendre les relations entre collections
- Configurer les indexes Firestore
- Optimiser les performances des queries

---

### 3️⃣ Guide d'Intégration Pratique
📄 **[BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md)**

**Ce que vous y trouverez:**
- Patterns d'utilisation concrets
- 5 exemples de code Flutter commentés
- Configuration DI (Dependency Injection)
- Guards dans la navigation
- Contraintes d'unicité (ratings, likes, favorites)
- Tests et validation
- Points d'attention critiques

**Quand le consulter:**
- Intégrer les guards dans l'UI
- Implémenter une nouvelle fonctionnalité
- Résoudre un problème de permissions
- Ajouter des vérifications d'autorisation

---

### 4️⃣ Résumé Complet
📄 **[BACKEND_STRUCTURE_SUMMARY.md](./BACKEND_STRUCTURE_SUMMARY.md)**

**Ce que vous y trouverez:**
- Liste de tous les fichiers créés
- Vision d'ensemble de l'architecture
- Relations entre documents
- Exemples rapides (snippets)
- Checklist de migration complète
- Références et support

**Quand le consulter:**
- Vue d'ensemble du système complet
- Retrouver rapidement un fichier
- Comprendre les relations entre composants
- Suivi de l'avancement de la migration

---

### 5️⃣ Diagrammes Visuels
📄 **[BACKEND_DIAGRAMS.md](./BACKEND_DIAGRAMS.md)**

**Ce que vous y trouverez:**
- 9 diagrammes ASCII détaillés
- Hiérarchie des rôles (Guest → User → Organizer)
- Flux d'autorisation (Client → Firestore Rules)
- Schéma des collections avec relations
- Cycle de vie d'une action (exemple: Like)
- Matrice de permissions détaillée
- Flow d'inscription
- Contraintes d'unicité
- Architecture globale

**Quand le consulter:**
- Comprendre visuellement l'architecture
- Expliquer le système à d'autres développeurs
- Debugger un flow complexe
- Présenter l'architecture

---

## 🗂️ Structure des Fichiers Créés

```
benin_experience/
│
├── 📄 BACKEND_README.md                    ← COMMENCEZ ICI
├── 📄 BACKEND_INDEX.md                     ← Ce fichier
├── 📄 BACKEND_RBAC_ARCHITECTURE.md         ← Architecture complète
├── 📄 FIRESTORE_SCHEMA.md                  ← Schéma BDD
├── 📄 BACKEND_INTEGRATION_GUIDE.md         ← Guide pratique
├── 📄 BACKEND_STRUCTURE_SUMMARY.md         ← Résumé + checklist
├── 📄 BACKEND_DIAGRAMS.md                  ← Diagrammes visuels
│
├── 🔒 firestore.rules                      ← Règles de sécurité
├── 🔒 firestore.indexes.json               ← Indexes composites
│
└── lib/
    └── core/
        ├── services/
        │   └── 🔧 auth_service.dart        ← Auth + UserRole enum
        │
        ├── utils/
        │   └── 🔧 permission_guard.dart    ← Guards de permissions
        │
        └── constants/
            └── 🔧 auth_constants.dart      ← Toutes les constantes
```

---

## 🎯 Navigation Rapide par Besoin

### Je veux...

#### Démarrer rapidement
→ [BACKEND_README.md](./BACKEND_README.md)

#### Comprendre la vision produit
→ [BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md) (Section Vision)

#### Voir la structure de la base de données
→ [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)

#### Savoir quelles permissions a chaque rôle
→ [BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md) (Section Tableau Récapitulatif)

#### Intégrer dans mon code Flutter
→ [BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md)

#### Comprendre visuellement l'architecture
→ [BACKEND_DIAGRAMS.md](./BACKEND_DIAGRAMS.md)

#### Voir des exemples de code
→ [BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md) (Section Patterns)

#### Déployer sur Firebase
→ [BACKEND_README.md](./BACKEND_README.md) (Section Quick Start)

#### Créer une nouvelle collection
→ [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md)

#### Ajouter une permission
→ [BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md) + [firestore.rules](./firestore.rules)

#### Tester les règles Firestore
→ [BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md) (Section Tests)

#### Voir l'avancement de la migration
→ [BACKEND_STRUCTURE_SUMMARY.md](./BACKEND_STRUCTURE_SUMMARY.md) (Section Checklist)

---

## 🔑 Concepts Clés

### Les 3 Rôles
- **GUEST** = Non inscrit, lecture seule
- **USER** = Inscrit, peut interagir
- **ORGANIZER** = PRO, peut publier offres

### Sécurité Double-Couche
1. **Client (PermissionGuard)** → UX, feedback utilisateur
2. **Serveur (Firestore Rules)** → Sécurité réelle, inviolable

### Dénormalisation
Dupliquer les données fréquemment lues pour performances
Exemple: `userName` et `userPhoto` dans les reviews

### Contraintes d'Unicité
Gérées côté application (Firestore ne les supporte pas nativement)
Exemples: 1 rating par user/place, 1 like par user/target

---

## 📊 Chiffres Clés

- **3 rôles** utilisateur (Guest, User, Organizer)
- **11 collections** Firestore
- **25+ indexes** composites
- **6 fichiers** de documentation
- **3 fichiers** de code Flutter
- **2 fichiers** de configuration Firebase
- **100%** couverture des règles de sécurité

---

## ✅ Checklist d'Implémentation

Pour suivre votre progression, consultez:
→ [BACKEND_STRUCTURE_SUMMARY.md](./BACKEND_STRUCTURE_SUMMARY.md) (Section Checklist)

---

## 🆘 Besoin d'Aide ?

### Par Type de Question

| Question | Document à consulter |
|----------|---------------------|
| Comment ça marche globalement ? | [BACKEND_DIAGRAMS.md](./BACKEND_DIAGRAMS.md) |
| Quel est le schéma de la collection X ? | [FIRESTORE_SCHEMA.md](./FIRESTORE_SCHEMA.md) |
| Comment vérifier si un user peut faire Y ? | [BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md) |
| Quelles sont les permissions de chaque rôle ? | [BACKEND_RBAC_ARCHITECTURE.md](./BACKEND_RBAC_ARCHITECTURE.md) |
| Par où commencer ? | [BACKEND_README.md](./BACKEND_README.md) |
| Comment déployer ? | [BACKEND_README.md](./BACKEND_README.md) |
| Où sont les exemples de code ? | [BACKEND_INTEGRATION_GUIDE.md](./BACKEND_INTEGRATION_GUIDE.md) |

---

## 🎓 Pour Aller Plus Loin

### Documentation Externe
- [Firebase Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firestore Best Practices](https://firebase.google.com/docs/firestore/best-practices)
- [Flutter Firebase](https://firebase.flutter.dev/)

### Prochaines Implémentations
1. Cloud Functions pour compteurs dénormalisés
2. Tests automatisés des règles Firestore
3. Dashboard admin pour modération
4. Analytics avancés par rôle
5. Système de notifications

---

**📖 Commencez par:** [BACKEND_README.md](./BACKEND_README.md)

**🎉 L'architecture est complète, structurée et prête pour la production !**
