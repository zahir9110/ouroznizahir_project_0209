# 🎨 Benin Experience - Design System

> **ADN visuel** : Réseau social événementiel et culturel. Design minimal, lumineux, mobile-first, avec une hiérarchie visuelle très claire. Le contenu (photos, vidéos, stories, billets) doit toujours passer avant les éléments décoratifs.

---

## 🎯 Palette de couleurs

### Couleurs principales

```dart
Primary / Brand
#0F172A   → Bleu nuit profond (texte principal, headers)
#2563EB   → Bleu vivant (CTA, actions, liens)
```

### Couleurs secondaires

```dart
Accent
#F59E0B   → Or chaud (culture, billets, événements premium)

Success
#16A34A   → Validation, billets actifs

Error
#DC2626   → Alertes, erreurs
```

### Neutres (très important)

```dart
Background
#FFFFFF   → Fond principal
#F8FAFC   → Fond secondaire (cards, sections)

Text
#020617   → Texte principal
#475569   → Texte secondaire
#94A3B8   → Texte faible / metadata
```

### 📌 Règle Instagram-like
- **Jamais plus de 2 couleurs fortes à l'écran**
- **80% blanc / gris clair**
- **Accent utilisé avec parcimonie**

---

## ✍🏽 Typographie

### Police : **Inter** (Google Fonts)

**Pourquoi Inter ?**
- Ultra lisible sur mobile
- Parfaite pour feed & réseaux sociaux
- Utilisée par Meta, Stripe, Linear

### Hiérarchie typographique

| Niveau | Style | Taille / Line Height | Usage |
|--------|-------|---------------------|-------|
| **Display** | Inter Bold | 24 / 28 | Titres majeurs, headers |
| **Title** | Inter SemiBold | 18 / 20 | Sous-titres, cards |
| **Body** | Inter Regular | 14 / 16 | Contenu principal |
| **Caption** | Inter Regular | 12 / 14 | Metadata, timestamps |

### 📌 Règle
- **Pas plus de 3 tailles par écran**
- **Gras uniquement pour attirer l'œil**

---

## 🧱 Composants UI clés

### 1️⃣ Card Événement

**Structure Instagram-like :**

```
┌──────────────────────────────────┐
│                                  │
│       [IMAGE PLEIN LARGEUR]      │
│                                  │
├──────────────────────────────────┤
│                                  │
│  Titre événement                 │
│  📍 Cotonou • 🕒 15 mars 2024    │
│                                  │
│  ❤️ 124    💬 18    📤 Share     │
│                                  │
└──────────────────────────────────┘
```

**Specs Flutter :**
- Image : `AspectRatio(16/9)` ou `AspectRatio(4/3)`
- Coins arrondis : `BorderRadius.circular(16)`
- Ombre : `elevation: 2` ou `BoxShadow` subtile
- Padding interne : `16px`

---

### 2️⃣ Stories (clé pour l'app)

**Cercle avec bordure dégradée :**

```
    ╔═══════════╗
   ╔═            ═╗
  ║                 ║
  ║    [PHOTO]      ║
  ║                 ║
   ╚═            ═╝
    ╚═══════════╝
```

**Specs Flutter :**
- Diamètre : `64px` (cercle intérieur `60px`)
- Bordure dégradée : `LinearGradient(#2563EB → #F59E0B)`
- Animation : `scale(0.97)` au tap
- Label sous le cercle : `12px`, Inter Regular

**Types de stories :**
- 🎉 Stories événements
- 🎟️ Stories billets à vendre
- 👤 Stories organisateurs

---

### 3️⃣ Billet (élément différenciant)

**Card Billet minimal :**

```
┌──────────────────────────────────┐
│  🎟️ À VENDRE                     │
├──────────────────────────────────┤
│                                  │
│  Festival Jazz 2024              │
│  📅 28 mars • 📍 Stade Omnisport │
│                                  │
│  [QR CODE]        15,000 FCFA    │
│                                  │
│  [Acheter maintenant] [Contact]  │
│                                  │
└──────────────────────────────────┘
```

**Specs Flutter :**
- Fond : `#FFFFFF` avec bordure `#E2E8F0`
- Badge "À vendre" : fond `#F59E0B`, texte blanc
- QR code : `64x64px` miniature
- Boutons : Primary (Acheter) + Secondary (Contact)

---

### 4️⃣ Boutons

#### Primary Button
```dart
Container(
  height: 48,
  decoration: BoxDecoration(
    color: #2563EB,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('Action', style: white, weight: 600)
)
```

#### Secondary Button
```dart
Container(
  height: 48,
  decoration: BoxDecoration(
    color: Colors.transparent,
    border: Border.all(color: #E2E8F0),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text('Action', style: #0F172A, weight: 600)
)
```

---

### 5️⃣ Bottom Navigation (5 items)

**Layout minimal :**

```
┌─────────┬─────────┬─────────┬─────────┬─────────┐
│  🏠     │  🗺️     │  🎉     │  🎟️     │  👤     │
│ Accueil │  Carte  │ Events  │ Billets │ Profil  │
└─────────┴─────────┴─────────┴─────────┴─────────┘
```

**Specs Flutter :**
- Hauteur : `64px`
- Icônes : Lucide / Feather style (fines)
- Label visible uniquement sur onglet actif
- Badge notification : cercle rouge `8px` en top-right
- Fond : `#FFFFFF` avec `BoxShadow` subtile

---

## 🎞️ Animations & Interactions

### Micro-interactions SEULEMENT

✅ **À faire :**
- Fade + slide vertical sur navigation (200ms)
- Scale légère sur tap : `scale(0.97)`
- Skeleton loader gris clair
- Swipe horizontal pour stories

❌ **À éviter :**
- Animations longues (> 300ms)
- Loader bloquant plein écran
- Effets gadgets / 3D

---

## 🖼️ Images & Médias

### Règles de contenu

✅ **Priorité visuelle :**
- Images plein largeur
- Ratio 16:9 ou 4:3 (jamais déformé)
- Lazy loading systématique
- Placeholder gris clair avant chargement

### 📷 Photos culturelles (ADN Benin Experience)

> **Moderne, pas folklorique.**

- Photos réelles de personnes, lieux, événements
- Peaux, matières, scènes locales authentiques
- **Pas de motifs décoratifs lourds**
- L'identité vient du contenu, pas du décor

---

## 🎨 Iconographie

### Style d'icônes : **Lucide / Feather**

**Specs :**
- Stroke width : `2px`
- Taille : `24px` (UI standard), `20px` (texte inline)
- Couleur : `#475569` (secondaire) ou `#2563EB` (active)

**Icônes clés :**
- 🏠 Home
- 🗺️ Map Pin
- 🎉 Calendar / Ticket
- 🎟️ Ticket
- 👤 User
- ❤️ Heart
- 💬 Message Circle
- 📤 Share

---

## 📐 Spacing System

### Échelle 8pt

```dart
4px   → xs   (spacing très serré)
8px   → sm   (spacing serré)
12px  → md   (spacing standard)
16px  → lg   (padding cards)
24px  → xl   (sections)
32px  → 2xl  (grandes séparations)
```

### Marges écran
- Mobile : `16px` horizontal
- Tablet : `24px` horizontal

---

## 🌓 Dark Mode (futur)

**Palette inversée :**
- Background : `#020617` (au lieu de `#FFFFFF`)
- Surface : `#0F172A` (au lieu de `#F8FAFC`)
- Texte : `#F8FAFC` (au lieu de `#020617`)

---

## 📱 Écrans principaux

### 1. Feed Événements (Home)

```
┌─────────────────────────────────┐
│  [Stories horizontal scroll]    │ ← Stories bar
├─────────────────────────────────┤
│                                 │
│  [Event Card 1]                 │
│   - Image                       │
│   - Titre + metadata            │
│   - Actions (like, comment)     │
│                                 │
│  [Event Card 2]                 │
│                                 │
│  [Ticket Card]                  │ ← Mix dans le feed
│                                 │
└─────────────────────────────────┘
```

### 2. Stories Viewer (Plein écran)

```
┌─────────────────────────────────┐
│  ████████████ [Progress bars]   │ ← Top
│                                 │
│                                 │
│         [CONTENU STORY]         │
│         Image/Video             │
│                                 │
│                                 │
│  Festival Jazz 2024             │ ← Bottom overlay
│  📍 Cotonou • 🎟️ 15,000 FCFA   │
│  [Voir le billet →]             │
└─────────────────────────────────┘
```

### 3. Profil Utilisateur

```
┌─────────────────────────────────┐
│       [Avatar 96px]             │
│                                 │
│    Nom Prénom                   │
│    @username                    │
│    Bio courte ici...            │
│                                 │
│  [Modifier profil]              │
│                                 │
├─────────────────────────────────┤
│  📊 Stats                       │
│  🎉 12 Événements               │
│  🎟️ 45 Billets vendus          │
├─────────────────────────────────┤
│  [Grid photos/events]           │
│  ┌───┬───┬───┐                 │
│  │   │   │   │                 │
│  └───┴───┴───┘                 │
└─────────────────────────────────┘
```

---

## 🧪 États UI

### Loading States
- **Skeleton** : fond `#F8FAFC`, animation shimmer
- **Spinner** : uniquement pour actions ponctuelles
- **Pull-to-refresh** : indicateur iOS/Android natif

### Empty States
- Illustration simple (optionnelle)
- Message clair : "Aucun événement pour l'instant"
- CTA : "Découvrir des événements"

### Error States
- Fond rouge très léger : `#FEE2E2`
- Icône alerte : `#DC2626`
- Message + retry button

---

## 🚀 Principes de design

### 1. Content-First
Le contenu (photos, vidéos, billets) est TOUJOURS prioritaire sur les éléments décoratifs.

### 2. Mobile-First
Tout est pensé pour le mobile en priorité. Desktop = bonus.

### 3. Hiérarchie claire
- Taille de police
- Poids (Regular vs SemiBold)
- Couleur (Primary vs Secondary)

### 4. Feedback immédiat
- Tap : scale 0.97
- Loading : skeleton
- Success : animation checkmark

### 5. Performance
- Images optimisées (WebP)
- Lazy loading systématique
- Pagination infinie

---

## 📦 Librairies Flutter recommandées

```yaml
dependencies:
  # UI
  google_fonts: ^6.1.0        # Inter font
  flutter_svg: ^2.0.9         # Icônes SVG
  cached_network_image: ^3.3.1 # Images optimisées
  
  # Animations
  animations: ^2.0.11         # Page transitions
  shimmer: ^3.0.0             # Skeleton loader
  
  # Stories
  story_view: ^0.16.0         # Stories viewer
  
  # Media
  video_player: ^2.8.0        # Vidéos
  photo_view: ^0.14.0         # Zoom images
```

---

## ✅ Checklist design

### Avant de designer un écran :

- [ ] Le contenu est-il prioritaire ?
- [ ] Maximum 2 couleurs fortes ?
- [ ] Hiérarchie visuelle claire ?
- [ ] Animations < 300ms ?
- [ ] Spacing cohérent (système 8pt) ?
- [ ] Texte lisible (contraste WCAG AA) ?
- [ ] Touch targets ≥ 44px ?
- [ ] Fonctionne en landscape ?

---

## 🎯 Exemples de référence

**Apps à étudier :**
- **Instagram** : Simplicité, hiérarchie, stories
- **Airbnb** : Cards événements, spatial
- **Eventbrite** : Billets, tickets
- **BeReal** : Authenticité, contenu-first

**Pas de référence :**
- Apps surchargées (trop de couleurs)
- UI trop "fun" (perte de crédibilité)
- Design trop minimaliste (manque de personnalité)

---

## 📝 Notes d'implémentation Flutter

### Structure de fichiers recommandée

```
lib/
  core/
    theme/
      be_design_system.dart      # Nouveau design system
      be_colors.dart             # Palette Instagram-like
      be_typography.dart         # Inter styles
      be_spacing.dart            # Spacing 8pt
    widgets/
      be_event_card.dart         # Card événement
      be_story_ring.dart         # Story circle
      be_ticket_card.dart        # Card billet
      be_button.dart             # Buttons primary/secondary
      be_bottom_nav.dart         # Bottom navigation
```

---

## 🎨 Wireframes ASCII

### Feed Événements

```
╔═════════════════════════════════════╗
║ [○][○][○][○][○]  Stories →         ║
╠═════════════════════════════════════╣
║                                     ║
║ ┌─────────────────────────────────┐ ║
║ │                                 │ ║
║ │     [Event Image 16:9]          │ ║
║ │                                 │ ║
║ ├─────────────────────────────────┤ ║
║ │ Festival Jazz Ouidah            │ ║
║ │ 📍 Ouidah • 🕒 15 mars          │ ║
║ │ ❤️ 124   💬 18   📤             │ ║
║ └─────────────────────────────────┘ ║
║                                     ║
║ ┌─────────────────────────────────┐ ║
║ │ 🎟️ BILLET À VENDRE              │ ║
║ │ Concert Angélique Kidjo         │ ║
║ │ [QR] 25,000 FCFA [Acheter]      │ ║
║ └─────────────────────────────────┘ ║
║                                     ║
╚═════════════════════════════════════╝
```

### Story Viewer

```
╔═════════════════════════════════════╗
║ ████████████░░░░░░░░░  Progress     ║
║                                     ║
║                                     ║
║           [STORY IMAGE]             ║
║                                     ║
║                                     ║
║                                     ║
║ ╔═════════════════════════════════╗ ║
║ ║ Festival Jazz 2024              ║ ║
║ ║ 📍 Cotonou • 🎟️ 15,000 FCFA    ║ ║
║ ║ [Voir plus →]                   ║ ║
║ ╚═════════════════════════════════╝ ║
╚═════════════════════════════════════╝
```

---

## 🌍 ADN culturel Benin Experience

### Identité visuelle

> **"Moderne, pas folklorique"**

L'application doit refléter le Bénin contemporain :
- Urbain et connecté
- Jeune et dynamique
- Authentique mais pas cliché

### Contenu > Décor

L'identité culturelle vient du **contenu partagé** :
- Photos de vrais événements
- Stories d'organisateurs locaux
- Billets pour festivals réels

**Pas de :**
- Motifs wax en background
- Masques décoratifs partout
- Clichés touristiques

---

## 📊 Metrics de succès

### UX Metrics

- **Time to content** : < 2s
- **Tap rate** sur stories : > 40%
- **Scroll depth** feed : > 60%
- **Conversion** billets : > 5%

### Performance

- **FPS** : 60fps constant
- **Images load** : < 1s
- **App size** : < 50MB

---

## 🔄 Évolution future

### Phase 2 (Post-MVP)
- Dark mode
- Thème personnalisable
- Animations plus riches
- Transitions partagées (Hero)

### Phase 3
- Widgets animés
- AR filters pour stories
- Effets de parallaxe

---

**Maintenu par** : Design Team Benin Experience  
**Dernière mise à jour** : 8 février 2026  
**Version** : 1.0.0
