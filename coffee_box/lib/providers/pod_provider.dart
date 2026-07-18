import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffee_box/models/coffee_box.dart';
import 'package:coffee_box/models/coffee_pod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PodProvider extends ChangeNotifier {
  List<CoffeePod> _pods = [];
  int _selectedIndex = 0;
  int _selectedIndexNavBar = 1;
  int _selectedPods = 0;
  int _boxLimit = 0;
  Map<String, int> _podCounts = {};

  // Getters for the state
  List<CoffeePod> get pods => _pods;
  int get selectedIndex => _selectedIndex;
  int get selectedIndexNavBar => _selectedIndexNavBar;
  int get selectedPods => _selectedPods;
  int get boxLimit => _boxLimit;
  Map<String, int> get podCounts => _podCounts;

  PodProvider() {
    fetchPodsFromFirestore();
    fetchSelectedPodsCount();
  }

  void fetchPodsFromFirestore() {
    FirebaseFirestore.instance
        .collection('CoffeePods')
        .get()
        .then((querySnapshot) {
      _pods = querySnapshot.docs
          .map((doc) => CoffeePod.fromFirestore(doc))
          .toList();
      notifyListeners();
    }).catchError((error) {
      print("Error fetching pods: $error");
    });
  }

  void resetPodCount() {
    _podCounts = {};
  }

  void fetchBoxLimitFromFirestore() {
    FirebaseFirestore.instance
        .collection('CoffeeBoxes')
        .doc('selectedCoffeeBox')
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        CoffeeBox coffeeBox = CoffeeBox.fromFirestore(docSnapshot);
        _boxLimit = coffeeBox.podNum;
        notifyListeners();
      }
    }).catchError((error) {
      print("Error fetching box limit: $error");
    });
  }

  void setPods(List<CoffeePod> pods) {
    _pods = pods;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void setSelectedIndexNavBar(int index) {
    _selectedIndexNavBar = index;
    notifyListeners();
  }

  void setSelectedPods(int selectedPods) {
    _selectedPods = selectedPods;
    print(_selectedPods);
    notifyListeners();
  }

  void incrementPodCount(String podName) {
    if (_podCounts.containsKey(podName)) {
      _podCounts[podName] = _podCounts[podName]! + 1;
    } else {
      _podCounts[podName] = 1;
    }
    updateSelectedPods();
    notifyListeners();
  }

  void decrementPodCount(String podName) {
    if (_podCounts.containsKey(podName) && _podCounts[podName]! > 0) {
      _podCounts[podName] = _podCounts[podName]! - 1;
      updateSelectedPods();
      notifyListeners();
    }
  }

  void updateSelectedPods() {
    int totalPods = _podCounts.values.fold(0, (sum, count) => sum + count);
    setSelectedPods(totalPods);
  }

  Future<void> fetchSelectedPodsCount() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('UserSelections').doc(uid);

      DocumentSnapshot doc = await userDoc.get();
      List<dynamic> selectedPods = doc['selectedCoffeePods'] ?? [];

      _podCounts = {};

      for (var podName in selectedPods) {
        if (_podCounts.containsKey(podName)) {
          _podCounts[podName] = _podCounts[podName]! + 1;
          print(podCounts);
        } else {
          _podCounts[podName] = 1;
        }
      }

      updateSelectedPods();

      notifyListeners();
    } catch (error) {
      print('Error fetching selected pods count: $error');
    }
  }

  Future<void> storeSelectedCoffeePod(CoffeePod selectedPod) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('UserSelections').doc(uid);

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('CoffeePods')
          .where('name', isEqualTo: selectedPod.name)
          .where('manufacturer', isEqualTo: selectedPod.manufacturer)
          .get();

      print(querySnapshot.docs);
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot podDoc = querySnapshot.docs.first;
        String podId = podDoc.id;
        print(podId);
        DocumentSnapshot doc = await userDoc.get();
        List<dynamic> selectedPods =
            (doc['selectedCoffeePods'] ?? []) as List<dynamic>;
        selectedPods.add(podId);

        await userDoc.set({
          'selectedCoffeePods': selectedPods,
        }, SetOptions(merge: true));
      } else {
        throw 'Document not found';
      }
    } catch (error) {
      print('Error storing selected coffee pod: $error');
      throw error;
    }
  }

  Future<void> removeSelectedCoffeePod(CoffeePod selectedPod) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDoc =
          FirebaseFirestore.instance.collection('UserSelections').doc(uid);

      DocumentSnapshot doc = await userDoc.get();
      List<dynamic> selectedPods = doc['selectedCoffeePods'] ?? [];

      bool removed = false;

      selectedPods.removeWhere((pod) {
        if (!removed && pod == selectedPod.name) {
          removed = true;
          return true;
        }
        return false;
      });

      await userDoc.set({
        'selectedCoffeePods': selectedPods,
      }, SetOptions(merge: true));
    } catch (error) {
      print('Error storing selected coffee pod: $error');
      throw error;
    }
  }
}
