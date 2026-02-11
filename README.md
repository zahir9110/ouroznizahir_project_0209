# 🎯 Bōken - Plateforme B2B2C de Tourisme & Billetterie

**Les voyageurs sont l'audience. Les organisateurs sont les clients.**

Bōken est une application mobile (Flutter) qui connecte les voyageurs avec des expériences culturelles et touristiques, tout en offrant aux organisateurs une plateforme complète pour vendre des billets et gérer leur activité.

---

## 🚀 Concept

### Vision
Bōken révolutionne le tourisme en Afrique en permettant aux organisateurs locaux de:
- Publier des offres (événements, visites, hébergements, transports)
- Vendre des billets directement via l'app
- Gérer leur business avec un dashboard pro
- Toucher une audience locale et internationale

### Modèle Business
```
🎯 Organisateur vend un billet
    ↓
💰 Bōken prend une commission (8%)
    ↓
📊 Organisateur reçoit son payout
    ↓
🔄 Cycle vertueux
```

---

## 🎨 Features Principales

### Pour les Voyageurs (Audience)
- ✅ Feed social d'événements & expériences
- ✅ Réservation/Achat de billets en un clic
- ✅ Paiement Mobile Money & Carte
- ✅ Tickets QR code
- ✅ Avis & notes après expérience
- ✅ Guide local par région
- ✅ Profils organisateurs vérifiés

### Pour les Organisateurs (Clients B2B)
- 🎯 Compte PRO avec badge vérifié
- 📊 Dashboard avec statistiques
- 💰 Revenus & payouts tracking
- 🎟️ Gestion des offres & billets
- 🚀 Boost de visibilité (monetization)
- 📈 Analytics détaillées
- ⭐ Réputation & avis clients

---

## 🏗️ Architecture Technique

### Frontend
```yaml
Framework: Flutter (iOS + Android)
Architecture: Clean Architecture
State Management: flutter_bloc
Navigation: go_router (à venir)
Responsive: flutter_screenutil
```

### Backend (En développement)
```yaml
API: NestJS (Node.js + TypeScript)
Database: PostgreSQL + Firestore (hybride)
Auth: Firebase Auth + JWT
Storage: Firebase Storage
Payment: Mobile Money API + Stripe
Real-time: Firestore + WebSocket
```

### Infrastructure
```yaml
Hosting: Cloud Run / Railway
Database: Supabase / Cloud SQL
CDN: CloudFlare
Admin: Retool / Custom Panel
Analytics: Mixpanel + Firebase Analytics
```

---

## 📦 Installation & Setup

### Prérequis
- Flutter SDK >=3.0.0
- Dart SDK >=3.0.0
- Firebase CLI (pour Firebase)
- Android Studio / Xcode
- Un compte Firebase actif

### Installation

```bash
# Clone le projet
git clone https://github.com/your-org/benin_experience.git
cd benin_experience

# Installer les dépendances
flutter pub get

# Configurer Firebase
flutterfire configure

# Lancer l'app
flutter run
```

### Variables d'environnement

Créer un fichier `.env` (non commité) :
```env
API_BASE_URL=https://api.boken.app
MOBILE_MONEY_API_KEY=xxx
STRIPE_PUBLISHABLE_KEY=pk_xxx
```

---

## 📱 Captures d'écran

```
┌─────────────────────────────────────┐
│  Bōken              🔔 💬          │  ← AppBar
├─────────────────────────────────────┤
│                                     │
│  [Stories →→→→→→→→→→→→→→]          │  ← Stories bar
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 📷 Event Image                │ │
│  │                               │ │
│  │                               │ │
│  └───────────────────────────────┘ │
│  ✓ Organisateur Vérifié  ⭐ 4.8   │
│  Festival de Jazz - Cotonou       │
│  📍 Cotonou  📅 15 Fév 2026       │
│  💰 5000 XOF                      │
│  [Acheter le billet] 🔵           │
│  ───────────────────────────────  │
│                                     │
│  ┌───────────────────────────────┐ │
│  │ 📷 Tour Image                 │ │
│  └───────────────────────────────┘ │
│  ...                                │
└─────────────────────────────────────┘
```

---

## 🗂️ Structure du Projet

```
lib/
├── main.dart
├── core/
│   ├── constants/
│   ├── di/
│   ├── theme/
│   ├── widgets/
│   ├── models/
│   │   ├── user.dart
│   │   ├── organizer.dart
│   │   ├── offer.dart
│   │   ├── booking.dart
│   │   └── user_type.dart
│   └── utils/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── organizer_dashboard/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── dashboard_home_page.dart
│   │       │   ├── earnings_page.dart
│   │       │   └── analytics_page.dart
│   │       └── widgets/
│   │
│   ├── offers/
│   ├── bookings/
│   ├── payments/
│   ├── feed/
│   └── profile/
```

---

## 🎯 Roadmap

### Phase 1 - MVP (Mois 1-2)
- [x] Setup projet Flutter
- [x] Design system
- [x] Auth system
- [ ] Backend API (NestJS)
- [ ] Organizer registration
- [ ] Create/manage offers
- [ ] Booking system
- [ ] Payment Mobile Money

### Phase 2 - Monetization (Mois 3-4)
- [ ] Dashboard organisateur
- [ ] Analytics & stats
- [ ] Commission tracking
- [ ] Payout system
- [ ] Boost campaigns
- [ ] Reviews & ratings

### Phase 3 - Growth (Mois 5-6)
- [ ] Admin panel
- [ ] Advanced search
- [ ] Push notifications
- [ ] In-app chat
- [ ] Stories (Instagram-like)
- [ ] App stores launch

Voir [ROADMAP.md](./ROADMAP.md) pour détails complets.

---

## 💰 Modèle de Revenus

### Commission (Phase 1)
- **8%** par billet vendu
- Inscription organisateur: **Gratuite**
- Payout: **Hebdomadaire** (min 5000 XOF)

### Boost (Phase 2)
- Feed boost: **2000 XOF / 7 jours**
- Guide local: **5000 XOF / 30 jours**
- Badge "Top": **10000 XOF / événement**

### Abonnements (Phase 3)
| Tier | Prix | Commission | Features |
|------|------|------------|----------|
| **Free** | 0 XOF | 8% | Basic stats |
| **Plus** | 15000 XOF/mois | 5% | Stats avancées + 1 boost |
| **Enterprise** | Sur devis | 3% | API + White label |

---

## 🛠️ Technologies Utilisées

### Flutter Dependencies
```yaml
flutter_bloc: ^8.1.6          # State management
flutter_screenutil: ^5.9.0    # Responsive UI
google_fonts: ^6.3.3          # Typography
dio: ^5.4.0                   # HTTP client
get_it: ^7.7.0                # Dependency injection
firebase_core: ^2.32.0        # Firebase
firebase_auth: ^4.16.0        # Authentication
cloud_firestore: ^4.17.5      # Database
firebase_storage: ^11.7.7     # Media storage
shared_preferences: ^2.2.2    # Local storage
flutter_secure_storage: ^9.2.4 # Secure storage
```

### Backend Stack
- **NestJS** - Framework Node.js
- **PostgreSQL** - Base de données relationnelle
- **Prisma** - ORM
- **Firebase** - Auth & Storage
- **Stripe** - Paiements cartes
- **Mobile Money APIs** - Paiements locaux

---

## 📊 Métriques de Succès

### KPIs Business
- **GMV** (Gross Merchandise Value)
- **Commission revenue** mensuel
- **Boost revenue** mensuel
- **Nombre d'organisateurs actifs**
- **Taux de conversion** (vue → booking)

### KPIs Produit
- **DAU/MAU** (Daily/Monthly Active Users)
- **Retention** (D1, D7, D30)
- **Bookings** par utilisateur
- **Valeur moyenne** d'un booking
- **NPS** (Net Promoter Score)

---

## 🤝 Contribution

Les contributions sont les bienvenues !

1. Fork le projet
2. Créer une branche (`git checkout -b feature/amazing-feature`)
3. Commit (`git commit -m 'Add amazing feature'`)
4. Push (`git push origin feature/amazing-feature`)
5. Ouvrir une Pull Request

---

## 📄 Documentation

- [Architecture B2B2C complète](./BOKEN_B2B2C_ARCHITECTURE.md)
- [Roadmap détaillée](./ROADMAP.md)
- [Design System](./DESIGN_SYSTEM.md)
- [AI Architecture](./AI_ARCHITECTURE.md)
- [Stories Architecture](./STORIES_ARCHITECTURE.md)

---

## 📝 License

Ce projet est sous licence MIT - voir [LICENSE](./LICENSE) pour détails.

---

## 👥 Équipe

**Maintenu par**: Kevin Houndeton  
**Contact**: [Email](mailto:contact@boken.app)  
**Twitter**: [@BokenApp](https://twitter.com/BokenApp)

---

## 🌍 Vision

Bōken a pour ambition de devenir **la plateforme #1 de tourisme et billetterie en Afrique**, en permettant aux organisateurs locaux de prospérer tout en offrant aux voyageurs des expériences authentiques et mémorables.

**Afrique d'abord. Monde ensuite.**

---

Made with ❤️ in Benin 🇧🇯
