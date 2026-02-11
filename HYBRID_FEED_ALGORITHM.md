# 🎯 ALGORITHME DE FEED HYBRIDE - ÉVÉNEMENTS + STORIES

## Vue d'ensemble

Système de feed unifié combinant **Stories éphémères** (contenu social 24h) et **Événements/Tickets** (contenu transactionnel) avec ranking intelligent basé sur pertinence, engagement, et intentions utilisateur.

---

## 📊 Architecture du Feed

### Structure du Feed Item Unifié

```typescript
interface FeedItem {
  id: string;
  type: 'story' | 'event' | 'ticket' | 'story_ring';
  
  // Scores de ranking
  scores: {
    relevance: number;        // 0-100 (pertinence utilisateur)
    recency: number;          // 0-100 (fraîcheur)
    engagement: number;       // 0-100 (engagement social)
    commercial: number;       // 0-100 (potentiel conversion)
    final: number;            // Score final pondéré
  };
  
  // Métadonnées communes
  metadata: {
    createdAt: Timestamp;
    lastUpdated: Timestamp;
    authorId: string;
    authorName: string;
    authorAvatar: string;
    location?: GeoPoint;
    category: string;
  };
  
  // Contenu spécifique au type
  content: StoryContent | EventContent | TicketContent;
  
  // Contexte utilisateur
  userContext: {
    hasViewed: boolean;
    hasInteracted: boolean;
    viewedAt?: Timestamp;
    distance?: number;        // km de l'utilisateur
    affinityScore: number;    // Affinité avec l'auteur
  };
}
```

---

## 🧮 Algorithme de Scoring Multi-Critères

### 1. **Relevance Score** (Pertinence Utilisateur)

```typescript
function calculateRelevanceScore(
  item: FeedItem,
  userProfile: UserProfile
): number {
  let score = 0;
  
  // A. Affinité catégorie (30 points max)
  const categoryAffinity = userProfile.preferences.categories[item.metadata.category] || 0;
  score += categoryAffinity * 30;
  
  // B. Proximité géographique (25 points max)
  if (item.metadata.location && userProfile.location) {
    const distance = calculateDistance(
      item.metadata.location,
      userProfile.location
    );
    // Décroissance exponentielle : 100% à 0km, 50% à 10km, 10% à 50km
    const proximityFactor = Math.exp(-distance / 20);
    score += proximityFactor * 25;
  }
  
  // C. Affinité auteur (20 points max)
  const isFollowing = userProfile.following.includes(item.metadata.authorId);
  const interactionHistory = getUserAuthorInteractions(
    userProfile.id,
    item.metadata.authorId
  );
  
  if (isFollowing) {
    score += 15;
  }
  score += Math.min(interactionHistory * 2, 5); // +5 max pour historique
  
  // D. Matching tags/intérêts (15 points max)
  const userInterests = new Set(userProfile.interests);
  const itemTags = new Set(getItemTags(item));
  const intersection = [...userInterests].filter(x => itemTags.has(x));
  score += (intersection.length / Math.max(userInterests.size, 1)) * 15;
  
  // E. Timing optimal (10 points max)
  const currentHour = new Date().getHours();
  const optimalHours = getOptimalHoursForCategory(item.metadata.category);
  if (optimalHours.includes(currentHour)) {
    score += 10;
  }
  
  return Math.min(score, 100);
}
```

### 2. **Recency Score** (Fraîcheur Temporelle)

```typescript
function calculateRecencyScore(item: FeedItem): number {
  const now = Date.now();
  const createdAt = item.metadata.createdAt.toMillis();
  const ageMinutes = (now - createdAt) / (1000 * 60);
  
  if (item.type === 'story' || item.type === 'story_ring') {
    // Stories : décroissance rapide sur 24h
    // 100% dans la première heure, 50% à 6h, 10% à 20h
    const ageHours = ageMinutes / 60;
    return Math.max(0, 100 * Math.exp(-ageHours / 8));
    
  } else if (item.type === 'event' || item.type === 'ticket') {
    // Événements : décroissance lente jusqu'à la date
    const eventDate = (item.content as EventContent).schedule.startDate.toMillis();
    const daysUntilEvent = (eventDate - now) / (1000 * 60 * 60 * 24);
    
    if (daysUntilEvent < 0) {
      return 0; // Événement passé
    }
    
    // Boost pour événements imminents (J-7 à J-1)
    if (daysUntilEvent <= 7 && daysUntilEvent >= 1) {
      return 80 + (7 - daysUntilEvent) * 3; // 80-98
    }
    
    // Décroissance progressive pour événements futurs
    // 100% si publié < 3h, puis décroissance exponentielle
    const publicationAgeHours = (now - item.metadata.lastUpdated.toMillis()) / (1000 * 60 * 60);
    return Math.max(20, 100 * Math.exp(-publicationAgeHours / 72)); // 20% minimum
  }
  
  return 50; // Fallback
}
```

### 3. **Engagement Score** (Signaux Sociaux)

```typescript
function calculateEngagementScore(item: FeedItem): number {
  const social = item.content.social;
  
  // Normalisation par taille de l'audience
  const authorFollowers = getAuthorFollowerCount(item.metadata.authorId);
  const baseAudience = Math.max(authorFollowers, 100);
  
  // A. Taux d'engagement (40 points max)
  const engagementRate = (
    (social.likes + social.shares * 3 + social.comments * 2) / baseAudience
  ) * 100;
  const engagementScore = Math.min(engagementRate * 40, 40);
  
  // B. Vélocité (vitesse d'engagement) (30 points max)
  const ageHours = (Date.now() - item.metadata.createdAt.toMillis()) / (1000 * 60 * 60);
  const engagementsPerHour = (social.likes + social.shares + social.comments) / Math.max(ageHours, 0.1);
  const velocityScore = Math.min(Math.log10(engagementsPerHour + 1) * 15, 30);
  
  // C. Qualité engagement (30 points max)
  const shareWeight = social.shares * 5;      // Partage = engagement fort
  const commentWeight = social.comments * 3;   // Commentaire = engagement moyen
  const likeWeight = social.likes * 1;         // Like = engagement faible
  
  const totalWeightedEngagement = shareWeight + commentWeight + likeWeight;
  const qualityScore = Math.min(Math.log10(totalWeightedEngagement + 1) * 10, 30);
  
  return engagementScore + velocityScore + qualityScore;
}
```

### 4. **Commercial Score** (Potentiel de Conversion)

```typescript
function calculateCommercialScore(
  item: FeedItem,
  userProfile: UserProfile
): number {
  if (item.type !== 'event' && item.type !== 'ticket') {
    return 0; // Stories non transactionnelles
  }
  
  const content = item.content as EventContent | TicketContent;
  let score = 0;
  
  // A. Intention d'achat utilisateur (35 points max)
  const recentPurchaseIntent = hasRecentPurchaseIntent(userProfile, item.metadata.category);
  if (recentPurchaseIntent) {
    score += 35;
  } else {
    // Historique d'achat dans la catégorie
    const purchaseHistory = getUserPurchaseHistory(userProfile.id, item.metadata.category);
    score += Math.min(purchaseHistory.count * 5, 20);
  }
  
  // B. Disponibilité et urgence (25 points max)
  if (content.stock) {
    const stockPercentage = content.stock.available / content.stock.total;
    
    if (stockPercentage < 0.1) {
      score += 25; // Presque épuisé
    } else if (stockPercentage < 0.3) {
      score += 15; // Stock limité
    } else {
      score += 5;
    }
  }
  
  // C. Prix attractif (20 points max)
  const userBudget = userProfile.preferences.budgetRange;
  const itemPrice = content.price?.amount || 0;
  
  if (itemPrice >= userBudget.min && itemPrice <= userBudget.max) {
    score += 20;
  } else if (itemPrice < userBudget.min) {
    score += 15; // Bon plan
  }
  
  // D. Promotion active (20 points max)
  if (content.price?.discount) {
    const discountPercentage = content.price.discount.percentage;
    score += Math.min(discountPercentage / 5, 20); // Max 20 pour 100% de réduction
  }
  
  return Math.min(score, 100);
}
```

### 5. **Score Final Pondéré**

```typescript
function calculateFinalScore(
  item: FeedItem,
  userProfile: UserProfile,
  context: FeedContext
): number {
  // Calcul des scores individuels
  const relevance = calculateRelevanceScore(item, userProfile);
  const recency = calculateRecencyScore(item);
  const engagement = calculateEngagementScore(item);
  const commercial = calculateCommercialScore(item, userProfile);
  
  // Poids dynamiques selon le contexte
  let weights = getContextualWeights(context);
  
  // Ajustements selon le type de contenu
  if (item.type === 'story' || item.type === 'story_ring') {
    weights.recency *= 1.5;   // Stories valorisent la fraîcheur
    weights.engagement *= 1.2; // et l'engagement social
    weights.commercial = 0;    // Pas de scoring commercial
  } else if (item.type === 'event' || item.type === 'ticket') {
    weights.commercial *= 1.3; // Événements valorisent la conversion
    weights.recency *= 0.8;    // Moins sensible à la fraîcheur immédiate
  }
  
  // Normalisation des poids (somme = 1)
  const totalWeight = Object.values(weights).reduce((sum, w) => sum + w, 0);
  Object.keys(weights).forEach(key => {
    weights[key] /= totalWeight;
  });
  
  // Calcul du score final
  const finalScore = (
    relevance * weights.relevance +
    recency * weights.recency +
    engagement * weights.engagement +
    commercial * weights.commercial
  );
  
  // Pénalités
  let penalty = 0;
  
  // Déjà vu récemment
  if (item.userContext.hasViewed) {
    const hoursSinceView = (Date.now() - item.userContext.viewedAt!.toMillis()) / (1000 * 60 * 60);
    if (hoursSinceView < 6) {
      penalty += 30; // -30 points si vu < 6h
    } else if (hoursSinceView < 24) {
      penalty += 15; // -15 points si vu < 24h
    }
  }
  
  // Contenu similaire récent (éviter répétition)
  if (hasSimilarRecentContent(item, userProfile.recentFeed)) {
    penalty += 20;
  }
  
  return Math.max(0, finalScore - penalty);
}

function getContextualWeights(context: FeedContext) {
  // Poids par défaut
  let weights = {
    relevance: 0.35,
    recency: 0.25,
    engagement: 0.25,
    commercial: 0.15,
  };
  
  // Ajustements selon l'heure de la journée
  const hour = new Date().getHours();
  
  if (hour >= 6 && hour < 9) {
    // Matin : contenu inspirant et événements du jour
    weights.recency = 0.35;
    weights.commercial = 0.20;
  } else if (hour >= 12 && hour < 14) {
    // Midi : contenu léger et rapide (stories)
    weights.engagement = 0.35;
    weights.recency = 0.30;
  } else if (hour >= 18 && hour < 23) {
    // Soir : découverte et planification
    weights.relevance = 0.40;
    weights.commercial = 0.25;
  }
  
  // Ajustements selon le mode utilisateur
  if (context.mode === 'discovery') {
    weights.relevance = 0.20;
    weights.engagement = 0.40; // Contenu populaire
    weights.recency = 0.30;
  } else if (context.mode === 'shopping') {
    weights.commercial = 0.50; // Prioriser tickets/événements
    weights.relevance = 0.30;
  }
  
  return weights;
}
```

---

## 🔄 Stratégie de Mélange (Interleaving)

### Pattern de Feed Optimisé

```typescript
function buildHybridFeed(
  stories: StoryFeedItem[],
  events: EventFeedItem[],
  tickets: TicketFeedItem[],
  userProfile: UserProfile,
  pageSize: number = 20
): FeedItem[] {
  
  // 1. Scorer tous les items
  const allItems: FeedItem[] = [
    ...stories.map(s => ({ ...s, scores: calculateAllScores(s, userProfile) })),
    ...events.map(e => ({ ...e, scores: calculateAllScores(e, userProfile) })),
    ...tickets.map(t => ({ ...t, scores: calculateAllScores(t, userProfile) })),
  ];
  
  // 2. Tri par score final décroissant
  allItems.sort((a, b) => b.scores.final - a.scores.final);
  
  // 3. Application du pattern d'interleaving intelligent
  const feed: FeedItem[] = [];
  const storyQueue = allItems.filter(i => i.type === 'story' || i.type === 'story_ring');
  const commercialQueue = allItems.filter(i => i.type === 'event' || i.type === 'ticket');
  
  let storyIndex = 0;
  let commercialIndex = 0;
  let consecutiveCommercial = 0;
  
  for (let i = 0; i < pageSize; i++) {
    // Règle 1: Story ring toujours en position 0 (si non vues)
    if (i === 0 && storyQueue.length > 0) {
      const topStory = storyQueue.find(s => s.type === 'story_ring' && !s.userContext.hasViewed);
      if (topStory) {
        feed.push(topStory);
        storyQueue.splice(storyQueue.indexOf(topStory), 1);
        continue;
      }
    }
    
    // Règle 2: Alterner avec ratio stories:commercial = 60:40
    const shouldShowStory = (
      (feed.length % 5 < 3) || // 3 stories / 5 items
      consecutiveCommercial >= 2 || // Max 2 commerciaux consécutifs
      commercialQueue.length === 0
    );
    
    if (shouldShowStory && storyQueue.length > 0) {
      feed.push(storyQueue[storyIndex++]);
      consecutiveCommercial = 0;
    } else if (commercialQueue.length > 0) {
      feed.push(commercialQueue[commercialIndex++]);
      consecutiveCommercial++;
    } else if (storyQueue.length > 0) {
      feed.push(storyQueue[storyIndex++]);
    } else {
      break; // Plus de contenu
    }
  }
  
  // 4. Injection de contenu sponsorisé (1 tous les 10 items)
  feed = injectSponsoredContent(feed, userProfile);
  
  return feed;
}
```

### Pattern Visuel Recommandé

```
Position 0:  📍 Story Ring (non vu) - Toujours horizontal scroll
Position 1:  🎭 Event Card (score élevé)
Position 2:  📸 Story individuelle (créateur suivi)
Position 3:  🎟️ Ticket en promo
Position 4:  📸 Story tendance
Position 5:  🎭 Event local (< 10km)
Position 6:  📸 Story
Position 7:  🎟️ Ticket recommandé
Position 8:  📸 Story
Position 9:  🎭 Event (catégorie préférée)
Position 10: 💰 [SPONSORISÉ] Ticket
...
```

---

## 🎚️ Personnalisation Dynamique

### Ajustements en Temps Réel

```typescript
function adjustFeedForUserBehavior(
  feed: FeedItem[],
  userSession: UserSession
): FeedItem[] {
  
  // Analyse du comportement dans la session actuelle
  const sessionMetrics = {
    storyViewRate: userSession.storiesViewed / userSession.storiesShown,
    eventClickRate: userSession.eventsClicked / userSession.eventsShown,
    timeSpentOnStories: userSession.storyWatchTime,
    timeSpentOnEvents: userSession.eventBrowseTime,
  };
  
  // Ajuster le ratio stories/events dynamiquement
  if (sessionMetrics.storyViewRate > 0.7) {
    // Utilisateur consomme beaucoup de stories
    return boostContentType(feed, ['story', 'story_ring'], 1.3);
  } else if (sessionMetrics.eventClickRate > 0.5) {
    // Utilisateur cherche des événements
    return boostContentType(feed, ['event', 'ticket'], 1.4);
  }
  
  // Détecter l'intention shopping
  if (hasCartActivity(userSession) || hasRecentSearches(userSession)) {
    return prioritizeCommercialContent(feed);
  }
  
  return feed;
}
```

---

## 🚀 Optimisations Performance

### 1. Pré-calcul des Scores (Cloud Functions)

```typescript
// Fonction planifiée toutes les 15 minutes
export const precalculateFeedScores = functions.pubsub
  .schedule('every 15 minutes')
  .onRun(async () => {
    
    // Récupérer les utilisateurs actifs (dernière connexion < 7j)
    const activeUsers = await getActiveUsers();
    
    for (const user of activeUsers) {
      const userProfile = await getUserProfile(user.id);
      
      // Récupérer contenu frais (< 48h)
      const freshContent = await getFreshContent();
      
      // Calculer scores pour top 100 items
      const scoredItems = freshContent.map(item => ({
        itemId: item.id,
        userId: user.id,
        scores: calculateAllScores(item, userProfile),
        calculatedAt: Timestamp.now(),
      }));
      
      // Sauvegarder dans cache
      await saveToCacheBatch(`feed_cache/${user.id}`, scoredItems);
    }
  });
```

### 2. Cache Redis Multi-Niveaux

```typescript
interface FeedCache {
  // Niveau 1: Feed complet pré-calculé (TTL: 15 min)
  precomputedFeed: {
    key: `feed:${userId}:full`,
    value: FeedItem[],
    ttl: 900, // 15 min
  };
  
  // Niveau 2: Scores individuels (TTL: 1h)
  itemScores: {
    key: `scores:${userId}:${itemId}`,
    value: ScoreBreakdown,
    ttl: 3600,
  };
  
  // Niveau 3: Profil utilisateur agrégé (TTL: 6h)
  userProfile: {
    key: `profile:${userId}:aggregated`,
    value: UserProfileCache,
    ttl: 21600,
  };
}

async function getFeedWithCache(
  userId: string,
  pageNumber: number = 1
): Promise<FeedItem[]> {
  
  // Tenter lecture cache L1
  const cached = await redis.get(`feed:${userId}:full:page${pageNumber}`);
  if (cached) {
    return JSON.parse(cached);
  }
  
  // Tenter reconstruction depuis cache L2 (scores individuels)
  const cachedScores = await redis.mget(
    ...getRelevantItemIds().map(id => `scores:${userId}:${id}`)
  );
  
  if (cachedScores.filter(Boolean).length > 50) {
    // Assez de scores en cache pour reconstruire
    const feed = reconstructFeedFromScores(cachedScores);
    await redis.setex(`feed:${userId}:full:page${pageNumber}`, 900, JSON.stringify(feed));
    return feed;
  }
  
  // Calcul complet (cache miss)
  const feed = await buildHybridFeedFull(userId);
  await redis.setex(`feed:${userId}:full:page${pageNumber}`, 900, JSON.stringify(feed));
  return feed;
}
```

### 3. Invalidation Intelligente

```typescript
// Événements déclenchant invalidation cache
const INVALIDATION_TRIGGERS = [
  'user_followed_creator',      // Invalider relevance
  'user_liked_content',          // Invalider engagement
  'user_viewed_story',           // Invalider recency
  'user_purchased_ticket',       // Invalider commercial
  'new_story_from_followed',     // Invalider feed complet
  'user_location_changed',       // Invalider si > 5km
];

async function invalidateFeedCache(userId: string, trigger: string) {
  switch (trigger) {
    case 'user_location_changed':
      // Invalider uniquement les scores de proximité
      await redis.del(`profile:${userId}:aggregated`);
      await invalidateScoresWithPattern(`scores:${userId}:*:proximity`);
      break;
      
    case 'new_story_from_followed':
      // Invalidation complète
      await redis.del(`feed:${userId}:*`);
      break;
      
    default:
      // Invalidation partielle
      await redis.del(`feed:${userId}:full:page1`);
  }
}
```

---

## 📈 Métriques de Succès

### KPIs à Suivre

```typescript
interface FeedMetrics {
  // Engagement
  avgScrollDepth: number,              // Profondeur moyenne (%)
  avgSessionDuration: number,          // Durée moyenne (secondes)
  clickThroughRate: number,            // CTR (%)
  
  // Mix stories/events
  storyViewRate: number,               // % stories vues
  eventClickRate: number,              // % events cliqués
  ticketConversionRate: number,        // % tickets achetés
  
  // Qualité du ranking
  relevanceScore: number,              // Satisfaction utilisateur
  diversityScore: number,              // Variété du contenu
  serendipityScore: number,            // Découvertes inattendues
  
  // Performance
  avgLoadTime: number,                 // Temps de chargement (ms)
  cacheHitRate: number,                // Taux de hit cache (%)
}
```

### A/B Tests Recommandés

1. **Ratio Stories/Events**: 60/40 vs 50/50 vs 70/30
2. **Position Story Ring**: Position 0 vs Position 1
3. **Poids Engagement**: 0.25 vs 0.30 vs 0.20
4. **Fréquence Sponsorisé**: 1/10 vs 1/15 vs 1/20
5. **Seuil Pénalité "Déjà Vu"**: 6h vs 12h vs 24h

---

## 🎯 Cas d'Usage Spécifiques

### Mode "Discover" (Exploration)

```typescript
function getDiscoveryModeFeed(userProfile: UserProfile): FeedItem[] {
  // Réduire le poids relevance, augmenter engagement
  const context: FeedContext = {
    mode: 'discovery',
    weights: {
      relevance: 0.20,
      recency: 0.25,
      engagement: 0.45, // Contenu populaire
      commercial: 0.10,
    }
  };
  
  // Boost pour contenu hors des catégories habituelles
  return buildHybridFeed(stories, events, tickets, userProfile, 30)
    .map(item => ({
      ...item,
      scores: {
        ...item.scores,
        final: item.scores.final * (
          isOutsideUserBubble(item, userProfile) ? 1.2 : 1.0
        )
      }
    }));
}
```

### Mode "Local" (Proximité)

```typescript
function getLocalFeed(userProfile: UserProfile): FeedItem[] {
  // Filtrer contenu < 20km
  const nearbyContent = getAllContent().filter(item => 
    item.metadata.location && 
    calculateDistance(item.metadata.location, userProfile.location) < 20
  );
  
  // Maximiser poids proximité
  const context: FeedContext = {
    mode: 'local',
    weights: {
      relevance: 0.50, // Proximité compte double
      recency: 0.25,
      engagement: 0.15,
      commercial: 0.10,
    }
  };
  
  return buildHybridFeed(
    nearbyContent.filter(i => i.type.includes('story')),
    nearbyContent.filter(i => i.type === 'event'),
    nearbyContent.filter(i => i.type === 'ticket'),
    userProfile,
    20
  );
}
```

### Mode "Shopping" (Intention d'Achat)

```typescript
function getShoppingFeed(userProfile: UserProfile): FeedItem[] {
  // Prioriser événements et tickets
  const context: FeedContext = {
    mode: 'shopping',
    weights: {
      relevance: 0.25,
      recency: 0.15,
      engagement: 0.10,
      commercial: 0.50, // Conversion prioritaire
    }
  };
  
  // Filtrer uniquement contenu transactionnel + quelques stories inspirantes
  return buildHybridFeed(stories, events, tickets, userProfile, 20)
    .filter((item, index) => {
      if (item.type === 'event' || item.type === 'ticket') return true;
      if (item.type === 'story' && index % 4 === 0) return true; // 1 story / 4
      return false;
    });
}
```

---

## 🔮 Évolutions Futures

### Machine Learning Integration

```typescript
// Modèle TensorFlow.js pour prédiction de clics
interface MLFeedRanker {
  features: [
    'user_age',
    'user_region',
    'time_of_day',
    'day_of_week',
    'item_category',
    'item_age_hours',
    'author_follower_count',
    'item_engagement_rate',
    'user_item_affinity',
    'price_in_budget_range',
    // ... 50+ features
  ];
  
  model: 'feedranking_v1.tfjs';
  
  predict(features: number[]): number; // Score 0-1
}

// Remplacer calculateFinalScore par prédiction ML
const mlScore = await mlModel.predict(extractFeatures(item, userProfile));
```

### Reinforcement Learning

```typescript
// Apprendre le ranking optimal par essai/erreur
interface RLAgent {
  state: FeedState;         // État actuel du feed
  action: FeedAction;       // Quel item montrer
  reward: number;           // Engagement utilisateur (0-1)
  
  policy: (state) => action; // Politique apprise
}

// Récompenses
const reward = (
  clickWeight * wasClicked +
  viewWeight * wasViewed +
  purchaseWeight * wasPurchased +
  shareWeight * wasShared
) - penaltyForBounce;
```

---

**🎯 Points clés de l'algorithme:**

✅ **Scoring multi-critères** (relevance, recency, engagement, commercial)  
✅ **Poids dynamiques** selon contexte (heure, mode, comportement)  
✅ **Pattern d'interleaving** 60/40 stories/événements  
✅ **Pénalités** anti-répétition (déjà vu, similarité)  
✅ **Cache 3 niveaux** (feed, scores, profil)  
✅ **Modes spécialisés** (découverte, local, shopping)  
✅ **ML-ready** pour évolution vers ranking neuronal
