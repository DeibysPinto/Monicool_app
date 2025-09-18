import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final token = await _authService.login(
        _userCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
      if (token != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bienvenido, ${_userCtrl.text}!")),
        );
        Navigator.pop(context, _userCtrl.text);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al iniciar sesión")),
        );
      }
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Ingrese sus datos",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _userCtrl,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(hintText: "Usuario"),
                  validator: (val) => val != null && val.isNotEmpty ? null : "Ingrese un usuario",
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "Contraseña"),
                  validator: (val) => val != null && val.length >= 6 ? null : "Mínimo 6 caracteres",
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text("Ingresar"),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text("¿No tienes cuenta? Registrarse", style: TextStyle(color: Colors.white70)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
