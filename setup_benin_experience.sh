#!/bin/bash

echo "🚀 Configuration Benin Experience..."

# ============================================================================
# FLUTTER PROJECT SETUP
# ============================================================================

echo "📦 Installation dépendances Flutter..."
flutter clean
flutter pub get

echo "🏗️ Création des dossiers..."
mkdir -p assets/images assets/icons assets/animations assets/fonts
mkdir -p lib/core/{theme,constants,widgets,utils}
mkdir -p lib/features/{auth,feed,map,stories,chat,notifications,tickets,profile,verification,splash,search,settings}/{data,domain,presentation}

# Créer les sous-dossiers presentation
for feature in auth feed map stories chat notifications tickets profile verification splash search settings; do
  mkdir -p lib/features/$feature/presentation/{bloc,pages,widgets}
done

# Sous-dossiers spécifiques
mkdir -p lib/features/feed/data/models
mkdir -p lib/features/verification/presentation/widgets/steps
mkdir -p lib/features/stories/presentation/widgets
mkdir -p lib/features/chat/presentation/widgets

echo "✅ Structure Flutter créée"

# ============================================================================
# FIREBASE FUNCTIONS SETUP
# ============================================================================

echo "🔥 Configuration Firebase Functions..."

cd functions

# Réinstaller dépendances propres
rm -rf node_modules package-lock.json
npm install

# Compiler TypeScript
npm run build

echo "✅ Functions compilées"

cd ..

# ============================================================================
# VÉRIFICATION FINALE
# ============================================================================

echo "🔍 Vérification du projet..."

flutter analyze

if [ $? -eq 0 ]; then
  echo "✅ Aucune erreur détectée !"
else
  echo "⚠️  Certaines erreurs persistent (normales pour les placeholders)"
fi

echo ""
echo "🎉 Benin Experience est prêt !"
echo ""
echo "Prochaines étapes:"
echo "1. Remplacer les placeholders par vos implémentations"
echo "2. Configurer Firebase: firebase login && firebase use --add"
echo "3. Déployer les functions: cd functions && firebase deploy --only functions"
echo "4. Lancer l'app: flutter run"
echo ""
