import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeePod {
  final String name;
  final String manufacturer;
  final String description;
  final String imageUrl;

  CoffeePod({
    required this.name,
    required this.manufacturer,
    required this.description,
    required this.imageUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'podNum': manufacturer,
      'imageUrl': imageUrl,
    };
  }

  factory CoffeePod.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return CoffeePod(
      name: data['name'] ?? 'Unknown Name',
      manufacturer: data['manufacturer'] ?? 'Unknown Manufacturer',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }

  factory CoffeePod.fromFrstore(Map<String, dynamic> data) {
    return CoffeePod(
      name: data['name'] ?? 'Unknown Name',
      manufacturer: data['manufacturer'] ?? 'Unknown Manufacturer',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
    );
  }
}
