import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coffee_box.dart';

class BoxProvider extends ChangeNotifier {
  List<CoffeeBox> _boxes = [];
  List<CoffeeBox> get boxes => _boxes;

  void fetchBoxesFromFirestore() {
    FirebaseFirestore.instance
        .collection('CoffeeBoxes')
        .get()
        .then((querySnapshot) {
      _boxes = querySnapshot.docs
          .map((doc) => CoffeeBox.fromFirestore(doc))
          .toList();
      notifyListeners();
    });
  }

  Future<void> storeSelectedCoffeeBox(CoffeeBox selectedBox) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('UserSelections').doc(uid);

      await userDoc.set(
          {'selectedCoffeeBox': selectedBox.name, 'selectedCoffeePods': []},
          SetOptions(merge: true));
    } catch (error) {
      print('Error storing selected coffee box: $error');
      throw error;
    }
  }
}
