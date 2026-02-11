import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/offer.dart';
import '../../../../core/models/user_type.dart';
import '../../../../core/services/image_picker_service.dart';

/// Page "Créer/Éditer une offre" - Formulaire multi-étapes
class CreateOfferPage extends StatefulWidget {
  final String organizerId;
  final Offer? editingOffer;

  const CreateOfferPage({
    super.key,
    required this.organizerId,
    this.editingOffer,
  });

  @override
  State<CreateOfferPage> createState() => _CreateOfferPageState();
}

class _CreateOfferPageState extends State<CreateOfferPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 4;

  // Form controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceMinController = TextEditingController();
  final _priceMaxController = TextEditingController();

  // Form data
  OfferCategory? _selectedCategory;
  List<String> _selectedMediaUrls = []; // URLs après upload Firebase
  List<File> _selectedMediaFiles = []; // Fichiers locaux avant upload
  DateTime? _eventDate;
  int? _capacity;
  String? _vehicleType;
  List<String> _amenities = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    if (widget.editingOffer != null) {
      _loadOfferData(widget.editingOffer!);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceMinController.dispose();
    _priceMaxController.dispose();
    super.dispose();
  }

  void _loadOfferData(Offer offer) {
    setState(() {
      _titleController.text = offer.title;
      _descriptionController.text = offer.description;
      _locationController.text = offer.locationName ?? '';
      _priceMinController.text = offer.priceMin.toString();
      _priceMaxController.text = offer.priceMax?.toString() ?? '';
      _selectedCategory = offer.category;
      _selectedMediaUrls = List.from(offer.mediaUrls);
      _eventDate = offer.eventDate;
      _capacity = offer.capacity;
      _vehicleType = offer.vehicleType;
      _amenities = offer.amenities ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => _confirmExit(),
        ),
        title: Text(
          widget.editingOffer != null ? 'Éditer l\'offre' : 'Nouvelle offre',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _currentStep > 0 ? _previousStep : null,
            child: Text(
              'Retour',
              style: TextStyle(
                fontSize: 14.sp,
                color: _currentStep > 0 ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 📊 Progress indicator
          _buildProgressIndicator(),

          // 📝 Form pages
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCategoryStep(),
                _buildBasicInfoStep(),
                _buildDetailsStep(),
                _buildPricingStep(),
              ],
            ),
          ),

          // 🔘 Actions
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Row(
        children: List.generate(_totalSteps, (index) {
          final isActive = index <= _currentStep;
          
          return Expanded(
            child: Container(
              height: 4.h,
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.divider,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quel type d\'offre proposez-vous ?',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Choisissez la catégorie qui correspond le mieux',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: 32.h),

          ...OfferCategory.values.map((category) => _CategoryCard(
                category: category,
                isSelected: _selectedCategory == category,
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              )),
        ],
      ),
    );
  }

  Widget _buildBasicInfoStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informations de base',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),

          // Titre
          _InputField(
            label: 'Titre de l\'offre',
            hint: 'Ex: Festival de Jazz Porto-Novo 2026',
            controller: _titleController,
            maxLength: 80,
          ),

          SizedBox(height: 20.h),

          // Description
          _InputField(
            label: 'Description',
            hint: 'Décrivez votre offre en détail...',
            controller: _descriptionController,
            maxLines: 6,
            maxLength: 1000,
          ),

          SizedBox(height: 20.h),

          // Localisation
          _InputField(
            label: 'Lieu',
            hint: 'Ex: Porto-Novo, Bénin',
            controller: _locationController,
            prefixIcon: Icons.location_on_outlined,
          ),

          SizedBox(height: 24.h),

          // Photos
          Text(
            'Photos',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          _buildMediaPicker(),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    if (_selectedCategory == null) {
      return const Center(child: Text('Veuillez sélectionner une catégorie'));
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Détails spécifiques',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),

          // Champs spécifiques selon catégorie
          if (_selectedCategory == OfferCategory.event ||
              _selectedCategory == OfferCategory.tour) ...[
            _buildDatePicker(),
            SizedBox(height: 20.h),
            _InputField(
              label: 'Capacité maximale',
              hint: 'Nombre de places disponibles',
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _capacity = int.tryParse(value);
              },
            ),
          ],

          if (_selectedCategory == OfferCategory.accommodation) ...[
            Text(
              'Équipements',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Wrap(
              spacing: 8.w,
              children: [
                'WiFi',
                'Piscine',
                'Parking',
                'Climatisation',
                'Petit-déj',
                'Restaurant',
              ].map((amenity) => FilterChip(
                    label: Text(amenity),
                    selected: _amenities.contains(amenity),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _amenities.add(amenity);
                        } else {
                          _amenities.remove(amenity);
                        }
                      });
                    },
                  )).toList(),
            ),
          ],

          if (_selectedCategory == OfferCategory.transport) ...[
            _InputField(
              label: 'Type de véhicule',
              hint: 'Ex: Berline climatisée, Bus 50 places',
              onChanged: (value) {
                _vehicleType = value;
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingStep() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarification',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),

          Row(
            children: [
              Expanded(
                child: _InputField(
                  label: 'Prix minimum',
                  hint: '5000',
                  controller: _priceMinController,
                  keyboardType: TextInputType.number,
                  suffix: 'XOF',
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _InputField(
                  label: 'Prix maximum (optionnel)',
                  hint: '15000',
                  controller: _priceMaxController,
                  keyboardType: TextInputType.number,
                  suffix: 'XOF',
                ),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Info commission
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 24.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'Une commission de 8% sera prélevée sur chaque réservation',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32.h),

          // Résumé
          _buildSummary(),
        ],
      ),
    );
  }

  Widget _buildMediaPicker() {
    final hasMedia = _selectedMediaFiles.isNotEmpty || _selectedMediaUrls.isNotEmpty;
    final totalMediaCount = _selectedMediaFiles.length + _selectedMediaUrls.length;

    return GestureDetector(
      onTap: hasMedia ? null : _pickMedia,
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.divider,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: !hasMedia
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate,
                    size: 48.r,
                    color: AppColors.textTertiary,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Ajouter des photos',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Maximum 10 photos',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              )
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(8.w),
                itemCount: totalMediaCount + 1,
                itemBuilder: (context, index) {
                  // Bouton "Ajouter" à la fin
                  if (index == totalMediaCount) {
                    if (totalMediaCount >= 10) {
                      return const SizedBox.shrink();
                    }
                    
                    return GestureDetector(
                      onTap: _pickMedia,
                      child: Container(
                        width: 150.w,
                        margin: EdgeInsets.only(left: 8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate,
                              color: AppColors.primary,
                              size: 32.r,
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Ajouter',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // Afficher fichier local ou URL
                  final isLocalFile = index < _selectedMediaFiles.length;
                  
                  return Container(
                    width: 150.w,
                    margin: EdgeInsets.only(left: index > 0 ? 8.w : 0),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: isLocalFile
                              ? Image.file(
                                  _selectedMediaFiles[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                )
                              : Image.network(
                                  _selectedMediaUrls[index - _selectedMediaFiles.length],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: AppColors.surfaceGray,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.textTertiary,
                                        size: 32.r,
                                      ),
                                    );
                                  },
                                ),
                        ),
                        // Badge "Local" pour les fichiers non uploadés
                        if (isLocalFile)
                          Positioned(
                            top: 8.h,
                            left: 8.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.9),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'Local',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        // Bouton supprimer
                        Positioned(
                          top: 8.h,
                          right: 8.w,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isLocalFile) {
                                  _selectedMediaFiles.removeAt(index);
                                } else {
                                  _selectedMediaUrls.removeAt(
                                    index - _selectedMediaFiles.length,
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16.r,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _eventDate ?? DateTime.now().add(const Duration(days: 7)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (date != null) {
          setState(() {
            _eventDate = date;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primary, size: 24.r),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date de l\'événement',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _eventDate != null
                        ? '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'
                        : 'Sélectionner une date',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Résumé',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _SummaryRow(label: 'Catégorie', value: _selectedCategory?.displayName ?? '-'),
          _SummaryRow(label: 'Titre', value: _titleController.text.isEmpty ? '-' : _titleController.text),
          _SummaryRow(label: 'Lieu', value: _locationController.text.isEmpty ? '-' : _locationController.text),
          _SummaryRow(label: 'Prix', value: _getPriceText()),
          _SummaryRow(label: 'Photos', value: '${_selectedMediaUrls.length}'),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Bouton Brouillon
          if (_currentStep == _totalSteps - 1)
            Expanded(
              child: OutlinedButton(
                onPressed: _saveDraft,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(
                  'Enregistrer brouillon',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

          if (_currentStep == _totalSteps - 1) SizedBox(width: 12.w),

          // Bouton Suivant/Publier
          Expanded(
            flex: _currentStep == _totalSteps - 1 ? 1 : 2,
            child: ElevatedButton(
              onPressed: (_canProceed() && !_isUploading) ? _nextStep : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.divider,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: _isUploading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      _currentStep == _totalSteps - 1 ? 'Publier l\'offre' : 'Suivant',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _selectedCategory != null;
      case 1:
        return _titleController.text.isNotEmpty &&
            _descriptionController.text.isNotEmpty &&
            _locationController.text.isNotEmpty;
      case 2:
        return true; // Details are optional
      case 3:
        return _priceMinController.text.isNotEmpty;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _publishOffer();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pickMedia() async {
    // Limiter à 10 photos max
    if (_selectedMediaFiles.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 10 photos par offre')),
      );
      return;
    }

    // Afficher le choix: Galerie ou Caméra
    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                margin: EdgeInsets.only(bottom: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              Text(
                'Ajouter des photos',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 20.h),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.photo_library,
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                ),
                title: Text(
                  'Galerie',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Sélectionner plusieurs photos',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () => Navigator.pop(context, 'gallery'),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    color: AppColors.primary,
                    size: 24.r,
                  ),
                ),
                title: Text(
                  'Caméra',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Prendre une photo',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                onTap: () => Navigator.pop(context, 'camera'),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    try {
      if (source == 'gallery') {
        final files = await ImagePickerService.pickMultipleImages(
          maxImages: 10 - _selectedMediaFiles.length,
        );
        
        if (files != null && files.isNotEmpty) {
          setState(() {
            _selectedMediaFiles.addAll(files);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${files.length} photo(s) ajoutée(s)'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else if (source == 'camera') {
        final file = await ImagePickerService.pickImageFromCamera();
        
        if (file != null) {
          setState(() {
            _selectedMediaFiles.add(file);
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Photo ajoutée'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la sélection: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveDraft() {
    // TODO: Sauvegarder le brouillon en local ou dans Firestore
    // Pour le brouillon, on peut garder les chemins de fichiers locaux
    // et les uploader seulement lors de la publication
    debugPrint('💾 Sauvegarde du brouillon...');
    debugPrint('Titre: ${_titleController.text}');
    debugPrint('Catégorie: $_selectedCategory');
    debugPrint('Photos locales: ${_selectedMediaFiles.length}');
    debugPrint('Photos uploadées: ${_selectedMediaUrls.length}');
    
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('💾 Brouillon enregistré'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _publishOffer() async {
    // Validation finale
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner une catégorie')),
      );
      return;
    }

    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez entrer un titre')),
      );
      return;
    }

    if (_selectedMediaFiles.isEmpty && _selectedMediaUrls.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez ajouter au moins une photo')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Afficher dialog de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                SizedBox(height: 16.h),
                Text(
                  'Upload des photos en cours...',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Upload des fichiers locaux vers Firebase Storage
      if (_selectedMediaFiles.isNotEmpty) {
        debugPrint('📤 Upload de ${_selectedMediaFiles.length} fichier(s)...');
        
        final uploadedUrls = await ImagePickerService.uploadMultipleToFirebaseStorage(
          _selectedMediaFiles,
          widget.organizerId,
        );
        
        // Ajouter les URLs uploadées
        _selectedMediaUrls.addAll(uploadedUrls);
        
        debugPrint('✅ ${uploadedUrls.length} fichier(s) uploadé(s)');
      }

      // Fermer le dialog de chargement
      if (mounted) {
        Navigator.pop(context);
      }

      // TODO: Créer l'offre dans Firestore avec _selectedMediaUrls
      debugPrint('🚀 Publication de l\'offre...');
      debugPrint('Titre: ${_titleController.text}');
      debugPrint('Catégorie: $_selectedCategory');
      debugPrint('Prix: ${_priceMinController.text}');
      debugPrint('Photos: ${_selectedMediaUrls.length}');

      // Succès
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Offre publiée avec succès !'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Erreur lors de la publication: $e');
      
      // Fermer le dialog de chargement si ouvert
      if (mounted) {
        Navigator.pop(context);
      }

      // Afficher l'erreur
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'upload: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  void _confirmExit() {
    if (_titleController.text.isNotEmpty || _descriptionController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Quitter ?'),
          content: const Text('Vos modifications seront perdues.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              child: const Text('Quitter'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  String _getPriceText() {
    if (_priceMinController.text.isEmpty) return '-';
    final min = _priceMinController.text;
    final max = _priceMaxController.text;
    if (max.isEmpty) return '$min XOF';
    return '$min - $max XOF';
  }
}

class _CategoryCard extends StatelessWidget {
  final OfferCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              category.icon,
              style: TextStyle(fontSize: 32.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    _getCategoryDescription(category),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 24.r,
              ),
          ],
        ),
      ),
    );
  }

  String _getCategoryDescription(OfferCategory category) {
    switch (category) {
      case OfferCategory.event:
        return 'Concerts, festivals, spectacles';
      case OfferCategory.tour:
        return 'Visites guidées, excursions';
      case OfferCategory.accommodation:
        return 'Hôtels, villas, chambres d\'hôtes';
      case OfferCategory.transport:
        return 'Transferts, locations de véhicules';
      case OfferCategory.site:
        return 'Musées, monuments, sites touristiques';
    }
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final int maxLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? suffix;
  final Function(String)? onChanged;

  const _InputField({
    required this.label,
    required this.hint,
    this.controller,
    this.maxLines = 1,
    this.maxLength,
    this.keyboardType,
    this.prefixIcon,
    this.suffix,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14.sp,
            ),
            prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: AppColors.primary) : null,
            suffixText: suffix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textTertiary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
