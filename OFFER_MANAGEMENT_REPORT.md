# 📦 Pages de Gestion d'Offres - Rapport d'Implémentation

## ✅ Pages Créées

### 1. **Page "Mes Offres"** (`my_offers_page.dart`)
**Chemin**: `lib/features/organizer_offers/presentation/pages/my_offers_page.dart`
**Lignes**: ~350

#### Fonctionnalités
- **Liste des offres** de l'organisateur avec cartes détaillées
- **Filtres par status** (Toutes, Publiées, Brouillons, En pause)
- **Stats rapides** en haut : Total, Publiées, Brouillons, En pause
- **Pull-to-refresh** pour recharger les offres
- **État vide** avec message contextualisé selon le filtre
- **FAB** pour créer une nouvelle offre rapidement

#### Interface
```
┌─────────────────────────────────────┐
│ ← Mes Offres                    🔍 │
├─────────────────────────────────────┤
│ ┌──────────────────────────────┐  │
│ │  Total: 6  Publiées: 3       │  │
│ │  Brouillons: 2  En pause: 1  │  │
│ └──────────────────────────────┘  │
├─────────────────────────────────────┤
│ [Toutes] [Publiées] [Brouillons]  │
├─────────────────────────────────────┤
│ ┌─ MyOfferCard ─────────────────┐ │
│ │ [Image 16:9]                  │ │
│ │ 🎉 Event    5000 XOF          │ │
│ │ Festival Jazz Porto-Novo      │ │
│ │ 👁️ 1245  ❤️ 234  🎟️ 266      │ │
│ │ [Éditer] [Pause] [⋮]          │ │
│ └───────────────────────────────┘ │
│                                     │
│             [+ Nouvelle offre]      │
└─────────────────────────────────────┘
```

---

### 2. **Widget "Carte Offre"** (`my_offer_card.dart`)
**Chemin**: `lib/features/organizer_offers/presentation/widgets/my_offer_card.dart`
**Lignes**: ~510

#### Éléments de la Carte
1. **Image 16:9** avec gestion d'erreur
2. **Badge status** (Publiée/Brouillon/Pause/Complet)
3. **Badge boost** si offre boostée (⚡)
4. **Category badge** avec icône
5. **Prix** affiché en grand
6. **Titre** (max 2 lignes)
7. **Stats** : vues, likes, réservations
8. **Boutons actions** :
   - Éditer (outline)
   - Publier/Pause (elevated)
   - Menu ⋮ (options)

#### Menu Options (Bottom Sheet)
- **Booster l'offre** (si publiée) → Affiche dialog avec 3 options boost
- **Voir les statistiques** → Analytics détaillés
- **Dupliquer l'offre** → Créer copie
- **Supprimer** → Dialog confirmation

---

### 3. **Page "Créer/Éditer Offre"** (`create_offer_page.dart`)
**Chemin**: `lib/features/organizer_offers/presentation/pages/create_offer_page.dart`
**Lignes**: ~980

#### Formulaire Multi-Étapes (4 étapes)

##### **Étape 1 : Catégorie**
- Sélection de la catégorie (Event, Tour, Accommodation, Transport, Site)
- Cartes avec icône, nom, description
- Sélection visuelle (bordure bleue + checkmark)

##### **Étape 2 : Informations de Base**
- **Titre** (max 80 caractères)
- **Description** (max 1000 caractères, 6 lignes)
- **Lieu** avec icône localisation
- **Photos** : picker horizontal avec preview, bouton +, bouton X pour supprimer

##### **Étape 3 : Détails Spécifiques**
Champs dynamiques selon la catégorie :
- **Event/Tour** :
  - Date picker (calendrier)
  - Capacité maximale (nombre)
- **Accommodation** :
  - Équipements (chips sélectionnables : WiFi, Piscine, Parking, etc.)
- **Transport** :
  - Type de véhicule (text input)

##### **Étape 4 : Tarification**
- **Prix minimum** (requis)
- **Prix maximum** (optionnel)
- **Info commission** : 8% prélevé sur chaque réservation
- **Résumé** : affiche tous les champs remplis

#### Navigation
- **Progress bar** en haut (4 barres)
- **Bouton Retour** (si pas étape 1)
- **Bouton Suivant** (désactivé si champs requis vides)
- **Bouton Publier** (étape 4) + **Enregistrer brouillon**
- **X pour quitter** avec confirmation si données saisies

#### Interface Étape 1 (Catégorie)
```
┌─────────────────────────────────────┐
│ ✕  Nouvelle offre          Retour  │
├─────────────────────────────────────┤
│ [▓▓▓▓][    ][    ][    ]           │ Progress
├─────────────────────────────────────┤
│ Quel type d'offre proposez-vous ?  │
│ Choisissez la catégorie...         │
│                                     │
│ ┌─────────────────────────────────┐│
│ │ 🎉  Événement                   ││
│ │     Concerts, festivals...    ✓ ││
│ └─────────────────────────────────┘│
│ ┌─────────────────────────────────┐│
│ │ 🗺️  Visite guidée               ││
│ │     Tours, excursions...        ││
│ └─────────────────────────────────┘│
│                                     │
├─────────────────────────────────────┤
│              [Suivant]              │
└─────────────────────────────────────┘
```

#### Interface Étape 4 (Tarification)
```
┌─────────────────────────────────────┐
│ ✕  Nouvelle offre          Retour  │
├─────────────────────────────────────┤
│ [▓▓▓▓][▓▓▓▓][▓▓▓▓][▓▓▓▓]           │
├─────────────────────────────────────┤
│ Tarification                        │
│                                     │
│ Prix minimum    Prix maximum        │
│ [5000] XOF      [15000] XOF         │
│                                     │
│ ┌─────────────────────────────────┐│
│ │ ℹ️  Commission de 8% prélevée   ││
│ │    sur chaque réservation       ││
│ └─────────────────────────────────┘│
│                                     │
│ Résumé                              │
│ Catégorie    Événement              │
│ Titre        Festival Jazz...       │
│ Lieu         Porto-Novo             │
│ Prix         5000 - 15000 XOF       │
│ Photos       3                      │
│                                     │
├─────────────────────────────────────┤
│ [Brouillon]  [Publier l'offre]     │
└─────────────────────────────────────┘
```

---

## 🔗 Intégrations

### Dashboard Organisateur
**Fichier modifié**: `lib/features/organizer_dashboard/presentation/pages/organizer_dashboard_page.dart`

**Changements "Actions rapides"** :
- ✅ **Nouvelle offre** → Navigation vers CreateOfferPage
- ✅ **Mes offres** → Navigation vers MyOffersPage (NOUVEAU)
- Analytics (placeholder)
- Scanner ticket (placeholder)

**Code ajouté** :
```dart
import '../../../organizer_offers/presentation/pages/my_offers_page.dart';
import '../../../organizer_offers/presentation/pages/create_offer_page.dart';

// Dans _buildQuickActions:
_quickActionChip(
  icon: Icons.inventory_2_outlined,
  label: 'Mes offres',
  onTap: () {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => MyOffersPage(organizerId: organizer.id),
    ));
  },
),
```

---

## 📊 Données Mock

### Offres Affichées
Les offres sont filtrées par `organizerId` depuis `MockDataB2B2C.mockOffers`.

**Offres de l'organisateur `org_001`** (demo) :
1. Festival de Jazz Porto-Novo (event, boosté, publié)
2. Concert Angélique Kidjo (event, sold out)

**Pour tester** avec plus d'offres, ajouter dans `mock_data_b2b2c.dart` :
```dart
Offer(
  id: '7',
  organizerId: 'org_001', // Important !
  category: OfferCategory.tour,
  title: 'Visite Palais Royal Abomey',
  status: 'draft', // brouillon
  // ...
),
```

---

## 🎨 Design System Respecté

### Couleurs
- **Primary Blue** (#2563EB) : boutons principaux, borders sélection
- **Accent Amber** (#F59E0B) : prix, boost badges
- **Green** (#10B981) : status "Publiée"
- **Red** (#DC2626) : status "Complet", bouton supprimer
- **Gray** (#475569) : status "Brouillon", "Pause"

### Espacement
- **Cards** : margin 16.h bottom
- **Padding interne** : 16.w
- **Spacing boutons** : 8.w/h
- **Border radius** : 12.r (cards), 8.r (buttons)

### Typography
- **Titles** : 24.sp, weight 700
- **Body** : 14-16.sp, weight 400-600
- **Captions** : 11-13.sp, weight 400

---

## 🧪 Tests de Compilation

**Commande** : `flutter analyze lib/features/organizer_offers/`
**Résultat** : ✅ 0 erreurs, 13 infos/warnings (style uniquement)

**Warnings restants** (non bloquants) :
- `_capacity`, `_vehicleType` : champs utilisés dans le formulaire mais pas encore sauvegardés (TODO backend)
- `withOpacity()` deprecated : suggestion Flutter d'utiliser `.withValues()` (cosmétique)
- `prefer_const_constructors` : optimisation mémoire (non critique)

---

## 🚀 Utilisation

### Créer une Offre
1. Dashboard → Cliquer "Nouvelle offre"
2. **Étape 1** : Sélectionner catégorie (ex: Événement)
3. **Étape 2** : Remplir titre, description, lieu, ajouter photos
4. **Étape 3** : Choisir date + capacité (si event)
5. **Étape 4** : Définir prix, voir résumé
6. Cliquer **"Publier l'offre"** ou **"Enregistrer brouillon"**

### Gérer les Offres
1. Dashboard → Cliquer "Mes offres"
2. Voir toutes les offres avec stats
3. Filtrer par status (tabs en haut)
4. Actions sur une offre :
   - **Éditer** : Ouvre formulaire pré-rempli
   - **Pause/Publier** : Toggle status
   - **Menu ⋮** : Boost, Analytics, Dupliquer, Supprimer

### Booster une Offre
1. Offre publiée → Menu ⋮ → "Booster l'offre"
2. Choisir type :
   - **Feed 7j** : 2000 XOF
   - **Guide 30j** : 5000 XOF
   - **Top expérience** : 10000 XOF
3. (TODO: Paiement Mobile Money/Stripe)

---

## 📝 Notes Techniques

### Pattern de Navigation
- **Push** pour créer/éditer : retour avec `.then(() => _loadOffers())` pour refresh
- **Paramètres** : organizerId passé en paramètre
- **Retour données** : via callback ou global state (BLoC à implémenter)

### Gestion d'État
- **StatefulWidget** pour liste avec Set<String> pour filters
- **Controllers** pour formulaire (TextEditingController)
- **setState** local (à migrer vers BLoC en prod)

### Validation
- `_canProceed()` vérifie champs requis avant passage étape suivante
- Bouton "Suivant" désactivé si validation échoue
- Toast/SnackBar pour feedback utilisateur

### Persistance (TODO Backend)
Actuellement mock local, à remplacer par :
```dart
// Repository pattern
class OfferRepository {
  Future<List<Offer>> getOrganizerOffers(String organizerId);
  Future<Offer> createOffer(Offer offer);
  Future<Offer> updateOffer(String id, Offer offer);
  Future<void> deleteOffer(String id);
  Future<void> toggleOfferStatus(String id, String newStatus);
}
```

---

## 🔄 Prochaines Étapes Recommandées

### Priorité HAUTE
1. **Image Picker** : Implémenter `image_picker` pour sélection photos
2. **Backend API** : Endpoints CRUD offres (POST, GET, PATCH, DELETE)
3. **Validation avancée** : Prix min < max, capacité > 0, etc.
4. **États de chargement** : Loading indicators, error handling

### Priorité MOYENNE
5. **Analytics page** : Graphiques détaillés par offre (vues/j, conversions)
6. **Boost payment** : Intégration Mobile Money pour campagnes boost
7. **Dupliquer offre** : Copier offre existante avec nouveaux IDs
8. **Filtres avancés** : Par catégorie, plage de dates, prix

### Priorité BASSE
9. **Export CSV** : Exporter liste offres
10. **Recherche offres** : SearchBar dans "Mes Offres"
11. **Tri** : Par date création, vues, bookings
12. **Archive** : Archiver offres anciennes au lieu de supprimer

---

## 📦 Structure de Fichiers Créée

```
lib/features/organizer_offers/
├── presentation/
│   ├── pages/
│   │   ├── my_offers_page.dart        (350 lignes)
│   │   └── create_offer_page.dart     (980 lignes)
│   └── widgets/
│       └── my_offer_card.dart         (510 lignes)
│
└── (À créer en prod)
    ├── data/
    │   ├── repositories/
    │   │   └── offer_repository.dart
    │   └── datasources/
    │       └── offer_remote_datasource.dart
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    │       ├── create_offer.dart
    │       ├── update_offer.dart
    │       ├── delete_offer.dart
    │       └── get_offers.dart
    └── presentation/
        └── blocs/
            └── offer_bloc.dart
```

**Total lignes ajoutées** : ~1840 lignes

---

**Créé le** : ${DateTime.now().toIso8601String()}
**Version** : Flutter 3.0+
**Status** : ✅ Prêt pour démo (mock data)
**TODO** : Backend integration, Image picker, BLoC state management
