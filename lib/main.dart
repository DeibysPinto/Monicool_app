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
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: const Color(0xFF1A1919),
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.black54,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          hintStyle: const TextStyle(color: Colors.white70),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

//
// Pantalla principal (Home)
//
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final player = AudioPlayer();
  String? _currentSong;

  final List<Map<String, String>> songs = [
    {"file": "ElTriste.mp3", "title": "El Triste", "img": "assets/img/eltriste.jpeg"},
    {"file": "UnaCerveza.mp3", "title": "Una Cerveza", "img": "assets/img/unacerveza.jpeg"},
    {"file": "Bolerito.mp3", "title": "Bolerito", "img": "assets/img/bolerito.jpeg"},
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
          margin: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          child: Image.asset("assets/img/Monicool_logo.png", height: 40, fit: BoxFit.contain),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.login, color: Colors.white),
            tooltip: "Iniciar sesión",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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

//
// Pantalla de Login
//
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bienvenido, ${_emailCtrl.text}!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1919),
        title: const Text("Ingresar"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Image.asset("assets/img/Monicool_logo.png", height: 80),
              const SizedBox(height: 20),
              const Text("Ingrese sus datos",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Correo"),
                      validator: (val) =>
                          val != null && val.contains("@") ? null : "Ingrese un correo válido",
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Contraseña"),
                      validator: (val) =>
                          val != null && val.length >= 6 ? null : "Mínimo 6 caracteres",
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _login,
                        child: const Text("Ingresar", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                      },
                      child: const Text("¿No tienes cuenta? Registrarse",
                          style: TextStyle(color: Colors.white70)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// Pantalla de Registro
//
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Usuario registrado: ${_nameCtrl.text}")),
      );
      Navigator.pop(context); // volver al login o home
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1919),
        title: const Text("Registrarse"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text("Ingrese sus datos",
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: "Correo"),
                      validator: (val) =>
                          val != null && val.contains("@") ? null : "Ingrese un correo válido",
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(hintText: "Nombre de usuario"),
                      validator: (val) =>
                          val != null && val.isNotEmpty ? null : "Ingrese un nombre",
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordCtrl,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: const InputDecoration(hintText: "Contraseña"),
                      validator: (val) =>
                          val != null && val.length >= 6 ? null : "Mínimo 6 caracteres",
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purpleAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: _register,
                        child: const Text("Enviar", style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}