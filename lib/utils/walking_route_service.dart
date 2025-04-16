// lib/utils/walking_route_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

Future<List<LatLng>> fetchWalkingRoute({
  required LatLng from,
  required LatLng to,
}) async {
  final apiKey = '5b3ce3597851110001cf6248396c54282079431b88ef2a847aa4be4e'; // Consíguelo gratis en openrouteservice.org
  final url =
      'https://api.openrouteservice.org/v2/directions/foot-walking?api_key=$apiKey&start=${from.longitude},${from.latitude}&end=${to.longitude},${to.latitude}';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final coords = data['features'][0]['geometry']['coordinates'] as List;
    return coords.map<LatLng>((c) => LatLng(c[1], c[0])).toList();
  } else {
    throw Exception('Error obteniendo ruta: ${response.body}');
  }
}
