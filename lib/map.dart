import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'ar_flutter.dart';
import 'package:flutter/services.dart';


class Map extends StatefulWidget {
  final String routeName;
  const Map({super.key, required this.routeName});

  @override
  State<Map> createState() => _MapState();
}

Future<List<LatLng>> _fetchRouteCoordinates(String routeName) async {
  try {
    // Carga el archivo txt desde los assets
    final String route = await rootBundle.loadString('assets/coords.txt');

    // Toma la primera línea que coincide y extrae las coordenadas
    final String coordinatesString = route.split(' ').skip(1).join(' ');

    // Convierte las coordenadas en una lista de LatLng
    final List<LatLng> coordinates =
        coordinatesString.split(' ').map((coord) {
          final List<String> latLng = coord.split(',');
          // Corrige el orden: LatLng(latitude, longitude)
          return LatLng(double.parse(latLng[1]), double.parse(latLng[0]));
        }).toList();

    return coordinates;
  } catch (e) {
    print('Error al cargar las coordenadas de la ruta: $e');
    return [];
  }
}

Future<List> _fetchInterestPoints(String routeName) async {
  // Explicitly type the list literal to match the return type
  return [
    {
      "name": "fuente fontanesca",
      "longitud": -8.664634,
      "latitud": 42.173464,
      "descripcion": "Una fuente histórica.",
      "type": "font",
    },
    {
      "name": "fuente de la vida",
      "longitud": -8.614906,
      "latitud": 42.177822,
      "descripcion": "Una fuente moderna.",
      "type": "font",
    },
    {
      "name": "fuente de la esperanza",
      "longitud": -8.579773,
      "latitud": 42.172906,
      "descripcion": "Una fuente emblemática.",
      "type": "font",
    },
  ];
}


class _MapState extends State<Map> {
  LatLng _currentPosition = LatLng(0, 0); // Inicializa la posición actual
  List<LatLng> _routeCoordinates = [];
  final MapController _mapController = MapController();
  bool _isExpanded = false; // Controla si el menú está expandido
  List _interestPoints = []; // Lista de puntos de interés

  @override
  void initState() {
    super.initState();
    _loadRouteCoordinates();
    _getCurrentLocation();
    _getInterestPoints();
  }

  Future<void> _loadRouteCoordinates() async {
    final coordinates = await _fetchRouteCoordinates(widget.routeName);
    setState(() {
      _routeCoordinates = coordinates;
    });
  }


  Future<void> _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error al obtener la ubicación: $e');
    }
  }

  Future<void> _getInterestPoints() async {
    try {
      final points = await _fetchInterestPoints(widget.routeName);
      setState(() {
        _interestPoints = points;
      });
      print(_interestPoints);
    } catch (e) {
      print('Error al cargar los puntos de interés: $e');
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
      home: Builder(
        builder: (context) => Scaffold(
          body: _currentPosition.latitude == 0 && _currentPosition.longitude == 0
              ? const Center(
                  child: CircularProgressIndicator(), // Muestra un indicador de carga
                )
              : Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: LatLng(
                          _currentPosition.latitude,
                          _currentPosition.longitude,
                        ),
                        initialZoom: 15,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.app',
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                              ),
                              width: 1000,
                              height: 1000,
                              child: GestureDetector(
                                onTap: () {
                                  _showOverlay(context);
                                },
                                child: const Icon(
                                  Icons.location_on,
                                  size: 40,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                              ..._interestPoints.map((point) {
                                    return Marker(
                                      point: LatLng(point['latitud'], point['longitud']),
                                      width: 80,
                                      height: 80,
                                      child: GestureDetector(
                                        onTap: () {
                                          _showInterestPointOverlay(context, point);
                                        },
                                        child: const Icon(
                                          Icons.foundation,
                                          size: 30,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    );
                                  }).toList(),

                          ],
                        ),
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: _routeCoordinates,
                              color: Colors.red,
                              strokeWidth: 5,
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Botón desplegable
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isExpanded) ...[
                            FloatingActionButton(
                              heroTag: 'btnAR',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ObjectsOnPlanes(),
                                  ),
                                );
                              },
                              child: const Icon(Icons.view_in_ar),
                              backgroundColor: Colors.green[700],
                            ),
                            const SizedBox(height: 10),
                            FloatingActionButton(
                              heroTag: 'btnLocate',
                              onPressed: () {
                                _mapController.move(
                                  LatLng(
                                    _currentPosition.latitude,
                                    _currentPosition.longitude,
                                  ),
                                  15, // Nivel de zoom
                                );
                              },
                              child: const Icon(Icons.my_location),
                            ),
                            const SizedBox(height: 10),
                          ],
                          FloatingActionButton(
                            heroTag: 'btnExpand',
                            onPressed: () {
                              setState(() {
                                _isExpanded = !_isExpanded; // Alterna el estado
                              });
                            },
                            child: Icon(
                              _isExpanded ? Icons.close : Icons.menu,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }



  void _showOverlay(BuildContext context) {
    final overlay = Overlay.of(context);

    late final OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
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
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Información del marcador',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                      'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
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



  void _showInterestPointOverlay(BuildContext context, point) {
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
                color: Colors.black.withOpacity(0.2),
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
}
