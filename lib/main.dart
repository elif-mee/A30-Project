// ===============================
// main.dart
// ===============================

// Import de base pour les widgets Flutter (UI)
import 'package:flutter/material.dart';
// Provider est une lib pour gérer l'état (comme qui est connecté, les données chargées, etc.)
import 'package:provider/provider.dart';

// On importe notre logique interne
import 'models/app_state.dart';
import 'screens/login_screen.dart';

void main() {
  // Point d'entrée de l'app Flutter
  runApp(MyApp());
}
// Widget racine de ton app
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Clé unique pour le widget

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // Crée l'état de l'application (logique/metier)
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'PawPedia', // Nom de l'application
        debugShowCheckedModeBanner: false, 
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xFF8BC6EC), // Bleu pastel de base
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Color(0xFFF5F9FB), // Fond général doux
          textTheme: TextTheme(
            headlineMedium: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF37474F), // Gris anthracite
            ),
            bodyLarge: TextStyle(
              fontSize: 16,
              color: Color(0xFF607D8B),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            labelStyle: TextStyle(color: Color(0xFF607D8B)),
            prefixIconColor: Color(0xFF90A4AE),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF8BC6EC),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        home: LoginScreen(), // Écran qui s'affiche au démarrage
      ),
    );
  }
}
