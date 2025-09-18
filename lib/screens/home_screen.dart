import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'login_screen.dart';
import '../services/auth_service.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  String? _currentSong;
  String? _username; 
  final AuthService _authService = AuthService();

  final List<Map<String, String>> songs = [
    {"file": "ElTriste.mp3", "title": "El Triste", "img": "assets/img/eltriste.jpeg"},
    {"file": "UnaCerveza.mp3", "title": "Una Cerveza", "img": "assets/img/unacerveza.jpeg"},
    {"file": "Bolerito.mp3", "title": "Bolerito", "img": "assets/img/bolerito.jpeg"},
  ];

  String _query = "";

  @override
  void initState() {
    super.initState();
    _loadUser(); 
  }

  Future<void> _loadUser() async {
    final storedUsername = await _authService.getUsername();
    setState(() {
      _username = storedUsername;
    });
  }

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
          margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Image.asset("assets/img/Monicool_logo.png", height: 40, fit: BoxFit.contain),
        ),
        actions: [
          if (_username != null) 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white),
                  const SizedBox(width: 6),
                  Text(_username!, style: const TextStyle(color: Colors.white)),
                  TextButton(
                    onPressed: () async {
                      await _authService.logout();
                      setState(() {
                        _username = null;
                      });
                    },
                    child: const Text("Salir", style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          else 
            IconButton(
              icon: const Icon(Icons.login, color: Colors.white),
              tooltip: "Iniciar sesión",
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                _loadUser(); 
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
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: "Buscar canción...",
                ),
                onChanged: (val) => setState(() => _query = val),
              ),
            ),

            // poster destacado
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset("assets/img/poster.png", fit: BoxFit.fitWidth, width: double.infinity),
              ),
            ),

            // lista de canciones
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredSongs.length,
              itemBuilder: (context, index) {
                final song = filteredSongs[index];
                return GestureDetector(
                  onTap: () => _playSong(song["file"]!, song["title"]!),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(backgroundImage: AssetImage(song["img"]!)),
                      title: Text(song["title"]!, style: const TextStyle(color: Colors.white)),
                      trailing: const Icon(Icons.play_arrow, color: Colors.white),
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
                      child: Text("Reproduciendo: $_currentSong",
                          style: const TextStyle(color: Colors.white)),
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
