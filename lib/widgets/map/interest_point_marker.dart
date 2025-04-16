// lib/widgets/interest_point_marker.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class InterestPointMarker extends Marker {
  InterestPointMarker({
    required Map<String, dynamic> point,
    required BuildContext context,
  }) : super(
    point: LatLng(point['latitud'], point['longitud']),
    width: 50,
    height: 50,
    child: GestureDetector(
      onTap: () {
        _showInterestPointOverlay(context, point);
      },
      child: SizedBox(
        child: Image.asset('images/fountain.png'),
      ),
    ),
  );
}

void _showInterestPointOverlay(BuildContext context, Map<String, dynamic> point) {
  final overlay = Overlay.of(context);
  late final OverlayEntry overlayEntry;
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height / 2 - 100,
      left: MediaQuery.of(context).size.width / 2 - 150,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(51), // 20% opacidad
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                point['name'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                point['descripcion'],
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  overlayEntry.remove();
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
}
