// 📄 lib/screens/route_stages_screen.dart

import 'package:ar_flutter/utils/petitions.dart';
import 'package:flutter/material.dart';
import 'map.dart';

class RouteStagesScreen extends StatefulWidget {
  final String routeName;

  const RouteStagesScreen({super.key, required this.routeName});

  @override
  State<RouteStagesScreen> createState() => _RouteStagesScreenState();
}

class _RouteStagesScreenState extends State<RouteStagesScreen> {
  int _currentDayIndex = 0;
  late final List daysData;

  @override
  void initState() {
    super.initState();
    daysData = getDaysInformation(widget.routeName);
  }

  void _goToMap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Map(routeName: widget.routeName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pois = daysData[_currentDayIndex]['pois'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Etapa ${daysData[_currentDayIndex]['day']}'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysData.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentDayIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentDayIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? const Color(0xFF4D94E1) : Colors.grey[300],
                    ),
                    child: Center(
                      child: Text(
                        daysData[index]['day'],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: pois.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: const [
                    Icon(Icons.more_vert, size: 20, color: Colors.grey),
                  ],
                ),
              ),
              itemBuilder: (context, index) {
                final poi = pois[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.asset(
                          'images/${poi['image']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 24),
                          ),
                        ),
                      ),
                    ),
                    title: Text(poi['name']),
                    subtitle: Text('Longitud: ${poi['longitud']} km'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[100],
        onPressed: _goToMap,
        child: const Icon(Icons.map),
      ),
    );
  }
}


