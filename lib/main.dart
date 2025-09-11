import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MonicoolApp());
}

class MonicoolApp extends StatelessWidget {
  const MonicoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Monicool",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF121212), // fondo oscuro
        primaryColor: const Color(0xFF1A1919),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const HomeScreen(),
    );
  }
}

/// Pantalla principal
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  String? _currentSong;

  final List<Map<String, String>> songs = [
    {
      "file": "ElTriste.mp3",
      "title": "El Triste",
      "img": "assets/img/eltriste.jpeg",
    },
    {
      "file": "UnaCerveza.mp3",
      "title": "Una Cerveza",
      "img": "assets/img/unacerveza.jpeg",
    },
    {
      "file": "Bolerito.mp3",
      "title": "Bolerito",
      "img": "assets/img/bolerito.jpeg",
    },
  ];

  String _query = "";

  void _playSong(String file, String title) async {
    await player.stop();
    await player.play(AssetSource("audio/$file"));
    setState(() {
      _currentSong = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredSongs = songs
        .where((s) => s["title"]!.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1919),
        title: Container(
          margin: const EdgeInsets.symmetric(
            vertical: 18, // más espacio arriba y abajo
            horizontal: 16,
          ),
          child: Image.asset(
            "assets/img/Monicool_logo.png",
            height: 40, // menor altura para que no se corte
            fit: BoxFit.contain,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login, color: Colors.white),
            tooltip: "Iniciar sesión",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Abrir pantalla de login")),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // buscador
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black54,
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  hintText: "Buscar canción...",
                  hintStyle: const TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (val) => setState(() => _query = val),
              ),
            ),

            // poster destacado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  "assets/img/poster.png",
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                ),
              ),
            ),

            // lista de canciones
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => _playSong(song["file"]!, song["title"]!),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(song["img"]!),
                        ),
                        title: Text(
                          song["title"]!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // barra inferior de reproducción
            if (_currentSong != null)
              Container(
                color: const Color(0xFF1A1919),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "Reproduciendo: $_currentSong",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.pause, color: Colors.white),
                      onPressed: () => player.pause(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      onPressed: () => player.resume(),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
