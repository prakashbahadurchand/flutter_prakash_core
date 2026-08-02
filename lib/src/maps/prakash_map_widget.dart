import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PrakashMapWidget extends StatelessWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final List<Marker> markers;

  const PrakashMapWidget({
    super.key,
    required this.initialCenter,
    this.initialZoom = 13.0,
    this.markers = const [],
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: initialCenter,
        initialZoom: initialZoom,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.prakashbahadurchand.flutter_prakash',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
