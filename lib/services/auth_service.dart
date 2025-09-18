import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'https://flaskapiexample-production.up.railway.app';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/users/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];

      // Guardar token y username
      await _storage.write(key: 'jwt', value: token);
      await _storage.write(key: 'username', value: username);

      return token;
    }
    return null;
  }

  Future<bool> register(String username, String password) async {
    final url = Uri.parse('$baseUrl/users/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 201) {
      // Guardar el username también al registrarse
      await _storage.write(key: 'username', value: username);
      return true;
    }

    return false;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt');
  }

  Future<String?> getUsername() async {
    return await _storage.read(key: 'username');
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt');
    await _storage.delete(key: 'username');
  }
}
