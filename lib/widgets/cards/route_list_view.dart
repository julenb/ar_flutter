import 'package:flutter/material.dart';

class RouteListView extends StatelessWidget {
  final String ruta;
  final List cards;
  final void Function(Map<String, dynamic>) onCardTap;

  const RouteListView({
    super.key,
    required this.ruta,
    required this.cards,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        var card = cards[index];
        return GestureDetector(
          onTap: () => onCardTap(card),
          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: MediaQuery.of(context).size.height / cards.length,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'images/${card["image"]}',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.5),
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
    );
  }
}
