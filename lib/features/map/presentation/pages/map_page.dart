import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

/// Page carte interactive avec points d'intérêt à Cotonou
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() {
    // Points d'intérêt à Cotonou (mock data)
    final points = [
      {'lat': 6.3703, 'lng': 2.3912, 'name': 'Place de l\'Étoile Rouge'},
      {'lat': 6.3667, 'lng': 2.4333, 'name': 'Marché Dantokpa'},
      {'lat': 6.3489, 'lng': 2.4394, 'name': 'Plage de Cotonou'},
    ];

    setState(() {
      _markers.addAll(
        points.map((point) => Marker(
              point: LatLng(point['lat'] as double, point['lng'] as double),
              width: 80.w,
              height: 80.h,
              child: Icon(
                Icons.location_on,
                size: 40.w,
                color: AppColors.primary,
              ),
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carte',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: const MapOptions(
          initialCenter: LatLng(6.3667, 2.4333), // Cotonou
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.benin_experience',
          ),
          MarkerLayer(markers: _markers),
        ],
      ),
    );
  }
}