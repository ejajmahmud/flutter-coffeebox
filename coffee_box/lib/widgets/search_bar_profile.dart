import 'package:coffee_box/providers/choice_provider.dart';
import 'package:coffee_box/providers/pod_provider.dart';
import 'package:coffee_box/screens/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget YourSearchBarAndProfileWidget() {
  return Consumer2<ChoiceProvider, PodProvider>(
    builder: (context, choiceProvider, podProvider, _) {
      int boxLimit = choiceProvider.boxLimit;
      int selectedPods = podProvider.selectedPods;

      return Container(
        color: Color.fromARGB(255, 22, 22, 22),
        padding: EdgeInsets.fromLTRB(16, 1, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 49, 49, 49),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 152, 152, 152),
                    ),
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: const Color.fromARGB(255, 152, 152, 152),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CheckoutPage()),
                );
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    '$selectedPods/$boxLimit',
                    style: TextStyle(
                      color:
                          selectedPods >= boxLimit ? Colors.red : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
