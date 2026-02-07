# Benin Experience

Benin Experience est une application mobile développée en Flutter, destinée au tourisme culturel, à la billetterie et à la découverte d’expériences locales au Bénin.

## Vision produit
L’application vise à offrir une expérience immersive et fiable du Bénin en combinant :
- une carte interactive par commune,
- un système de billetterie (événements, festivals, activités),
- un réseau social orienté expériences (stories, posts),
- une messagerie directe entre voyageurs et acteurs locaux,
- une marketplace d’expériences locales vérifiées.

L’objectif n’est pas de créer un simple guide touristique, mais une plateforme vivante où les utilisateurs découvrent, vivent et partagent des expériences réelles, puis reviennent pour en découvrir d’autres.

## Utilisateurs cibles
- Voyageurs internationaux (ex : touristes, influenceurs, expatriés)
- Utilisateurs locaux
- Organisateurs d’événements
- Prestataires touristiques (hôtels, restaurants, guides, artisans)

## Stack technique
### Frontend
- Flutter (Clean Architecture, feature-based)
- State management : BLoC / Cubit
- UI orientée performance et simplicité mobile

### Backend
- Firebase Authentication
- Firestore (données temps réel)
- Firebase Storage (documents, médias)
- Firebase Cloud Functions (TypeScript)

### IA
- Analyse automatique des comptes professionnels (vérification culturelle, géographique et documentaire)
- Enrichissement et classification d’événements
- Recommandations personnalisées basées sur la localisation et les intérêts

## Concepts clés à respecter dans le code
- Chaque fonctionnalité doit renforcer la confiance utilisateur
- Les données doivent être géolocalisées (commune, ville, coordonnées)
- Les comptes professionnels peuvent être vérifiés via un workflow IA + revue manuelle
- Les contenus sociaux (stories, posts) sont temporaires ou contextuels
- Le projet doit être scalable à d’autres pays d’Afrique de l’Ouest

## Bonnes pratiques attendues
- Code clair, modulaire et maintenable
- Séparation stricte UI / logique / données
- Sécurité Firestore stricte
- Gestion des connexions réseau variables
- Pas de logique métier dans les widgets UI

## Objectif du copilote
Aider à :
- corriger les erreurs Flutter, Dart et Firebase
- proposer des implémentations cohérentes avec la vision produit
- respecter l’architecture Clean et les patterns Flutter modernes
- éviter les solutions génériques non adaptées au contexte africain
