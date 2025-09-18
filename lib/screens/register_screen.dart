import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final AuthService _authService = AuthService();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authService.register(
        _userCtrl.text.trim(),
        _passwordCtrl.text.trim(),
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuario registrado: ${_userCtrl.text}")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error al registrarse")),
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
        title: const Text("Registrarse"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text("Crea tu cuenta",
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
                  onPressed: _register,
                  child: const Text("Registrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
