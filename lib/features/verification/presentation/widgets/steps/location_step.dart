import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/verification_bloc.dart';

/// Étape 3 : Localisation (Question 2 - Légitimité)
/// Couleur thématique : Orange (#FF9800)
class LocationStep extends StatefulWidget {
  final VoidCallback onNext;

  const LocationStep({
    super.key,
    required this.onNext,
  });

  @override
  State<LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<LocationStep> {
  final _addressController = TextEditingController();
  String? _selectedRegion;
  String? _selectedCity;

  final Map<String, List<String>> _regionCities = {
    'Atlantique': ['Cotonou', 'Abomey-Calavi', 'Ouidah', 'Allada'],
    'Ouémé': ['Porto-Novo', 'Sèmè-Kpodji', 'Adjarra', 'Avrankou'],
    'Borgou': ['Parakou', 'Nikki', 'Tchaourou', 'Bembèrèkè'],
    'Alibori': ['Kandi', 'Malanville', 'Banikoara', 'Gogounou'],
    'Collines': ['Savalou', 'Dassa-Zoumè', 'Glazoué', 'Bantè'],
    'Zou': ['Abomey', 'Bohicon', 'Djidja', 'Zagnanado'],
    'Mono': ['Lokossa', 'Comè', 'Grand-Popo', 'Houéyogbé'],
    'Couffo': ['Aplahoué', 'Djakotomey', 'Dogbo', 'Klouékanmè'],
    'Plateau': ['Pobè', 'Kétou', 'Sakété', 'Adja-Ouèrè'],
    'Donga': ['Djougou', 'Bassila', 'Copargo', 'Ouaké'],
    'Atacora': ['Natitingou', 'Tanguiéta', 'Boukoumbé', 'Kérou'],
    'Littoral': ['Cotonou'],
  };

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VerificationBloc, VerificationState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF3E0),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: const Color(0xFFFF9800),
                      size: 32.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Votre localisation',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Où les voyageurs peuvent vous trouver',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Région
              Text(
                'Département *',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedRegion,
                decoration: InputDecoration(
                  hintText: 'Sélectionnez votre département',
                  prefixIcon: const Icon(Icons.map_outlined, color: Color(0xFFFF9800)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
                  ),
                ),
                items: _regionCities.keys.map((region) {
                  return DropdownMenuItem(
                    value: region,
                    child: Text(region),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedRegion = value;
                    _selectedCity = null; // Reset ville
                  });
                  context.read<VerificationBloc>().add(
                    VerificationFieldChanged(
                      field: 'region',
                      value: value,
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),

              // Ville
              Text(
                'Commune *',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                decoration: InputDecoration(
                  hintText: 'Sélectionnez votre commune',
                  prefixIcon: const Icon(Icons.location_city_outlined, color: Color(0xFFFF9800)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
                  ),
                ),
                items: _selectedRegion != null
                    ? _regionCities[_selectedRegion]!.map((city) {
                        return DropdownMenuItem(
                          value: city,
                          child: Text(city),
                        );
                      }).toList()
                    : [],
                onChanged: _selectedRegion != null
                    ? (value) {
                        setState(() => _selectedCity = value);
                        context.read<VerificationBloc>().add(
                          VerificationFieldChanged(
                            field: 'city',
                            value: value,
                          ),
                        );
                      }
                    : null,
              ),
              SizedBox(height: 24.h),

              // Adresse complète
              Text(
                'Adresse complète *',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _addressController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Ex: Quartier Agla, derrière la pharmacie Saint-Jean, 3ème maison à gauche',
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
                  ),
                ),
                onChanged: (value) {
                  context.read<VerificationBloc>().add(
                    VerificationFieldChanged(
                      field: 'address',
                      value: value,
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),

              // Points de repère (optionnel)
              Text(
                'Points de repère (optionnel)',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8.h),
              TextFormField(
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Ex: À 200m du marché Dantokpa, près de la station Shell',
                  hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.place_outlined, color: Color(0xFFFF9800)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: Color(0xFFFF9800), width: 2),
                  ),
                ),
                onChanged: (value) {
                  context.read<VerificationBloc>().add(
                    VerificationFieldChanged(
                      field: 'landmarks',
                      value: value,
                    ),
                  );
                },
              ),
              SizedBox(height: 32.h),

              // Conseil IA
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: const Color(0xFFFF9800)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: const Color(0xFFFF9800),
                      size: 24.sp,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conseil pour les voyageurs',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE65100),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Plus votre localisation est précise, plus il sera facile pour les visiteurs de vous trouver. Mentionnez des repères connus.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}