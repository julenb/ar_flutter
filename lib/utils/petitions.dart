
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import 'dart:convert';


List getDaysInformation(String route){
  //TODO: Cambiar a una llamada a la API para obtener la información de las rutas
  List cardsJson = [
    {
    "day": "1",
    "pois": [
      {
        "name": "Arrancando desde Redondela",
        "longitud": 10,
        "image": "aragon.jpg",
      },
      {
        "name": "Cesantes",
        "longitud": 20,
        "image": "costa.jpg",
      },
      {
        "name": "San Simón",
        "longitud": 30,
        "image": "montana.jpg",
      },
      {
        "name": "Mirador Outeiro Grande",
        "longitud": 40,
        "image": "rio.jpg",
      },
      {
        "name": "Pontevedra",
        "longitud": 50,
        "image": "bosque.jpg",
      }
    ]
  },

    {
      "day": "2",
      "pois": [
        {
          "name": "Arrancando desde Pontevedra",
          "longitud": 10,
          "image": "aragon.jpg",
        },
        {
          "name": "Fonte do Curro",
          "longitud": 50,
          "image": "bosque.jpg",
        }
      ]
    },

  ]as List;


  return cardsJson;
}




List getCardInformation(String route){
  //TODO: Cambiar a una llamada a la API para obtener la información de las rutas
  List cardsJson = [
    {
      "name": "camino aragon",
      "longitud": 10,
      "image": "aragon.jpg",
    },
    {
      "name": "camino de la costa",
      "longitud": 20,
      "image": "costa.jpg",
    },
    {
      "name": "camino de la montaña",
      "longitud": 30,
      "image": "montana.jpg",
    },
    {
      "name": "camino del río",
      "longitud": 40,
      "image": "rio.jpg",
    },
    {
      "name": "camino del bosque",
      "longitud": 50,
      "image": "bosque.jpg",
    },
  ] as List;


  return cardsJson;
}



Future<List<LatLng>> fetchRouteCoordinates(String routeName) async {
  try {
    // Carga el archivo JSON desde los assets
    final String jsonString = await rootBundle.loadString('data/coords.json');
    final Map<String, dynamic> data = json.decode(jsonString);

    final List coordinatesRaw = data['coordinates'];

    // Transforma cada par [long, lat] en LatLng(lat, long)
    final List<LatLng> coordinates = coordinatesRaw.map<LatLng>((pair) {
      return LatLng(pair[1], pair[0]);
    }).toList();

    return coordinates;
  } catch (e) {
    print('Error al cargar las coordenadas de la ruta: $e');
    return [];
  }
}

Future<List> fetchInterestPoints(String routeName) async {
  // Explicitly type the list literal to match the return type
  return [
    {
      "name": "Fuente del Roble",
      "longitud": -8.584400,
      "latitud": 42.288000,
      "descripcion": "Fuente ubicada en la entrada del parque.",
      "type": "font",
    },
    {
      "name": "Manantial de los Sueños",
      "longitud": -8.614250,
      "latitud": 42.320150,
      "descripcion": "Una pequeña fuente natural.",
      "type": "font",
    },
    {
      "name": "Fuente de los Aromas",
      "longitud": -8.604600,
      "latitud": 42.370200,
      "descripcion": "Con jardines aromáticos alrededor.",
      "type": "font",
    },
  ];
}
