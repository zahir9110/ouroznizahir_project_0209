# GitHub Copilot Instructions for benin_experience ✅

## Quick context
- Flutter mobile app (iOS / Android) with a small feature-driven UI prototype.
- Key libs in use: **flutter_bloc**, **get_it**, **dio**, **flutter_screenutil**, **flutter_secure_storage**, **shared_preferences**, **firebase_auth**, **cloud_firestore**. See `pubspec.yaml`.
- Current implementation is UI-first: pages pull *mock data* from `lib/core/mock/mock_data.dart` and use models in `lib/core/models`.
- **Backend**: Firebase/Firestore with RBAC (Role-Based Access Control) → See [BACKEND_INDEX.md](../BACKEND_INDEX.md)

## Big picture (what to know first) 💡
- Project layout: feature-centered
  - `lib/features/<feature>/presentation/pages/` — UI screens (e.g., `home`, `map`, `tickets`, `profile`, `splash`).
  - `lib/core/` — shared theme, widgets, mock data, and models (e.g., `AppTheme`, `AppColors`, `MainScaffold`).
- App entry: `lib/main.dart` → `SplashScreen` → `MainScaffold` (bottom navigation uses `IndexedStack`). Keep `ScreenUtilInit` in `main.dart` to preserve responsive sizing.

## 🔐 Backend Architecture (IMPORTANT)
- **RBAC System**: 3 user roles (Guest, User, Organizer)
  - **Guest** (non-authenticated): Read-only access to places, reviews, offers
  - **User** (authenticated): All Guest permissions + social interactions (likes, comments, messages, favorites, ratings)
  - **Organizer** (authenticated PRO): All User permissions + publish offers, dashboard access
  
- **Key Services**:
  - `AuthService` (`lib/core/services/auth_service.dart`) — Firebase Auth + UserRole management
  - `PermissionGuard` (`lib/core/utils/permission_guard.dart`) — Check permissions before actions
  
- **Security**: Double-layer validation
  - Client-side: PermissionGuard (UX feedback)
  - Server-side: Firestore Rules (real security)
  
- **Documentation**: Start with [BACKEND_README.md](../BACKEND_README.md) for quick start, or [BACKEND_INDEX.md](../BACKEND_INDEX.md) for full navigation

## Developer workflows (commands you will use) 🔧
- Setup: `flutter pub get`
- Run app: `flutter run` or `flutter run -d <device-id>`
- Tests: `flutter test` (existing smoke widget test in `test/widget_test.dart`)
- Static analysis: `flutter analyze` (project uses `flutter_lints` via `analysis_options.yaml`)
- Formatting: `dart format .`
- Build: `flutter build apk` / `flutter build ios --no-codesign`
- **Firebase deploy**: `firebase deploy --only firestore:rules` (deploy security rules)
- **Firebase emulator**: `firebase emulators:start` (test locally)

## Project-specific conventions and patterns ✏️
- Responsive sizing: use `.w`, `.h`, `.sp`, `.r` from `flutter_screenutil` consistently (see `home_page.dart` and `main.dart`).
- UI text is French (strings and comments). Maintain this language unless doing an i18n/l10n pass.
- Shared UI → `lib/core/widgets/` and `lib/core/theme/` (use these rather than duplicating styles).
- Mock-first flow: prototypes should use `MockData` in `lib/core/mock/mock_data.dart`. When replacing mocks with real data, keep method names and models under `lib/core/models/` stable to minimize downstream changes.
- Navigation: `MainScaffold` manages the bottom nav; add pages by editing `_pages` and `_navItems` together to keep indices aligned.
- **Permissions**: Always check permissions before write operations using `PermissionGuard`

## Integration & extension notes ⚙️
- Network and DI are prepped but not fully wired:
  - `dio` and `pretty_dio_logger` are available for HTTP clients.
  - `get_it` is included for DI but no global locator exists yet — add `lib/core/di/service_locator.dart` and register services there.

Example DI starter (suggested pattern):
```dart
// lib/core/di/service_locator.dart
import 'package:get_it/get_it.dart';
import 'package:benin_experience/core/services/auth_service.dart';
import 'package:benin_experience/core/utils/permission_guard.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Auth & Permissions
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => PermissionGuard(sl()));
  
  // Add other services here
}
```
Call `setupServiceLocator()` early (e.g., in `main()` before `runApp`).

## 🎯 Permission Patterns
When adding features that require user interaction (likes, comments, ratings, etc.), always use this pattern:

```dart
import 'package:benin_experience/core/utils/permission_guard.dart';
import 'package:benin_experience/core/constants/auth_constants.dart';
import 'package:benin_experience/core/di/service_locator.dart';

class MyWidget extends StatelessWidget {
  final PermissionGuard _guard = sl<PermissionGuard>();
  
  Future<void> _onActionRequiringAuth() async {
    // Check permission first
    if (!await _guard.requireUserRole(
      onUnauthorized: () => _showAuthDialog(),
    )) {
      return;
    }
    
    // Continue with the action
    await _performAction();
  }
  
  void _showAuthDialog() {
    // Show signup/login dialog
  }
}
```

## Testing & future work 🚀
- Add `bloc_test` / `mocktail` if you introduce blocs and want unit tests for business logic.
- When moving from mocks to remote data: implement `features/<x>/data/` and `features/<x>/domain/` layers and register repositories in the DI locator.
- **Firestore Rules Testing**: Use Firebase Emulator for testing security rules locally before deploying

## 📚 Backend Documentation Quick Links
- **Quick Start**: [BACKEND_README.md](../BACKEND_README.md)
- **Full Index**: [BACKEND_INDEX.md](../BACKEND_INDEX.md)
- **Architecture**: [BACKEND_RBAC_ARCHITECTURE.md](../BACKEND_RBAC_ARCHITECTURE.md)
- **Database Schema**: [FIRESTORE_SCHEMA.md](../FIRESTORE_SCHEMA.md)
- **Integration Guide**: [BACKEND_INTEGRATION_GUIDE.md](../BACKEND_INTEGRATION_GUIDE.md)
- **Visual Diagrams**: [BACKEND_DIAGRAMS.md](../BACKEND_DIAGRAMS.md)


## Debugging tips & common pitfalls ⚠️
- Keep `ScreenUtilInit` in `main.dart` — removing it breaks `.w/.h/.sp` usages across the UI.
- When adding a new bottom tab, ensure index ordering matches `_navItems` to avoid UI mismatches.
- Use `flutter logs` or `pretty_dio_logger` to trace network issues.

## Files to inspect for examples
- `lib/main.dart` — app bootstrap + `ScreenUtilInit`
- `lib/core/mock/mock_data.dart` — how UI is fed mock events
- `lib/core/theme/*` — colors & typography (AppTheme/AppColors)
- `lib/core/widgets/main_scaffold.dart` — bottom navigation pattern
- `lib/features/home/presentation/pages/home_page.dart` — representative page
- `test/widget_test.dart` — current test pattern

---
If any of the above is unclear or you want examples for wiring DI/tests or converting a mock to a repository, tell me which feature and I'll add a short, concrete edit or PR template. ✅