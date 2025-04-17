import 'package:ar_flutter/route_stages_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';
import 'map.dart';
import 'widgets/cards/route_list_view.dart';
import 'utils/petitions.dart';
import 'main.dart'; // Para AuthWrapper

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  ThemeMode _themeMode = ThemeMode.light; // Modo claro por defecto

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme') ?? 'light';

    setState(() {
      _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
    await prefs.setString('theme', isDark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rutas',
      theme: ThemeData(
        primaryColor: const Color(0xFF4D94E1),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: MainScreen(
        onThemeToggle: _toggleTheme,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final void Function(bool) onThemeToggle;
  final bool isDark;

  const MainScreen({
    super.key,
    required this.onThemeToggle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rutas'),
          bottom: const TabBar(
            indicatorColor: Color(0xFF4D94E1),
            labelColor: Color(0xFF4D94E1),
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

              // Switch para modo oscuro
              SwitchListTile(
                title: const Text('Modo oscuro'),
                secondary: const Icon(Icons.brightness_6, color: Colors.orange),
                value: isDark,
                onChanged: onThemeToggle,
              ),

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
                    builder: (context) => RouteStagesScreen(routeName: card["name"]),
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
                    builder: (context) => RouteStagesScreen(routeName: card["name"]),
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
