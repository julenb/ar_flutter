// lib/widgets/floating_buttons.dart
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onLocatePressed;

  const FloatingButtons({
    super.key,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onLocatePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isExpanded) ...[
          if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
            FloatingActionButton(
              heroTag: 'btnAR',
              onPressed: () {
                Navigator.pushNamed(context, '/ar'); // o navega como prefieras
              },
              child: const Icon(Icons.view_in_ar),
              backgroundColor: Colors.green[700],
            ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'btnLocate',
            onPressed: onLocatePressed,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
        ],
        FloatingActionButton(
          heroTag: 'btnExpand',
          onPressed: onToggleExpand,
          child: Icon(isExpanded ? Icons.close : Icons.menu),
        ),
      ],
    );
  }
}
