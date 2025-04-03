import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  final List<Map<String, String>> developers = [
    {
      'name': 'Julen Beiro Suso',
      'linkedin': 'https://www.linkedin.com/in/jbeiro/',
      'email': 'mailto:jbeiro@gti.uvigo.es'
    },
    {
      'name': 'Alejandro Pajón Sanmartin',
      'linkedin': 'https://www.linkedin.com/in/apajon/',
      'email': 'mailto:apajon@gti.uvigo.es'
    },
    {
      'name': 'Anxo Gesto Gayoso',
      'linkedin': 'https://www.linkedin.com/in/anxo/',
      'email': 'mailto:agesto@gti.uvigo.es'
    },
    {
      'name': 'Francisco de Arriba Pérez',
      'linkedin': 'https://www.linkedin.com/in/franciscodearriba/',
      'email': 'mailto:farriba@gti.uvigo.es'
    },
    {
      'name': 'Silvia García Méndez',
      'linkedin': 'https://www.linkedin.com/in/silviamndez/',
      'email': 'mailto:sgarcia@gti.uvigo.es'
    },
  ];

  /// Función para abrir enlaces correctamente con `url_launcher`
void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    throw Exception('No se pudo abrir el enlace: $url');
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acerca de')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Desarrolladores:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...developers.map((dev) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dev['name']!,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: FaIcon(FontAwesomeIcons.linkedin, color: Colors.blue, size: 50),
                          onPressed: () => _launchURL(dev['linkedin']!),
                        ),
                        IconButton(
                          icon: Icon(Icons.email, color: Colors.red, size: 50),
                          onPressed: () => _launchURL(dev['email']!),
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
