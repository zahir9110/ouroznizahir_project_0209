import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart';

/// Régions du Bénin pour le filtrage géographique
enum BeninRegion {
  all('Tout le Bénin', null),
  cotonou('Cotonou', 6.3654),
  portoNovo('Porto-Novo', 6.4969),
  parakou('Parakou', 9.3376),
  ouidah('Ouidah', 6.3630),
  abomeyCalavi('Abomey-Calavi', 6.4487),
  djougou('Djougou', 9.7086),
  bohicon('Bohicon', 7.1782),
  kandi('Kandi', 11.1304),
  natitingou('Natitingou', 10.3165),
  savalou('Savalou', 7.9283);

  final String displayName;
  final double? latitude; // null pour "Tout le Bénin"

  const BeninRegion(this.displayName, this.latitude);
}

/// Widget de filtrage géographique
/// Slider distance + Dropdown régions + Bouton localisation
class LocationFilter extends StatefulWidget {
  final BeninRegion selectedRegion;
  final double maxDistance;
  final bool useUserLocation;
  final Function(BeninRegion region) onRegionChanged;
  final Function(double distance) onDistanceChanged;
  final Function(bool useLocation) onUseLocationChanged;

  const LocationFilter({
    super.key,
    this.selectedRegion = BeninRegion.all,
    this.maxDistance = 50,
    this.useUserLocation = false,
    required this.onRegionChanged,
    required this.onDistanceChanged,
    required this.onUseLocationChanged,
  });

  @override
  State<LocationFilter> createState() => _LocationFilterState();
}

class _LocationFilterState extends State<LocationFilter> {
  final LocationService _locationService = LocationService();
  bool _isLoadingLocation = false;

  @override
  Widget build(BuildContext context) {
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
          // Header
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 20.r,
                color: AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Text(
                'Filtrer par localisation',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Utiliser ma position
          _buildUseLocationToggle(),

          // Dropdown régions (si pas position utilisateur)
          if (!widget.useUserLocation) ...[
            SizedBox(height: 16.h),
            _buildRegionDropdown(),
          ],

          // Slider distance
          SizedBox(height: 16.h),
          _buildDistanceSlider(),
        ],
      ),
    );
  }

  Widget _buildUseLocationToggle() {
    return InkWell(
      onTap: _isLoadingLocation ? null : _handleToggleLocation,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: widget.useUserLocation
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surfaceGray,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: widget.useUserLocation
                ? AppColors.primary
                : AppColors.divider,
            width: widget.useUserLocation ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (_isLoadingLocation)
              SizedBox(
                width: 20.r,
                height: 20.r,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              )
            else
              Icon(
                widget.useUserLocation
                    ? Icons.my_location
                    : Icons.location_searching,
                size: 20.r,
                color: widget.useUserLocation
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.useUserLocation
                        ? 'Ma position actuelle'
                        : 'Utiliser ma position',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: widget.useUserLocation
                          ? AppColors.primary
                          : AppColors.textPrimary,
                    ),
                  ),
                  if (widget.useUserLocation)
                    Text(
                      'Offres triées par distance',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              widget.useUserLocation
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              size: 24.r,
              color: widget.useUserLocation
                  ? AppColors.primary
                  : AppColors.divider,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionDropdown() {
    return DropdownButtonFormField<BeninRegion>(
      value: widget.selectedRegion,
      decoration: InputDecoration(
        labelText: 'Région',
        prefixIcon: Icon(Icons.map, size: 20.r),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
      ),
      items: BeninRegion.values.map((region) {
        return DropdownMenuItem(
          value: region,
          child: Text(
            region.displayName,
            style: TextStyle(fontSize: 14.sp),
          ),
        );
      }).toList(),
      onChanged: (region) {
        if (region != null) {
          widget.onRegionChanged(region);
        }
      },
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Distance maximum',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                '${widget.maxDistance.toInt()} km',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.divider,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withOpacity(0.2),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.r),
          ),
          child: Slider(
            value: widget.maxDistance,
            min: 5,
            max: 200,
            divisions: 39, // (200-5)/5 = 39 steps de 5km
            label: '${widget.maxDistance.toInt()} km',
            onChanged: (value) {
              widget.onDistanceChanged(value);
            },
          ),
        ),
        // Labels min/max
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '5 km',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiary,
                ),
              ),
              Text(
                '200 km',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleToggleLocation() async {
    if (widget.useUserLocation) {
      // Désactiver
      widget.onUseLocationChanged(false);
      return;
    }

    // Activer - demander permission et obtenir position
    setState(() => _isLoadingLocation = true);

    try {
      final position = await _locationService.getCurrentPosition();
      
      if (position != null) {
        widget.onUseLocationChanged(true);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white, size: 20.r),
                  SizedBox(width: 8.w),
                  const Text('Position obtenue avec succès'),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.white, size: 20.r),
                  SizedBox(width: 8.w),
                  const Expanded(
                    child: Text('Impossible d\'obtenir votre position. Vérifiez les permissions.'),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFEF4444),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Paramètres',
                textColor: Colors.white,
                onPressed: () {
                  Geolocator.openLocationSettings();
                },
              ),
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }
}
