import 'package:cloud_firestore/cloud_firestore.dart';

class CoffeeBox {
  final String name;
  final String description;
  final String imagePath;
  final String price;
  final int podNum;
  CoffeeBox({
    required this.name,
    required this.description,
    required this.imagePath,
    required this.price,
    required this.podNum,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'podNum': podNum,
      'imageUrl': imagePath,
    };
  }

  factory CoffeeBox.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CoffeeBox(
        name: data['name'],
        description: data['description'],
        imagePath: data['imagePath'],
        price: data['price'],
        podNum: data['pod_num']);
  }

  factory CoffeeBox.fromFrstore(Map<String, dynamic> data) {
    return CoffeeBox(
      name: data['name'] ?? 'Unknown Name',
      description: data['description'] ?? '',
      imagePath: data['imagePath'],
      price: data['price'],
      podNum: data['podNum'],
    );
  }
}
