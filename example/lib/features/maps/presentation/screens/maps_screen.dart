import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:latlong2/latlong.dart';

import '../../../../shared/widgets/wrappers.dart';

/// Presents the Maps & Location feature.
///
/// Clean Architecture **presentation** layer.
class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  static const _kathmandu = LatLng(27.7172, 85.324);
  bool _permission = false;

  final List<Marker> _markers = [
    for (var i = 0; i < 12; i++)
      Marker(
        point: LatLng(27.7172 + (i % 3) * 0.01, 85.324 + (i % 4) * 0.015),
        width: 36,
        height: 36,
        child: const Icon(Icons.location_on, color: Colors.red, size: 34),
      ),
  ];

  List<Marker> get _clusterMarkers => [
    for (var i = 0; i < 8; i++)
      Marker(
        point: LatLng(27.70 + (i % 2) * 0.02, 85.32 + (i % 3) * 0.02),
        width: 30,
        height: 30,
        child: const Icon(Icons.pin_drop, color: Colors.blue, size: 30),
      ),
  ];

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await LocationService().hasPermission();
    setState(() => _permission = granted);
  }

  Future<void> _requestLocation() async {
    final messenger = ScaffoldMessenger.of(context);
    final granted = await LocationService().requestPermission();
    setState(() => _permission = granted);
    messenger.showSnackBar(
      SnackBar(content: Text(granted ? 'Location granted' : 'Location denied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DemoScaffold(
      title: 'Maps & Location',
      child: Column(
        children: [
          DemoCard(
            title: 'Flutter Map with Markers',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle,
                  color: _permission ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                TextButton(
                  onPressed: _requestLocation,
                  child: const Text('Grant'),
                ),
              ],
            ),
            child: SizedBox(
              height: 260,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: PrakashMapWidget(
                  initialCenter: _kathmandu,
                  initialZoom: 13,
                  markers: _markers,
                ),
              ),
            ),
          ),
          DemoCard(
            title: 'Marker Clustering',
            child: SizedBox(
              height: 220,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: const MapOptions(
                    initialCenter: _kathmandu,
                    initialZoom: 10,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName:
                          'com.prakashbahadurchand.flutter_prakash',
                    ),
                    ClusterMarkerLayer(markers: _clusterMarkers),
                  ],
                ),
              ),
            ),
          ),
          DemoCard(
            title: 'Location Permissions',
            child: Text(
              'PermissionStatus handled by PermissionService — LocationService '
              'adds the native getCurrentLocation() bridge.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}