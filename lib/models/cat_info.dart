
// ===============================
// models/cat_info.dart
// ===============================

// Informations détaillées sur un chat
class CatInfo {
  final String name;
  final String origin;
  final String maxLifeExpectancy;
  final String length;
  final String imageLink;

  CatInfo({
    required this.name,
    required this.origin,
    required this.maxLifeExpectancy,
    required this.length,
    required this.imageLink,
  });
}