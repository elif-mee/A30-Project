

// ===============================
// models/cat_breed.dart
// ===============================

// Représentation d'une race de chat (juste un nom ici)
class CatBreed {
  final String name;

  CatBreed({required this.name});

  // Factory pour créer un CatBreed à partir d'un JSON
  factory CatBreed.fromJson(Map<String, dynamic> json) {
    return CatBreed(
      name: json['name'],
    );
  }
}
