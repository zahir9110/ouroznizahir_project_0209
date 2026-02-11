# 🎨 Guide d'utilisation - Benin Experience Design System

## 🚀 Quick Start

### 1. Tester le design system

Pour voir le design system en action :

```bash
# Lancer l'app de démo
flutter run lib/main_design_demo.dart
```

### 2. Importer le design system dans votre code

```dart
// Thème
import 'package:benin_experience/core/theme/be_theme.dart';
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';

// Widgets
import 'package:benin_experience/core/widgets/be_event_card.dart';
import 'package:benin_experience/core/widgets/be_story_ring.dart';
import 'package:benin_experience/core/widgets/be_ticket_card.dart';
import 'package:benin_experience/core/widgets/be_button.dart';
import 'package:benin_experience/core/widgets/be_bottom_nav.dart';
```

---

## 📦 Composants disponibles

### 1️⃣ BEEventCard - Card événement

```dart
BEEventCard(
  imageUrl: 'https://...',
  title: 'Festival Jazz de Ouidah',
  location: 'Ouidah, Atlantique',
  date: DateTime.now().add(Duration(days: 7)),
  likes: 124,
  comments: 18,
  isLiked: false,
  organizerName: 'Festival Ouidah',
  organizerAvatar: 'https://...',
  onTap: () => print('Card tapped'),
  onLike: () => print('Liked'),
  onComment: () => print('Comment'),
  onShare: () => print('Shared'),
)
```

**Props :**
- `imageUrl` (required) : URL de l'image événement
- `title` (required) : Titre de l'événement
- `location` (required) : Lieu de l'événement
- `date` (required) : Date de l'événement
- `likes` : Nombre de likes (default: 0)
- `comments` : Nombre de commentaires (default: 0)
- `isLiked` : Si l'utilisateur a liké (default: false)
- `organizerName` : Nom de l'organisateur
- `organizerAvatar` : Avatar de l'organisateur
- `onTap`, `onLike`, `onComment`, `onShare` : Callbacks

---

### 2️⃣ BEStoryRing - Cercle story

```dart
BEStoryRing(
  imageUrl: 'https://...',
  label: 'Festival Jazz',
  viewed: false,
  isPremium: false,
  hasNewStory: true,
  onTap: () => print('Story tapped'),
)
```

**Props :**
- `imageUrl` (required) : URL de la photo
- `label` (required) : Label sous le cercle
- `viewed` : Si la story a été vue (default: false)
- `isPremium` : Story premium avec gradient violet (default: false)
- `hasNewStory` : Si nouvelle story disponible (default: true)
- `onTap` : Callback

**BEStoriesFeedBar - Barre de stories**

```dart
BEStoriesFeedBar(
  stories: [
    StoryData(
      imageUrl: 'https://...',
      label: 'Festival',
      viewed: false,
      onTap: () {},
    ),
    // ... autres stories
  ],
)
```

---

### 3️⃣ BETicketCard - Card billet

```dart
BETicketCard(
  eventTitle: 'Concert Angélique Kidjo',
  location: 'Stade de l\'Amitié, Cotonou',
  date: DateTime(2024, 3, 28),
  price: 15000,
  currency: 'FCFA',
  isForSale: true,
  isSold: false,
  qrCodeUrl: 'https://...',
  sellerName: 'Jean-Pierre K.',
  category: 'VIP',
  onBuyTap: () => print('Buy'),
  onContactTap: () => print('Contact'),
  onTap: () => print('Card tapped'),
)
```

**Props :**
- `eventTitle` (required) : Titre de l'événement
- `location` (required) : Lieu
- `date` (required) : Date
- `price` (required) : Prix du billet
- `currency` : Devise (default: 'FCFA')
- `isForSale` : Si le billet est à vendre (default: true)
- `isSold` : Si le billet est vendu (default: false)
- `qrCodeUrl` : URL du QR code
- `sellerName` : Nom du vendeur
- `category` : Catégorie (VIP, Standard, etc.)
- `onBuyTap`, `onContactTap`, `onTap` : Callbacks

---

### 4️⃣ BEButton - Boutons

```dart
// Bouton primary
BEButton.primary(
  label: 'Acheter',
  onTap: () {},
  icon: Icons.shopping_cart,
  size: BEButtonSize.medium,
  fullWidth: true,
  loading: false,
)

// Bouton secondary
BEButton.secondary(
  label: 'Annuler',
  onTap: () {},
)

// Bouton text
BEButton.text(
  label: 'En savoir plus',
  onTap: () {},
)
```

**Props :**
- `label` (required) : Texte du bouton
- `onTap` : Callback
- `type` : primary / secondary / text
- `size` : small / medium / large
- `icon` : Icône optionnelle
- `loading` : État chargement (default: false)
- `fullWidth` : Pleine largeur (default: false)

---

### 5️⃣ BEBottomNav - Bottom Navigation

```dart
BEBottomNav(
  currentIndex: _currentIndex,
  onTap: (index) => setState(() => _currentIndex = index),
  items: [
    BEBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Accueil',
      badgeCount: 0,
    ),
    // ... autres items
  ],
)
```

**Props :**
- `currentIndex` (required) : Index actif
- `onTap` (required) : Callback avec index
- `items` (required) : Liste des items

**BEBottomNavItem :**
- `icon` (required) : Icône inactive
- `activeIcon` : Icône active (optionnelle)
- `label` (required) : Label (visible si actif)
- `badgeCount` : Badge notification

---

## 🎨 Utiliser les couleurs

```dart
// Couleurs principales
Container(color: BEColors.primary)     // #0F172A (bleu nuit)
Container(color: BEColors.action)      // #2563EB (bleu vivant)
Container(color: BEColors.accent)      // #F59E0B (or)

// Backgrounds
Container(color: BEColors.background)  // #FFFFFF
Container(color: BEColors.surface)     // #F8FAFC

// Texte
Text('Hello', style: TextStyle(color: BEColors.textPrimary))    // #020617
Text('Hello', style: TextStyle(color: BEColors.textSecondary))  // #475569
Text('Hello', style: TextStyle(color: BEColors.textTertiary))   // #94A3B8

// Status
Container(color: BEColors.success)           // Vert validation
Container(color: BEColors.error)             // Rouge erreur
Container(color: BEColors.statusForSale)     // Or (à vendre)
Container(color: BEColors.notification)      // Rouge notification

// Gradients
Container(
  decoration: BoxDecoration(
    gradient: BEColors.storyGradient,  // Bleu → Or
  ),
)
```

---

## ✍🏽 Utiliser la typographie

```dart
// Display (titres majeurs)
Text('Benin Experience', style: BETypography.display())

// Title (sous-titres, cards)
Text('Festival Jazz', style: BETypography.title())
Text('Sous-section', style: BETypography.titleMedium())

// Body (contenu principal)
Text('Description...', style: BETypography.body())
Text('Texte accentué', style: BETypography.bodyMedium())
Text('Emphasis', style: BETypography.bodySemibold())

// Caption (metadata, timestamps)
Text('Il y a 2h', style: BETypography.caption())
Text('Metadata', style: BETypography.captionMedium())

// Label (boutons)
Text('ACHETER', style: BETypography.label())
Text('Tag', style: BETypography.overline())

// Avec couleur custom
Text('Custom', style: BETypography.title(color: BEColors.accent))
```

---

## 📏 Utiliser le spacing

```dart
// Padding
Padding(padding: EdgeInsets.all(BESpacing.lg))          // 16px
Padding(padding: EdgeInsets.symmetric(
  horizontal: BESpacing.screenHorizontal,                // 16px
  vertical: BESpacing.screenVertical,                    // 24px
))

// Gaps
SizedBox(height: BESpacing.md)  // 12px
SizedBox(width: BESpacing.sm)   // 8px

// Border radius
BorderRadius.circular(BESpacing.radiusLg)   // 16px
BorderRadius.circular(BESpacing.radiusMd)   // 12px
BorderRadius.circular(BESpacing.radiusSm)   // 8px

// Sizes
Icon(Icons.home, size: BESpacing.iconLg)         // 24px
CircleAvatar(radius: BESpacing.avatarMd / 2)     // 40px
Container(height: BESpacing.buttonMedium)        // 44px

// Story
Container(
  width: BESpacing.storySize,        // 64px
  height: BESpacing.storySize,
)
```

---

## 🎭 Appliquer le thème

### Dans MaterialApp

```dart
MaterialApp(
  theme: BETheme.light,
  darkTheme: BETheme.dark,  // Future
  home: MyHomePage(),
)
```

### Shadows

```dart
// Card shadow
Container(
  decoration: BoxDecoration(
    boxShadow: BETheme.cardShadow,
  ),
)

// Elevated shadow (modals)
Container(
  decoration: BoxDecoration(
    boxShadow: BETheme.elevatedShadow,
  ),
)

// Bottom nav shadow
Container(
  decoration: BoxDecoration(
    boxShadow: BETheme.bottomNavShadow,
  ),
)
```

---

## 🖼️ Images

### Avec CachedNetworkImage

```dart
import 'package:cached_network_image/cached_network_image.dart';

CachedNetworkImage(
  imageUrl: 'https://...',
  fit: BoxFit.cover,
  placeholder: (context, url) => Container(
    color: BEColors.surface,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  ),
  errorWidget: (context, url, error) => Container(
    color: BEColors.surface,
    child: Icon(
      Icons.image_not_supported_outlined,
      color: BEColors.textTertiary,
    ),
  ),
)
```

---

## 🎬 Animations

### Scale animation (tap feedback)

```dart
GestureDetector(
  onTapDown: (_) => setState(() => _scale = 0.97),
  onTapUp: (_) => setState(() => _scale = 1.0),
  onTapCancel: () => setState(() => _scale = 1.0),
  child: AnimatedScale(
    scale: _scale,
    duration: Duration(milliseconds: 100),
    child: YourWidget(),
  ),
)
```

### Page transitions

```dart
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      
      var tween = Tween(begin: begin, end: end)
        .chain(CurveTween(curve: curve));
      
      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 250),
  ),
);
```

---

## 📱 Exemple complet : Feed Page

```dart
class MyFeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BEColors.background,
      appBar: AppBar(
        title: Text('Benin Experience'),
      ),
      body: CustomScrollView(
        slivers: [
          // Stories bar
          SliverToBoxAdapter(
            child: BEStoriesFeedBar(
              stories: _getStories(),
            ),
          ),
          
          // Divider
          SliverToBoxAdapter(child: Divider()),
          
          // Feed items
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index % 3 == 0) {
                  return BETicketCard(...);
                } else {
                  return BEEventCard(...);
                }
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Bonnes pratiques

### ✅ À faire

- Utiliser `BEColors` pour TOUTES les couleurs
- Utiliser `BETypography` pour TOUS les textes
- Utiliser `BESpacing` pour TOUS les espacements
- Lazy loading avec `CachedNetworkImage`
- Max 2 couleurs fortes par écran
- Animations courtes (< 300ms)

### ❌ À éviter

- Couleurs hard-codées : `Color(0xFF...)` ❌
- Tailles en dur : `fontSize: 14` ❌
- Animations longues : `Duration(seconds: 1)` ❌
- Images non optimisées
- Trop de couleurs vives à l'écran

---

## 🔧 Configuration requise

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  cached_network_image: ^3.3.1
  flutter_screenutil: ^5.9.0
```

### Imports essentiels

```dart
// Dans chaque page
import 'package:benin_experience/core/theme/be_colors.dart';
import 'package:benin_experience/core/theme/be_typography.dart';
import 'package:benin_experience/core/theme/be_spacing.dart';
```

---

## 📚 Documentation complète

Pour plus de détails, consultez :
- **DESIGN_SYSTEM.md** : Spécifications complètes
- **lib/core/theme/** : Code source des thèmes
- **lib/core/widgets/** : Code source des composants
- **lib/main_design_demo.dart** : App de démonstration

---

## 🎨 Figma & Design

Pour créer des maquettes Figma compatibles :

1. Installer la police **Inter** (Google Fonts)
2. Créer une palette avec les couleurs exactes :
   - Primary: #0F172A
   - Action: #2563EB
   - Accent: #F59E0B
   - etc.
3. Utiliser les composants de design system
4. Respecter l'échelle 8pt pour tous les spacings

---

## 🚀 Prochaines étapes

1. Tester l'app de démo : `flutter run lib/main_design_demo.dart`
2. Intégrer les composants dans vos pages
3. Remplacer l'ancien design system progressivement
4. Créer de nouveaux composants en suivant le guide

---

**Besoin d'aide ?**  
Consultez les exemples dans `lib/features/demo/presentation/pages/demo_feed_page.dart`
