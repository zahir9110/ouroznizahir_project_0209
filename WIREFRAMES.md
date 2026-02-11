# 🎨 Benin Experience - Wireframes & Mockups

Ce fichier contient les wireframes ASCII et descriptions pour Figma/Excalidraw.

---

## 📱 1. Feed Événements (Home)

### Vue d'ensemble
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  Benin Experience    🔔 💬       ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃  ┌───┐ ┌───┐ ┌───┐ ┌───┐ ┌───┐  ┃ ← Stories (scroll horizontal)
┃  │ ○ │ │ ○ │ │ ○ │ │ ○ │ │ ○ │  ┃   Cercles 64px avec gradient
┃  └─┬─┘ └─┬─┘ └─┬─┘ └─┬─┘ └─┬─┘  ┃
┃   Jazz  Fest  Art  Sport Event   ┃
┃                                   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃  ┌─────────────────────────────┐ ┃ ← Event Card 1
┃  │                             │ ┃   
┃  │    [Image 16:9]             │ ┃   Image plein largeur
┃  │    Festival Jazz            │ ┃   AspectRatio 16/9
┃  │                             │ ┃
┃  ├─────────────────────────────┤ ┃
┃  │ ❤️ 124  💬 18        📤    │ ┃   Actions row
┃  ├─────────────────────────────┤ ┃
┃  │ Festival Jazz de Ouidah     │ ┃   Titre (Inter SemiBold 18)
┃  │ 📍 Ouidah • 🕒 15 mars     │ ┃   Metadata (Inter Regular 12)
┃  └─────────────────────────────┘ ┃
┃                                   ┃
┃  ┌─────────────────────────────┐ ┃ ← Ticket Card
┃  │ 🎟️ À VENDRE           VIP  │ ┃   Badge or chaud
┃  ├─────────────────────────────┤ ┃
┃  │ Concert Angélique Kidjo     │ ┃
┃  │ 📅 28 mars • 📍 Cotonou    │ ┃
┃  │                             │ ┃
┃  │ [QR]      15,000 FCFA       │ ┃   QR miniature + Prix
┃  │                             │ ┃
┃  │ [Acheter] [Contact]         │ ┃   Boutons primary/secondary
┃  └─────────────────────────────┘ ┃
┃                                   ┃
┃  ┌─────────────────────────────┐ ┃ ← Event Card 2
┃  │    [Image]                  │ ┃
┃  │    ...                      │ ┃
┃  └─────────────────────────────┘ ┃
┃                                   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃ 🏠  🗺️  🎉  🎟️  👤           ┃ ← Bottom Nav (64px height)
┃Home Carte Event Billet Profil   ┃   Label visible si actif
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Spacing
- Marges écran : 16px horizontal
- Gap entre cards : 12px
- Padding interne cards : 16px
- Stories height : 110px (64px + label + padding)

---

## 📖 2. Story Viewer (Plein écran)

### Vue d'ensemble
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃ ████████░░░░░░░░░░░░░░░░░       ┃ ← Progress bars (3/5)
┃                                   ┃   Linear indicators top
┃                                   ┃
┃                                   ┃
┃                                   ┃
┃         [STORY IMAGE/VIDEO]       ┃ ← Contenu plein écran
┃                                   ┃   Tap gauche = précédent
┃                                   ┃   Tap droite = suivant
┃                                   ┃   Swipe = close
┃                                   ┃
┃                                   ┃
┃                                   ┃
┃  ╔═══════════════════════════╗   ┃ ← Bottom overlay
┃  ║ Festival Jazz 2024        ║   ┃   Fond gradient transparent
┃  ║ 📍 Cotonou               ║   ┃   Infos événement
┃  ║ 🎟️ 15,000 FCFA          ║   ┃   
┃  ║                           ║   ┃
┃  ║ [Voir le billet →]       ║   ┃   CTA primary
┃  ╚═══════════════════════════╝   ┃
┃                                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Interactions
- **Tap gauche** : Story précédente
- **Tap droite** : Story suivante  
- **Swipe down** : Fermer le viewer
- **Tap sur CTA** : Ouvrir détails événement/billet
- **Hold** : Pause

### Progress bars
- Height : 2px
- Active color : #FFFFFF
- Inactive color : #FFFFFF 40% opacity
- Gap : 4px

---

## 👤 3. Profil Utilisateur

### Vue d'ensemble
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  ← Profil                     ⚙️ ┃ ← App bar avec settings
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃            ┌─────┐                ┃
┃            │     │                ┃ ← Avatar 96px
┃            │  👤 │                ┃   CircleAvatar
┃            │     │                ┃
┃            └─────┘                ┃
┃                                   ┃
┃       Jean-Pierre Kodjovi         ┃ ← Nom (Display Bold 24)
┃         @jpkodjovi                ┃ ← Username (Caption 12)
┃                                   ┃
┃   Passionné de culture béninoise  ┃ ← Bio (Body Regular 14)
┃   et de musique traditionnelle    ┃   Max 2 lignes
┃                                   ┃
┃    [Modifier mon profil]          ┃ ← Bouton secondary
┃                                   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  📊 Statistiques                  ┃
┃                                   ┃
┃  ┌────────┬──────────┬─────────┐ ┃ ← Stats cards
┃  │   12   │    45    │   134   │ ┃   3 colonnes égales
┃  │Events  │ Billets  │ Followers│ ┃
┃  └────────┴──────────┴─────────┘ ┃
┃                                   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃  🎉 Mes événements    Voir tout → ┃
┃                                   ┃
┃  ┌─────┬─────┬─────┐             ┃ ← Grid photos 3 colonnes
┃  │     │     │     │             ┃   AspectRatio 1:1
┃  │ img │ img │ img │             ┃   Gap 4px
┃  │     │     │     │             ┃
┃  ├─────┼─────┼─────┤             ┃
┃  │     │     │     │             ┃
┃  │ img │ img │ img │             ┃
┃  │     │     │     │             ┃
┃  └─────┴─────┴─────┘             ┃
┃                                   ┃
┃  🎟️ Mes billets      Voir tout → ┃
┃                                   ┃
┃  ┌─────┬─────┬─────┐             ┃
┃  │     │     │     │             ┃
┃  │ img │ img │ img │             ┃
┃  │     │     │     │             ┃
┃  └─────┴─────┴─────┘             ┃
┃                                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Stats Cards
- 3 colonnes égales
- Height : 80px
- Background : #F8FAFC
- Border radius : 12px
- Gap : 8px

---

## 🗺️ 4. Carte (Map View)

### Vue d'ensemble
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  🔍 Rechercher...           🎚️  ┃ ← Search bar + filtres
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃         [GOOGLE MAPS]             ┃ ← Map full screen
┃                                   ┃   Markers événements
┃     📍    📍        📍           ┃   Cluster si zoom out
┃                                   ┃
┃           📍                      ┃
┃                 📍                ┃
┃                                   ┃
┃    📍                 📍          ┃
┃                                   ┃
┃                                   ┃
┃  ╔═══════════════════════════╗   ┃ ← Bottom sheet (draggable)
┃  ║ ≡ Événements proches      ║   ┃   Pull up pour voir liste
┃  ║                           ║   ┃
┃  ║ [Mini Event Card 1]       ║   ┃   Cards horizontales
┃  ║ [Mini Event Card 2]       ║   ┃   Scroll horizontal
┃  ║ [Mini Event Card 3] →     ║   ┃
┃  ╚═══════════════════════════╝   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Map markers
- Événement : Pin bleu (#2563EB)
- Billet : Pin or (#F59E0B)
- Position utilisateur : Cercle bleu with pulse
- Cluster : Cercle avec nombre

---

## 🎉 5. Détails Événement (Modal)

### Vue d'ensemble
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                                   ┃
┃       [IMAGE HEADER]              ┃ ← Image hero 16:9
┃       Overlay gradient            ┃   Gradient bottom
┃                                   ┃
┃  ← Festival Jazz de Ouidah    ⋮  ┃ ← Titre overlay
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃  ┌───┐                            ┃
┃  │   │ Festival Ouidah            ┃ ← Organisateur
┃  └───┘ @festivalouidah            ┃   Avatar + nom
┃        [Suivre]                   ┃   Bouton follow
┃                                   ┃
┃  📅 15 mars 2024 • 19h00          ┃ ← Infos clés
┃  📍 Plage de Ouidah               ┃   Icônes + texte
┃  👥 245 participants              ┃
┃                                   ┃
┃  ──────────────────────────       ┃ ← Divider
┃                                   ┃
┃  À propos                         ┃ ← Section description
┃  Le Festival Jazz de Ouidah       ┃   Body Regular 14
┃  célèbre la musique afro-jazz...  ┃   Expandable "Lire plus"
┃                                   ┃
┃  [Lire plus ↓]                    ┃
┃                                   ┃
┃  ──────────────────────────       ┃
┃                                   ┃
┃  🎟️ Billets                      ┃ ← Section billets
┃                                   ┃
┃  ┌─────────────────────────────┐ ┃   Ticket options
┃  │ Standard    15,000 FCFA     │ ┃   Cards cliquables
┃  │ ○ Disponible                │ ┃
┃  └─────────────────────────────┘ ┃
┃                                   ┃
┃  ┌─────────────────────────────┐ ┃
┃  │ VIP         35,000 FCFA     │ ┃
┃  │ ○ Disponible                │ ┃
┃  └─────────────────────────────┘ ┃
┃                                   ┃
┃  ──────────────────────────       ┃
┃                                   ┃
┃  📍 Localisation                  ┃ ← Map preview
┃  [Mini Map Preview]               ┃   Tap pour full map
┃                                   ┃
┃  ──────────────────────────       ┃
┃                                   ┃
┃  [   Réserver un billet   ]       ┃ ← CTA fixe bottom
┃                                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

---

## 🎟️ 6. Bottom Navigation - États

### État normal (item non actif)
```
┌──────┐
│  🏠  │  ← Icône outlined (24px)
│      │     Color: #475569 (textSecondary)
│      │     Pas de label
└──────┘
```

### État actif (item sélectionné)
```
┌──────┐
│  🏠  │  ← Icône filled (24px)
│      │     Color: #2563EB (action)
│Accueil│  ← Label visible (Caption 12)
└──────┘     Color: #2563EB
```

### Avec badge notification
```
┌──────┐
│  🎉③ │  ← Badge rouge top-right
│      │     Circle 16px
│      │     Color: #DC2626
└──────┘
```

---

## 🔔 7. Notifications

### Liste notifications
```
┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃  Notifications            ⚙️ ✓   ┃
┣━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┫
┃                                   ┃
┃  ┌───────────────────────────┐   ┃ ← Notif non lue (bg: surface)
┃  │ ●                         │   ┃   Dot bleu indicator
┃  │ ┌─┐                       │   ┃
┃  │ │○│ Jean-Pierre a aimé    │   ┃   Avatar + texte
┃  │ └─┘ votre événement       │   ┃
┃  │     Il y a 5 min          │   ┃   Timestamp
┃  └───────────────────────────┘   ┃
┃                                   ┃
┃  ┌───────────────────────────┐   ┃ ← Notif lue (bg: white)
┃  │ ┌─┐                       │   ┃   Pas de dot
┃  │ │○│ Marie a commenté...   │   ┃
┃  │ └─┘ Il y a 2h             │   ┃
┃  └───────────────────────────┘   ┃
┃                                   ┃
┃  ┌───────────────────────────┐   ┃
┃  │ ┌─┐                       │   ┃
┃  │ │🎟│ Nouveau billet dispo │   ┃   Icône système
┃  │ └─┘ Festival Jazz         │   ┃
┃  │     Hier                  │   ┃
┃  └───────────────────────────┘   ┃
┃                                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
```

### Types de notifications
- **Like** : ❤️ User a aimé...
- **Comment** : 💬 User a commenté...
- **New follower** : 👤 User vous suit...
- **Ticket** : 🎟️ Nouveau billet...
- **Event** : 🎉 Événement bientôt...
- **System** : ℹ️ Message système...

---

## 🎨 8. Composants de base

### Bouton Primary
```
┌─────────────────────┐
│   Acheter maintenant│  Height: 44px
│                     │  Radius: 12px
└─────────────────────┘  Background: #2563EB
                         Text: #FFFFFF (Inter SemiBold 14)
                         Padding: 24px horizontal
```

### Bouton Secondary
```
┌─────────────────────┐
│      Annuler        │  Height: 44px
│                     │  Radius: 12px
└─────────────────────┘  Background: transparent
                         Border: 1px #E2E8F0
                         Text: #0F172A (Inter SemiBold 14)
```

### Input Field
```
┌─────────────────────────────┐
│ Email                       │  Height: 48px
│ votre@email.com            │  Radius: 12px
└─────────────────────────────┘  Background: #F8FAFC
                                 Border: 1px #E2E8F0
                                 Focus: 2px #2563EB
```

### Chip / Tag
```
┌──────┐
│ VIP  │  Height: 24px
└──────┘  Radius: 8px
          Background: #F8FAFC
          Text: #475569 (Inter Regular 12)
          Padding: 12px horizontal
```

---

## 📐 9. Grid System

### 3 colonnes (Photos profil)
```
┌─────┬─────┬─────┐
│     │     │     │  Gap: 4px
│ 1:1 │ 1:1 │ 1:1 │  AspectRatio: 1:1
│     │     │     │
├─────┼─────┼─────┤
│     │     │     │
│ 1:1 │ 1:1 │ 1:1 │
│     │     │     │
└─────┴─────┴─────┘
```

### 2 colonnes (Tickets)
```
┌────────────┬────────────┐
│            │            │  Gap: 12px
│   Card 1   │   Card 2   │  AspectRatio: 3:4
│            │            │
└────────────┴────────────┘
```

---

## 🌈 10. States UI

### Loading State (Skeleton)
```
┌─────────────────────────────┐
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓   │  Background: #F8FAFC
│                             │  Shimmer animation
│ ▓▓▓▓▓▓▓ ▓▓▓▓▓▓▓            │  Radius: 8px
│                             │
│ ▓▓▓ ▓▓▓ ▓▓▓                │
└─────────────────────────────┘
```

### Empty State
```
┌─────────────────────────────┐
│                             │
│         [Icon 48px]         │  Icon: #94A3B8
│                             │
│   Aucun événement trouvé    │  Title: #020617
│                             │
│  Essayez de changer vos     │  Description: #475569
│  filtres ou explorez les    │
│  événements populaires      │
│                             │
│  [Découvrir des événements] │  CTA Primary
│                             │
└─────────────────────────────┘
```

### Error State
```
┌─────────────────────────────┐
│ ⚠️                          │  Background: #FEE2E2
│                             │  Border: 1px #FCA5A5
│ Une erreur s'est produite   │  Icon: #DC2626
│ Impossible de charger...    │
│                             │
│ [Réessayer]                 │  Button Secondary
└─────────────────────────────┘
```

---

## 📱 11. Responsive Breakpoints

### Mobile (Default)
- Width : 375px (iPhone 11 Pro)
- Margins : 16px
- Cards : Pleine largeur

### Tablet (Future)
- Width : 768px (iPad)
- Margins : 24px
- Cards : 2 colonnes

### Desktop (Future)
- Width : 1200px+
- Margins : auto (max-width container)
- Cards : 3 colonnes

---

## 🎭 12. Animations

### Tap Feedback
```
Normal → Pressed → Normal
Scale: 1.0 → 0.97 → 1.0
Duration: 100ms
Curve: easeInOut
```

### Page Transition
```
Enter from bottom:
Y: +100% → 0%
Opacity: 0 → 1
Duration: 250ms
Curve: easeInOut
```

### Story Progress
```
Linear animation:
Width: 0% → 100%
Duration: 5s (video) / 3s (image)
Pause on hold
```

---

**Pour Figma/Excalidraw :**

1. Créer des frames avec ces dimensions exactes
2. Utiliser Inter font (download depuis Google Fonts)
3. Appliquer la palette de couleurs exacte
4. Respecter le système 8pt pour tous les spacings
5. Utiliser des composants réutilisables (buttons, cards, etc.)

**Export recommandé :**
- PNG @2x pour développement
- SVG pour icônes
- Assets optimisés WebP pour images
