import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:coffee_box/models/coffee_box.dart';
import 'package:coffee_box/models/coffee_pod.dart';

class ChoiceProvider extends ChangeNotifier {
  CoffeeBox? _selectedCoffeeBox;
  List<CoffeePod> _selectedCoffeePods = [];
  int _selectedPodsNum = 0;
  int _boxLimit = 3;

  // Getters
  CoffeeBox? get selectedCoffeeBox => _selectedCoffeeBox;
  List<CoffeePod> get selectedCoffeePods => _selectedCoffeePods;
  int get boxLimit => _boxLimit;
  int get selectedPodsNum => _selectedPodsNum;

  ChoiceProvider() {
    getUsersChoices();
  }
  // Setters
  void setSelectedCoffeeBox(CoffeeBox coffeeBox) {
    _selectedCoffeeBox = coffeeBox;
    _boxLimit = coffeeBox.podNum;
    notifyListeners();
  }

  void setSelectedCoffeePods(List<CoffeePod> coffeePods) {
    _selectedCoffeePods = coffeePods;
    notifyListeners();
  }

  void addSelectedPods(List<CoffeePod> coffeePods) {
    _selectedCoffeePods = coffeePods;
    notifyListeners();
  }

  Future<Map<String, dynamic>> getUsersChoices() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String? email = FirebaseAuth.instance.currentUser!.email;
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('UserSelections').doc(uid);

      DocumentSnapshot doc = await userDoc.get();
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String selectedBox = data['selectedCoffeeBox'] ?? '';

        fetchCoffeeBox(selectedBox);

        List<String> selectedPods =
            List<String>.from(data['selectedCoffeePods'] ?? []);

        fetchPodsByDocumentIdsFromFirestore(selectedPods);

        _selectedPodsNum = selectedPods.length;

        notifyListeners();
        return {
          'selectedCoffeeBox': selectedBox,
          'selectedCoffeePods': selectedPods,
          'email': email,
        };
      } else {
        print('Document data is null');
        return {};
      }
    } catch (error) {
      print('Error retrieving user choices: $error');
      throw error;
    }
  }

  void fetchCoffeeBox(String name) {
    FirebaseFirestore.instance
        .collection('CoffeeBoxes')
        .where('name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        _selectedCoffeeBox = CoffeeBox.fromFirestore(querySnapshot.docs.first);
        setSelectedCoffeeBox(_selectedCoffeeBox!);
        notifyListeners();
      } else {
        _selectedCoffeeBox = null;
        notifyListeners();
      }
    });
  }

  void fetchPodsByDocumentIdsFromFirestore(List<String> documentIds) {
    FirebaseFirestore.instance
        .collection('CoffeePods')
        .where(FieldPath.documentId, whereIn: documentIds)
        .get()
        .then((querySnapshot) {
      Map<String, CoffeePod> podMap = {
        for (var doc in querySnapshot.docs) doc.id: CoffeePod.fromFirestore(doc)
      };

      _selectedCoffeePods = documentIds.map((id) => podMap[id]!).toList();

      notifyListeners();
    }).catchError((error) {
      print("Error fetching pods: $error");
    });
  }
}
