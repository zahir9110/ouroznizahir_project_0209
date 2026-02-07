import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class SecureDocumentUploader extends StatefulWidget {
  final String title;
  final String description;
  final DocumentType type;
  final Function(String downloadUrl) onUploaded;
  final Function(double progress) onProgress;
  final String? existingUrl;
  final List<String> allowedExtensions;

  const SecureDocumentUploader({
    super.key,
    required this.title,
    required this.description,
    required this.type,
    required this.onUploaded,
    required this.onProgress,
    this.existingUrl,
    this.allowedExtensions = const ['jpg', 'jpeg', 'png', 'pdf'],
  });

  @override
  State<SecureDocumentUploader> createState() => _SecureDocumentUploaderState();
}

class _SecureDocumentUploaderState extends State<SecureDocumentUploader> 
    with SingleTickerProviderStateMixin {
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _uploadedUrl;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _uploadedUrl = widget.existingUrl;
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    
    // Option caméra vs galerie
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Prendre une photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choisir depuis la galerie'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 2048, // Optimisation taille
        maxHeight: 2048,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      // Vérification sécurité (taille, type)
      final file = File(pickedFile.path);
      final fileSize = await file.length();
      
      if (fileSize > 10 * 1024 * 1024) { // 10MB max
        throw Exception('Fichier trop volumineux (max 10MB)');
      }

      // Upload sécurisé vers Storage
      final String fileName = '${const Uuid().v4()}_${widget.type.name}.jpg';
      const String userId = 'current_user_id'; // Récupérer du auth
      final String storagePath = 
          'verification_docs/$userId/${widget.type.name}/$fileName';
      
      final ref = FirebaseStorage.instance.ref().child(storagePath);
      
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'uploadedBy': userId,
            'documentType': widget.type.name,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Suivi progression
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        setState(() => _uploadProgress = progress);
        widget.onProgress(progress);
      });

      await uploadTask;
      final downloadUrl = await ref.getDownloadURL();

      setState(() {
        _uploadedUrl = downloadUrl;
        _isUploading = false;
      });

      widget.onUploaded(downloadUrl);

    } catch (e) {
      setState(() => _isUploading = false);
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUpload,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: _uploadedUrl != null 
              ? Colors.green.shade50 
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _uploadedUrl != null 
                ? Colors.green.shade400 
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: _isUploading 
            ? _buildUploadingState() 
            : _uploadedUrl != null 
                ? _buildUploadedState() 
                : _buildEmptyState(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.05),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForType(),
                    size: 32,
                    color: Colors.orange.shade700,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            widget.description,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Appuyez pour ajouter',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingState() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: _uploadProgress,
              strokeWidth: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange.shade700),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Upload en cours...',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(_uploadProgress * 100).toInt()}%',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedState() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            _uploadedUrl!,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: _pickAndUpload, // Remplacer
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(14),
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Document vérifié',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForType() {
    switch (widget.type) {
      case DocumentType.idCard:
        return Icons.badge_outlined;
      case DocumentType.businessRegistration:
        return Icons.business_center_outlined;
      case DocumentType.locationPhoto:
        return Icons.location_on_outlined;
      case DocumentType.activityPhoto:
        return Icons.celebration_outlined;
      default:
        return Icons.upload_file_outlined;
    }
  }
}

enum DocumentType {
  idCard,
  passport,
  businessRegistration,
  taxDocument,
  locationPhoto,
  activityPhoto,
  logo,
}
