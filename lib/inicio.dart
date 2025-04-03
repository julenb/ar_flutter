import 'package:flutter/material.dart';
import 'map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'about.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Map()),
                );
              },
              child: Text('Ir al Mapa'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
