
// ===============================
// models/app_state.dart
// ===============================

// Ces imports servent à charger des fichiers (json), faire des requêtes HTTP, etc.
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cat_breed.dart'; // Modèle d'une race de chat
import 'cat_info.dart'; // Infos sur un chat
import 'user.dart';     // Infos d'utilisateur

// AppState = gestionnaire d'état de ton app
class MyAppState extends ChangeNotifier {
  List<CatBreed> catBreeds = []; // Liste des races de chats
  CatInfo? currentCatInfo;       // Infos du chat actuel (peut être null)
  bool isLoading = false;        // Pour afficher un indicateur de chargement
  User? currentUser;             // Utilisateur actuellement connecté
  bool isAuthenticating = false; // Pour savoir si on est en train de se connecter
  String authError = '';          // Pour stocker une erreur d'auth

  MyAppState() {
    loadCatBreeds(); // Appel au chargement de la liste des races
  }

  // Charge les races à partir du fichier local JSON
  Future<void> loadCatBreeds() async {
    try {
      String jsonString = await rootBundle.loadString('assets/cat_breeds.json');
      List<dynamic> jsonList = json.decode(jsonString);
      catBreeds = jsonList.map((json) => CatBreed.fromJson(json)).toList();
      notifyListeners(); // Met à jour les widgets qui écoutent les changements
    } catch (e) {
      print('Error loading cat breeds: $e');
    }
  }

  // Va chercher les infos complètes d'une race de chat depuis l'API
  Future<void> fetchCatInfo(String breedName) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.api-ninjas.com/v1/cats?name=$breedName'),
        headers: {
          'X-Api-Key': 'PCMDQGn6wr9uTYh8DRrHUg==6sxE6bxitMqCYSw4',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final catData = data[0];

          // On transforme les données API en objets sûrs (on gère les cas null)
          String safeName = catData['name']?.toString() ?? breedName;
          String safeOrigin = catData['origin']?.toString() ?? 'Unknown';
          String safeMaxLife = catData['max_life_expectancy']?.toString() ?? 'Unknown';
          String safeLength = catData['length']?.toString() ?? 'Unknown';
          String safeImageLink = catData['image_link']?.toString() ?? 'https://via.placeholder.com/300x200?text=No+Image+Available';

          currentCatInfo = CatInfo(
            name: safeName,
            origin: safeOrigin,
            maxLifeExpectancy: safeMaxLife,
            length: safeLength,
            imageLink: safeImageLink,
          );
        }
      } else {
        print('Failed to load cat info: ${response.statusCode}');
        currentCatInfo = null;
      }
    } catch (e) {
      print('Error fetching cat info: $e');
      currentCatInfo = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Authentifie un utilisateur ou le crée s'il n'existe pas
  Future<void> authenticateUser(String username) async {
    isAuthenticating = true;
    authError = '';
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://6821e890b342dce8004c4cfc.mockapi.io/auth/users'),
      );

      if (response.statusCode == 200) {
        List<dynamic> users = json.decode(response.body);
        User? foundUser;

        for (var user in users) {
          if (user['name'] == username) {
            foundUser = User.fromJson(user);
            break;
          }
        }

        if (foundUser != null) {
          currentUser = foundUser;
        } else {
          // Si utilisateur non trouvé, on le crée
          final createResponse = await http.post(
            Uri.parse('https://6821e890b342dce8004c4cfc.mockapi.io/auth/users'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'name': username,
              'favorites': [],
            }),
          );

          if (createResponse.statusCode == 201) {
            currentUser = User.fromJson(json.decode(createResponse.body));
          } else {
            authError = 'Failed to create user account';
          }
        }
      } else {
        authError = 'Failed to authenticate';
      }
    } catch (e) {
      authError = 'Error during authentication: $e';
      print(authError);
    } finally {
      isAuthenticating = false;
      notifyListeners();
    }
  }

  // Ajouter une race à la liste des favoris
  Future<void> addToFavorites(String breedName) async {
    if (currentUser == null) return;

    if (!currentUser!.favorites.contains(breedName)) {
      currentUser!.favorites.add(breedName);
      await updateUserFavorites();
    }
  }

  // Supprimer une race des favoris
  Future<void> removeFromFavorites(String breedName) async {
    if (currentUser == null) return;

    currentUser!.favorites.remove(breedName);
    await updateUserFavorites();
  }

  // Mettre à jour les favoris sur le serveur
  Future<void> updateUserFavorites() async {
    if (currentUser == null) return;

    try {
      final response = await http.put(
        Uri.parse('https://6821e890b342dce8004c4cfc.mockapi.io/auth/users/${currentUser!.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(currentUser!.toJson()),
      );

      if (response.statusCode == 200) {
        notifyListeners();
      } else {
        print('Failed to update favorites: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating favorites: $e');
    }
  }

  // Vérifie si une race est dans les favoris
  bool isBreedFavorite(String breedName) {
    return currentUser?.favorites.contains(breedName) ?? false;
  }

  // Déconnexion = réinitialise tout
  void logout() {
    currentUser = null;
    currentCatInfo = null;
    notifyListeners();
  }
}
