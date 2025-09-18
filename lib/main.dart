import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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
      home: const HomeScreen(), // arranca en Home
    );
  }
}
