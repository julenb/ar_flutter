import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'ar_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/map/custom_map.dart';
import 'widgets/map/floating_buttons.dart';
import 'utils/petitions.dart';
import 'utils/walking_route_service.dart';

class Map extends StatefulWidget {
  final String routeName;
  const Map({super.key, required this.routeName});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  LatLng _currentPosition = LatLng(0, 0); // Inicializa la posición actual
  List<LatLng> _routeCoordinates = [];
  final MapController _mapController = MapController();
  bool _isExpanded = false; // Controla si el menú está expandido
  List _interestPoints = []; // Lista de puntos de interés
  List<LatLng> _walkingRoute = [];


  @override
  void initState() {
    super.initState();
    _loadRouteCoordinates();
    _getCurrentLocation();
    _getInterestPoints();
  }

  Future<void> _loadRouteCoordinates() async {
    final coordinates = await fetchRouteCoordinates(widget.routeName);
    setState(() {
      _routeCoordinates = coordinates;
    });
    _loadWalkingRoute();
  }


  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      _loadWalkingRoute();
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _getInterestPoints() async {
    try {
      final points = await fetchInterestPoints(widget.routeName);
      setState(() {
        _interestPoints = points;
      });
      print(_interestPoints);
    } catch (e) {
      print('Error al cargar los puntos de interés: $e');
    }
  }

  Future<void> _loadWalkingRoute() async {
    if (_routeCoordinates.isEmpty || _currentPosition.latitude == 0) return;

    try {
      final route = await fetchWalkingRoute(
        from: _currentPosition,
        to: _routeCoordinates.first,
      );
      setState(() {
        _walkingRoute = route;
      });
    } catch (e) {
      print('Error al cargar la ruta peatonal: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('El servicio de ubicación está deshabilitado.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Los permisos de ubicación están denegados permanentemente.',
      );
    }

    // Obtén la posición actual
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF4D94E1), // azul personalizado
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFF4D94E1),
          secondary: Colors.amber,
        ),
        // puedes seguir personalizando aquí
      ),
      home: Builder(
          builder: (context) => Scaffold(
            body: _currentPosition.latitude == 0 && _currentPosition.longitude == 0
                ? const Center(child: CircularProgressIndicator())
                : Stack(
              children: [
                CustomMap(
                  currentPosition: _currentPosition,
                  mapController: _mapController,
                  interestPoints: _interestPoints,
                  // onLocationTap: () => _showOverlay(context),
                  routeCoordinates: _routeCoordinates,
                  walkingRoute: _walkingRoute,
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingButtons(
                    isExpanded: _isExpanded,
                    onToggleExpand: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    onLocatePressed: () {
                      _mapController.move(
                        LatLng(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                        ),
                        15,
                      );
                    },
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

}
