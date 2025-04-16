
// lib/widgets/custom_map.dart
import 'package:ar_flutter/widgets/map/route_endpoint_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'current_location_marker.dart';
import 'interest_point_marker.dart';

class CustomMap extends StatelessWidget {
  final LatLng currentPosition;
  final MapController mapController;
  final List interestPoints;
  final List<LatLng> routeCoordinates;
  final List<LatLng> walkingRoute;

  const CustomMap({
    super.key,
    required this.currentPosition,
    required this.mapController,
    required this.interestPoints,
    required this.routeCoordinates,
    required this.walkingRoute,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: currentPosition,
        initialZoom: 15,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.pilgrimsapp',
        ),

        PolylineLayer(
          polylines: [
            Polyline(
              points: routeCoordinates,
              color: Colors.red,
              strokeWidth: 5,
            ),
            if (walkingRoute.isNotEmpty)
              Polyline(
                points: walkingRoute,
                color: Colors.blue,
                strokeWidth: 4,
              ),          ],
        ),
        MarkerLayer(
          markers: [
            CurrentLocationMarker(
              position: currentPosition,
              context: context,
            ),
            if (routeCoordinates.isNotEmpty) ...[
              RouteEndpointMarker(position: routeCoordinates.first),
              RouteEndpointMarker(position: routeCoordinates.last),
            ],
            ...interestPoints.map((point) {
              return InterestPointMarker(
                point: point,
                context: context,
              );
            }).toList(),
          ],
        ),
      ],
    );
  }
}

