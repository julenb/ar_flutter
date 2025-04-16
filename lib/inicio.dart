import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about.dart';
import 'map.dart';
import 'widgets/cards/route_list_view.dart';
import 'utils/petitions.dart';
import 'main.dart';

class Inicio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rutas',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Santiago y Roma
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rutas'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Santiago'),
              Tab(text: 'Roma'),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const SizedBox(height: 50),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.blue),
                title: const Text('Acerca de'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutScreen()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Cerrar sesión'),
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
        body: TabBarView(
          children: [
            RouteListView(
              ruta: 'Santiago',
              cards: getCardInformation('Santiago'),
              onCardTap: (card) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Map(routeName: card["name"]),
                  ),
                );
              },
            ),
            RouteListView(
              ruta: 'Roma',
              cards: getCardInformation('Roma'),
              onCardTap: (card) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Map(routeName: card["name"]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
