
// ===============================
// models/user.dart
// ===============================

// Représentation d'un utilisateur avec ses favoris
class User {
  final String id;
  final String name;
  List<String> favorites;

  User({
    required this.id,
    required this.name,
    required this.favorites,
  });

  // Convertit un JSON -> User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      favorites: List<String>.from(json['favorites']),
    );
  }

  // Convertit User -> JSON (pour l'envoyer sur l'API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'favorites': favorites,
    };
  }
}