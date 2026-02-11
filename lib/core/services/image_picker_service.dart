import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

/// Service pour gérer la sélection d'images et l'upload vers Firebase Storage
class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  /// Sélectionne plusieurs images depuis la galerie
  /// 
  /// Retourne null si l'utilisateur annule ou en cas d'erreur
  static Future<List<File>?> pickMultipleImages({
    int maxImages = 10,
  }) async {
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFiles.isEmpty) {
        return null;
      }

      // Limiter le nombre d'images si nécessaire
      final limitedFiles = pickedFiles.take(maxImages).toList();
      
      return limitedFiles.map((xFile) => File(xFile.path)).toList();
    } catch (e) {
      debugPrint('❌ Erreur lors de la sélection d\'images: $e');
      return null;
    }
  }

  /// Sélectionne une seule image depuis la galerie
  /// 
  /// Retourne null si l'utilisateur annule ou en cas d'erreur
  static Future<File?> pickSingleImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('❌ Erreur lors de la sélection d\'image: $e');
      return null;
    }
  }

  /// Prend une photo avec la caméra
  /// 
  /// Retourne null si l'utilisateur annule ou en cas d'erreur
  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (pickedFile == null) {
        return null;
      }

      return File(pickedFile.path);
    } catch (e) {
      debugPrint('❌ Erreur lors de la prise de photo: $e');
      return null;
    }
  }

  /// Upload un fichier vers Firebase Storage
  /// 
  /// [file] Le fichier à uploader
  /// [storagePath] Le chemin dans Firebase Storage (ex: 'offers/org_001/image_123.jpg')
  /// 
  /// Retourne l'URL de téléchargement du fichier uploadé
  /// Lance une exception en cas d'erreur
  static Future<String> uploadToFirebaseStorage(
    File file,
    String storagePath,
  ) async {
    try {
      debugPrint('📤 Upload vers Firebase Storage: $storagePath');

      final storageRef = FirebaseStorage.instance.ref().child(storagePath);
      
      // Déterminer le content type basé sur l'extension
      final fileExtension = path.extension(file.path).toLowerCase();
      String? contentType;
      switch (fileExtension) {
        case '.jpg':
        case '.jpeg':
          contentType = 'image/jpeg';
          break;
        case '.png':
          contentType = 'image/png';
          break;
        case '.gif':
          contentType = 'image/gif';
          break;
        case '.webp':
          contentType = 'image/webp';
          break;
      }

      // Upload avec metadata
      final uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: contentType,
          cacheControl: 'public, max-age=31536000', // Cache 1 an
        ),
      );

      // Attendre la fin de l'upload
      final snapshot = await uploadTask;
      
      // Récupérer l'URL de téléchargement
      final downloadUrl = await snapshot.ref.getDownloadURL();
      
      debugPrint('✅ Upload réussi: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('❌ Erreur lors de l\'upload: $e');
      rethrow;
    }
  }

  /// Upload plusieurs fichiers vers Firebase Storage
  /// 
  /// [files] La liste des fichiers à uploader
  /// [organizerId] L'ID de l'organisateur
  /// 
  /// Retourne la liste des URLs de téléchargement
  /// Lance une exception en cas d'erreur
  static Future<List<String>> uploadMultipleToFirebaseStorage(
    List<File> files,
    String organizerId,
  ) async {
    final List<String> uploadedUrls = [];
    
    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = path.basename(file.path);
      final storagePath = 'offers/$organizerId/${timestamp}_$i\_$filename';
      
      final url = await uploadToFirebaseStorage(file, storagePath);
      uploadedUrls.add(url);
    }
    
    return uploadedUrls;
  }

  /// Supprime un fichier de Firebase Storage à partir de son URL
  /// 
  /// Utile pour nettoyer les anciennes images lors de la modification d'une offre
  static Future<void> deleteFromFirebaseStorage(String downloadUrl) async {
    try {
      final ref = FirebaseStorage.instance.refFromURL(downloadUrl);
      await ref.delete();
      debugPrint('🗑️  Image supprimée: $downloadUrl');
    } catch (e) {
      debugPrint('❌ Erreur lors de la suppression: $e');
      // Ne pas rethrow pour éviter de bloquer le flow si l'image n'existe plus
    }
  }
}
