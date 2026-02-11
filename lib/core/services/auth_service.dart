import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum représentant les différents rôles utilisateur dans l'application Bōken
enum UserRole {
  /// Utilisateur non authentifié (accès lecture seule)
  guest,
  
  /// Utilisateur inscrit standard (peut interagir)
  user,
  
  /// Organisateur professionnel (peut publier des offres)
  organizer;

  /// Retourne true si le rôle est guest
  bool get isGuest => this == UserRole.guest;
  
  /// Retourne true si le rôle est user
  bool get isUser => this == UserRole.user;
  
  /// Retourne true si le rôle est organizer
  bool get isOrganizer => this == UserRole.organizer;
  
  /// Retourne true si l'utilisateur peut interagir (pas guest)
  bool get canInteract => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut publier des offres
  bool get canPublishOffers => this == UserRole.organizer;
  
  /// Retourne true si l'utilisateur peut envoyer des messages
  bool get canSendMessages => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut liker
  bool get canLike => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut commenter
  bool get canComment => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut noter un lieu
  bool get canRate => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut publier un avis
  bool get canReview => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut sauvegarder des favoris
  bool get canSaveFavorites => this != UserRole.guest;
  
  /// Retourne true si l'utilisateur peut accéder au dashboard organizer
  bool get canAccessDashboard => this == UserRole.organizer;
  
  /// Convertit une chaîne en UserRole
  /// Si la chaîne est null ou invalide, retourne guest
  static UserRole fromString(String? role) {
    if (role == null) return UserRole.guest;
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.guest,
    );
  }
  
  /// Retourne le nom du rôle pour Firestore
  String get firestoreValue {
    if (this == UserRole.guest) {
      throw Exception('Guest role should not be stored in Firestore');
    }
    return name;
  }
}

/// Service de gestion de l'authentification et des rôles utilisateur
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  /// Stream de l'état d'authentification
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  
  /// Utilisateur actuellement connecté (ou null si non connecté)
  User? get currentUser => _auth.currentUser;
  
  /// Vérifie si un utilisateur est connecté
  bool get isAuthenticated => currentUser != null;
  
  /// Récupère le rôle de l'utilisateur actuel
  /// Retourne [UserRole.guest] si non connecté
  Future<UserRole> getUserRole() async {
    final user = currentUser;
    if (user == null) return UserRole.guest;
    
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return UserRole.guest;
      
      return UserRole.fromString(doc.data()?['role']);
    } catch (e) {
      print('Erreur lors de la récupération du rôle: $e');
      return UserRole.guest;
    }
  }
  
  /// Stream du rôle de l'utilisateur actuel
  Stream<UserRole> get roleStream {
    return authStateChanges.asyncMap((user) async {
      if (user == null) return UserRole.guest;
      return await getUserRole();
    });
  }
  
  /// Vérifie si l'utilisateur peut interagir (pas guest)
  Future<bool> canInteract() async {
    final role = await getUserRole();
    return role.canInteract;
  }
  
  /// Vérifie si l'utilisateur peut publier des offres
  Future<bool> canPublishOffers() async {
    final role = await getUserRole();
    return role.canPublishOffers;
  }
  
  /// Connexion avec email et mot de passe
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Inscription avec email et mot de passe
  /// Crée automatiquement un document utilisateur dans Firestore
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String displayName,
    required UserRole role,
    String? phone,
  }) async {
    try {
      // Créer le compte Firebase Auth
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Mettre à jour le profil
      await credential.user!.updateDisplayName(displayName);
      
      // Créer le document utilisateur dans Firestore
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'displayName': displayName,
        'role': role.firestoreValue,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      return credential;
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Déconnexion
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Réinitialisation du mot de passe
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthException(e);
    }
  }
  
  /// Met à jour le rôle d'un utilisateur (admin uniquement)
  Future<void> updateUserRole(String userId, UserRole role) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'role': role.firestoreValue,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du rôle: $e');
    }
  }
  
  /// Upgrade d'un user vers organizer
  Future<void> upgradeToOrganizer({
    required String businessName,
    String? businessType,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Utilisateur non connecté');
    
    try {
      await _firestore.collection('users').doc(user.uid).update({
        'role': UserRole.organizer.firestoreValue,
        'businessName': businessName,
        'businessType': businessType,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Erreur lors de l\'upgrade vers organizer: $e');
    }
  }
  
  /// Récupère les données complètes de l'utilisateur actuel
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;
    
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.data();
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
      return null;
    }
  }
  
  /// Gestion des exceptions Firebase Auth
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Aucun utilisateur trouvé avec cet email.';
        case 'wrong-password':
          return 'Mot de passe incorrect.';
        case 'email-already-in-use':
          return 'Cet email est déjà utilisé.';
        case 'invalid-email':
          return 'Format d\'email invalide.';
        case 'weak-password':
          return 'Le mot de passe est trop faible.';
        case 'user-disabled':
          return 'Ce compte a été désactivé.';
        default:
          return 'Erreur d\'authentification: ${e.message}';
      }
    }
    return 'Erreur inattendue: $e';
  }
}
