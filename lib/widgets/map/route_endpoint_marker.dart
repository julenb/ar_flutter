// lib/widgets/route_endpoint_marker.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class RouteEndpointMarker extends Marker {
  RouteEndpointMarker({
    required LatLng position,
  }) : super(
    point: position,
    width: 40,
    height: 40,
    child: const Icon(
      Icons.location_on,
      size: 36,
      color: Colors.red,
    ),
  );
}
