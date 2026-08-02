import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';

/// Marker cluster layer that groups nearby markers into a single cluster.
///
/// Wraps [MarkerClusterLayerWidget] with sensible defaults and a styled
/// counter badge. It must be placed inside a [flutter_map]'s [FlutterMap]
/// children (via [ClusterMarkerLayer] typically alongside [MarkerLayer]).
class ClusterMarkerLayer extends StatelessWidget {
  final List<Marker> markers;
  final int maxClusterRadius;
  final double markerSize;
  final double maxZoom;

  const ClusterMarkerLayer({
    super.key,
    required this.markers,
    this.maxClusterRadius = 80,
    this.markerSize = 45,
    this.maxZoom = 17.0,
  });

  @override
  Widget build(BuildContext context) {
    return MarkerClusterLayerWidget(
      options: MarkerClusterLayerOptions(
        maxClusterRadius: maxClusterRadius,
        size: Size(markerSize, markerSize),
        alignment: Alignment.center,
        maxZoom: maxZoom,
        showPolygon: false,
        markers: markers,
        builder: (context, markers) => _ClusterBadge(count: markers.length),
      ),
    );
  }
}

class _ClusterBadge extends StatelessWidget {
  final int count;
  const _ClusterBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: scheme.primaryContainer,
        border: Border.all(color: scheme.primary, width: 2),
      ),
      child: Text(
        '$count',
        style: TextStyle(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
