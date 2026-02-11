# 🎨 Benin Experience - Design Showcase

> Design system Instagram-like pour réseau social événementiel et culturel

---

## 🌟 ADN Visuel

**"Moderne, pas folklorique"**

Le design de Benin Experience reflète le Bénin contemporain :
- 🌆 Urbain et connecté
- 🎯 Minimaliste et efficace
- 📱 Mobile-first
- 🎨 Content-first (contenu > décor)

---

## 🎨 Palette de couleurs

### Couleurs principales

<table>
<tr>
<td bgcolor="#0F172A" width="100" height="100"></td>
<td bgcolor="#2563EB" width="100" height="100"></td>
<td bgcolor="#F59E0B" width="100" height="100"></td>
<td bgcolor="#FFFFFF" width="100" height="100" style="border:1px solid #E2E8F0"></td>
<td bgcolor="#F8FAFC" width="100" height="100"></td>
</tr>
<tr>
<td align="center"><strong>Primary</strong><br/>#0F172A</td>
<td align="center"><strong>Action</strong><br/>#2563EB</td>
<td align="center"><strong>Accent</strong><br/>#F59E0B</td>
<td align="center"><strong>Background</strong><br/>#FFFFFF</td>
<td align="center"><strong>Surface</strong><br/>#F8FAFC</td>
</tr>
</table>

### Couleurs secondaires

<table>
<tr>
<td bgcolor="#16A34A" width="100" height="100"></td>
<td bgcolor="#DC2626" width="100" height="100"></td>
<td bgcolor="#020617" width="100" height="100"></td>
<td bgcolor="#475569" width="100" height="100"></td>
<td bgcolor="#94A3B8" width="100" height="100"></td>
</tr>
<tr>
<td align="center"><strong>Success</strong><br/>#16A34A</td>
<td align="center"><strong>Error</strong><br/>#DC2626</td>
<td align="center"><strong>Text Primary</strong><br/>#020617</td>
<td align="center"><strong>Text Secondary</strong><br/>#475569</td>
<td align="center"><strong>Text Tertiary</strong><br/>#94A3B8</td>
</tr>
</table>

### 📌 Règle Instagram-like
- **80% blanc/gris clair** - Fond neutre
- **Max 2 couleurs fortes** - Par écran
- **Accent avec parcimonie** - Points stratégiques uniquement

---

## ✍🏽 Typographie

**Police : Inter (Google Fonts)**

### Hiérarchie

| Style | Poids | Taille | Usage | Exemple |
|-------|-------|--------|-------|---------|
| **Display** | Bold (700) | 24px / 28px | Titres majeurs | <h1 style="font-family: Inter; font-size: 24px; font-weight: 700; margin: 0;">Benin Experience</h1> |
| **Title** | SemiBold (600) | 18px / 20px | Sous-titres, cards | <h2 style="font-family: Inter; font-size: 18px; font-weight: 600; margin: 0;">Festival Jazz de Ouidah</h2> |
| **Body** | Regular (400) | 14px / 16px | Contenu principal | <p style="font-family: Inter; font-size: 14px; font-weight: 400; margin: 0;">Le festival célèbre la musique afro-jazz...</p> |
| **Caption** | Regular (400) | 12px / 14px | Metadata, timestamps | <small style="font-family: Inter; font-size: 12px; color: #475569;">Il y a 2 heures</small> |

### Pourquoi Inter ?
✅ Ultra lisible sur mobile  
✅ Parfaite pour réseaux sociaux  
✅ Utilisée par Meta, Stripe, Linear  
✅ Support complet des caractères latins  

---

## 🧱 Composants

### 1. Event Card - Card événement

**Instagram-like : Image + Actions + Infos**

```
┌──────────────────────────────────┐
│  ○ Festival Ouidah               │ ← Avatar + nom organisateur
├──────────────────────────────────┤
│                                  │
│      [IMAGE 16:9]                │ ← Photo événement pleine largeur
│      Festival Jazz               │   AspectRatio 16/9
│                                  │
├──────────────────────────────────┤
│ ❤️ 124   💬 18        📤        │ ← Actions (like, comment, share)
├──────────────────────────────────┤
│ Festival Jazz de Ouidah          │ ← Titre (Inter SemiBold 18)
│ 📍 Ouidah • 🕒 15 mars          │ ← Metadata (Inter Regular 12)
└──────────────────────────────────┘
```

**Features :**
- Image lazy loading (CachedNetworkImage)
- Actions interactives (haptic feedback)
- État liked/unliked
- Format date intelligent ("Aujourd'hui", "Demain", "5j")
- Elevation subtile (BoxShadow)

**Usage :**
```dart
BEEventCard(
  imageUrl: 'https://...',
  title: 'Festival Jazz de Ouidah',
  location: 'Ouidah, Atlantique',
  date: DateTime.now().add(Duration(days: 7)),
  likes: 124,
  comments: 18,
  isLiked: false,
  onLike: () => // Handle like
)
```

---

### 2. Story Ring - Cercle story avec gradient

**Inspiré d'Instagram : Bordure dégradée**

```
    ╔═══════════╗
   ╔═ Gradient ═╗      ← Bordure dégradée (bleu → or)
  ║               ║       Diamètre : 64px
  ║   [PHOTO]    ║       Bordure : 2px
  ║               ║       Inner : 60px
   ╚═          ═╝
    ╚═══════════╝
       Festival          ← Label (Inter Regular 12)
```

**États :**
- **Non vue** : Bordure gradient bleu → or
- **Vue** : Bordure grise simple
- **Premium** : Gradient violet → rose
- **Pas de nouvelle** : Pas de bordure

**Usage :**
```dart
BEStoryRing(
  imageUrl: 'https://...',
  label: 'Festival Jazz',
  viewed: false,
  isPremium: false,
  onTap: () => // Open story viewer
)
```

**Stories Feed Bar :**
Barre horizontale scrollable de stories
```dart
BEStoriesFeedBar(
  stories: [
    StoryData(...),
    StoryData(...),
  ],
)
```

---

### 3. Ticket Card - Card billet à vendre

**Différenciant : QR Code + Badge statut**

```
┌──────────────────────────────────┐
│ 🎟️ À VENDRE              VIP    │ ← Badge or + Catégorie
├──────────────────────────────────┤
│ Concert Angélique Kidjo          │ ← Titre événement
│ 📅 28 mars • 📍 Cotonou         │ ← Date + Lieu
│                                  │
│ [QR CODE]        15,000 FCFA     │ ← QR miniature + Prix
│   64x64                          │
│                                  │
│ 👤 Vendu par Jean-Pierre K.      │ ← Vendeur
│                                  │
│ [Acheter maintenant] [Contact]   │ ← Actions
└──────────────────────────────────┘
```

**Types de badges :**
- 🟡 **À VENDRE** : Or (#F59E0B)
- 🔵 **BILLET ACTIF** : Bleu (#2563EB)
- ⚪ **VENDU** : Gris (#94A3B8)

**Usage :**
```dart
BETicketCard(
  eventTitle: 'Concert Angélique Kidjo',
  location: 'Cotonou',
  date: DateTime(2024, 3, 28),
  price: 15000,
  currency: 'FCFA',
  isForSale: true,
  qrCodeUrl: 'https://...',
  onBuyTap: () => // Handle purchase
)
```

---

### 4. Buttons - Boutons configurables

**3 variantes : Primary, Secondary, Text**

#### Primary Button
```
┌──────────────────────┐
│  Acheter maintenant  │  Background: #2563EB
└──────────────────────┘  Text: #FFFFFF
                          Height: 44px
                          Radius: 12px
```

#### Secondary Button
```
┌──────────────────────┐
│      Annuler         │  Background: transparent
└──────────────────────┘  Border: 1px #E2E8F0
                          Text: #0F172A
```

#### Text Button
```
  En savoir plus →       Background: none
                         Text: #2563EB
```

**Usage :**
```dart
BEButton.primary(
  label: 'Acheter',
  onTap: () {},
  icon: Icons.shopping_cart,
  size: BEButtonSize.medium,
  fullWidth: true,
)
```

---

### 5. Bottom Navigation - Navigation minimale

**5 items avec badges optionnels**

```
┌─────────┬─────────┬─────────┬─────────┬─────────┐
│  🏠     │  🗺️     │  🎉③   │  🎟️     │  👤     │
│ Accueil │         │         │         │         │
└─────────┴─────────┴─────────┴─────────┴─────────┘
  Actif     Inactif   +Badge    Inactif   Inactif
```

**Règles :**
- Label visible uniquement si actif
- Icône outlined si inactif, filled si actif
- Badge notification en top-right (cercle rouge)
- Hauteur fixe : 64px
- Shadow subtile vers le haut

**Usage :**
```dart
BEBottomNav(
  currentIndex: 0,
  onTap: (index) => // Handle navigation
  items: [
    BEBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
      label: 'Accueil',
      badgeCount: 0,
    ),
    // ...
  ],
)
```

---

## 🎬 Écrans principaux

### 1. Feed Événements (Home)

**Layout : Stories + Feed mixte**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ Benin Experience      🔔 💬      ┃ ← App bar
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ [○][○][○][○][○] Stories →       ┃ ← Stories horizontal
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃ [Event Card 1]                    ┃
┃ [Ticket Card]                     ┃ ← Mix événements + billets
┃ [Event Card 2]                    ┃
┃ [Event Card 3]                    ┃
┃                                   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 🏠  🗺️  🎉  🎟️  👤            ┃ ← Bottom nav
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Flow utilisateur :**
1. Scroll vertical pour voir le feed
2. Tap story → Story viewer plein écran
3. Tap event card → Détails événement
4. Like/Comment → Haptic feedback + animation
5. Pull-to-refresh → Reload feed

---

### 2. Story Viewer (Plein écran)

**Immersif : Contenu + Overlay minimal**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ████████░░░░░░░░  Progress       ┃ ← Progress bars (top)
┃                                   ┃
┃                                   ┃
┃        [STORY CONTENT]            ┃ ← Image/Video plein écran
┃        Image ou Vidéo             ┃
┃                                   ┃
┃                                   ┃
┃                                   ┃
┃ ╔═════════════════════════════╗   ┃
┃ ║ Festival Jazz 2024          ║   ┃ ← Overlay bottom (gradient)
┃ ║ 📍 Cotonou • 🎟️ 15,000F   ║   ┃
┃ ║ [Voir le billet →]         ║   ┃
┃ ╚═════════════════════════════╝   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

**Interactions :**
- **Tap gauche** : Story précédente
- **Tap droite** : Story suivante
- **Swipe down** : Fermer
- **Hold** : Pause
- **Tap CTA** : Action (voir événement, acheter billet)

---

### 3. Profil Utilisateur

**Layout : Header + Stats + Grid**

```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ← Profil                      ⚙️ ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃         [Avatar 96px]             ┃
┃                                   ┃
┃    Jean-Pierre Kodjovi            ┃ ← Nom (Display Bold)
┃      @jpkodjovi                   ┃ ← Username (Caption)
┃                                   ┃
┃ Passionné de culture béninoise    ┃ ← Bio (Body)
┃                                   ┃
┃   [Modifier mon profil]           ┃ ← Button secondary
┃                                   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 📊 Statistiques                   ┃
┃ ┌─────┬─────┬─────┐              ┃
┃ │ 12  │ 45  │ 134 │              ┃ ← Stats cards
┃ │Event│Billet│Follw│              ┃
┃ └─────┴─────┴─────┘              ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 🎉 Mes événements  Voir tout →   ┃
┃ ┌───┬───┬───┐                    ┃
┃ │img│img│img│                    ┃ ← Grid 3 colonnes (1:1)
┃ └───┴───┴───┘                    ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 📐 Spacing System (8pt)

**Cohérence garantie**

| Variable | Valeur | Usage |
|----------|--------|-------|
| `xs` | 4px | Spacing très serré |
| `sm` | 8px | Gap dans rows/columns |
| `md` | 12px | Gap entre cards |
| `lg` | 16px | Padding cards, marges écran |
| `xl` | 24px | Sections |
| `xxl` | 32px | Grandes séparations |

**Règle d'or :** Toujours utiliser des multiples de 8px (ou 4px pour ajustements fins)

---

## 🎨 Design Tokens Flutter

### Couleurs
```dart
BEColors.primary       // #0F172A
BEColors.action        // #2563EB
BEColors.accent        // #F59E0B
BEColors.background    // #FFFFFF
BEColors.surface       // #F8FAFC
BEColors.textPrimary   // #020617
```

### Typographie
```dart
BETypography.display()      // 24px Bold
BETypography.title()        // 18px SemiBold
BETypography.body()         // 14px Regular
BETypography.caption()      // 12px Regular
```

### Spacing
```dart
BESpacing.lg               // 16px
BESpacing.radiusMd         // 12px
BESpacing.storySize        // 64px
BESpacing.buttonMedium     // 44px
```

---

## 🌈 États UI

### Loading (Skeleton)
```
┌─────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   │  Background: #F8FAFC
│                     │  Shimmer effect
│ ▓▓▓▓ ▓▓▓▓▓         │  BorderRadius: 8px
│                     │
│ ▓▓ ▓▓ ▓▓           │
└─────────────────────┘
```

### Empty
```
┌─────────────────────┐
│                     │
│     [Icon 48px]     │  Color: #94A3B8
│                     │
│ Aucun événement     │  Text: #020617
│                     │
│ [Découvrir]         │  Button primary
└─────────────────────┘
```

### Error
```
┌─────────────────────┐
│ ⚠️                  │  Background: #FEE2E2
│ Une erreur...       │  Icon: #DC2626
│ [Réessayer]         │  Button secondary
└─────────────────────┘
```

---

## 🎯 Principes de design

### 1. Content-First ⭐
Le contenu (photos, vidéos, billets) est TOUJOURS prioritaire sur les éléments décoratifs.

### 2. Mobile-First 📱
Tout est pensé pour le mobile en priorité. Desktop = bonus.

### 3. Hiérarchie claire 📊
- Taille de police (24 > 18 > 14 > 12)
- Poids (Bold > SemiBold > Regular)
- Couleur (Primary > Secondary > Tertiary)

### 4. Feedback immédiat ⚡
- Tap : scale(0.97) + haptic
- Loading : skeleton + spinner
- Success : animation checkmark

### 5. Performance 🚀
- Images optimisées (WebP)
- Lazy loading systématique
- Pagination infinie

---

## ✅ Checklist avant de designer

Avant de créer un nouvel écran :

- [ ] Le contenu est-il prioritaire ?
- [ ] Maximum 2 couleurs fortes ?
- [ ] Hiérarchie visuelle claire ?
- [ ] Animations < 300ms ?
- [ ] Spacing cohérent (système 8pt) ?
- [ ] Texte lisible (contraste WCAG AA) ?
- [ ] Touch targets ≥ 44px ?
- [ ] Fonctionne en landscape ?

---

## 🔗 Liens utiles

- **Inter Font** : [Google Fonts](https://fonts.google.com/specimen/Inter)
- **Lucide Icons** : [lucide.dev](https://lucide.dev/)
- **Figma Community** : Rechercher "Instagram UI Kit"
- **Color Contrast Checker** : [WebAIM](https://webaim.org/resources/contrastchecker/)

---

## 🎉 Résumé

**Benin Experience Design System** est un design system moderne et cohérent inspiré d'Instagram :

✅ **Minimal** : 80% blanc/gris, contenu prioritaire  
✅ **Cohérent** : Tokens partagés (colors, typography, spacing)  
✅ **Performant** : Lazy loading, animations courtes  
✅ **Mobile-first** : Pensé pour le mobile, adapté au desktop  
✅ **Culturel** : Moderne, pas folklorique  

**Design tokens :** 3 fichiers (colors, typography, spacing)  
**Composants :** 5 widgets réutilisables  
**Écrans :** 3 layouts principaux documentés  

---

**Benin Experience** - Réseau social événementiel et culturel  
Version 1.0.0 - Février 2026
