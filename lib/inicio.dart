import 'package:flutter/material.dart';
import 'map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'about.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rutas',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(), // Tema oscuro
      themeMode: ThemeMode.system, // Detecta el modo del sistema
      home: MainScreen(),
    );
  }
}

List getCardInformation(){
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




class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List cards = getCardInformation();

    return Scaffold(
      appBar: AppBar(title: Text('Rutas')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(height: 50),

            /// Opción "Acerca de" con icono
            ListTile(
              leading: Icon(
                Icons.info,
                color: Colors.blue,
              ), // Ícono de información
              title: Text('Acerca de'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),

            /// Botón de cierre de sesión
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: Colors.red,
              ), // Ícono de salir
              title: Text('Cerrar sesión'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const AuthWrapper()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: cards.length,
        itemBuilder: (context, index) {
          var card = cards[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Map(routeName: card["name"],)),
              );
            },
            child: Card(
              margin: EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados para el contenido
                child: Container(
                  height: MediaQuery.of(context).size.height / cards.length,
                  child: Stack(
                    children: [
                      // Imagen de fondo
                      Positioned.fill(
                        child: Image.asset(
                          'assets/${card["image"]}',
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Contenido de la carta
                      Container(
                        color: Colors.black.withOpacity(0.5), // Fondo semitransparente
                        child: ListTile(
                          title: Text(
                            card["name"],
                            style: TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "Longitud: ${card["longitud"]} km",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
