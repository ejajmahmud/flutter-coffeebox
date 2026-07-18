import 'package:coffee_box/providers/selected_index_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final PageController pageController;

  CustomBottomNavigationBar({required this.pageController});

  @override
  Widget build(BuildContext context) {
    final selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: BottomNavigationBar(
          selectedItemColor: const Color.fromARGB(255, 198, 124, 78),
          unselectedItemColor: Colors.grey,
          currentIndex: selectedIndexProvider.selectedIndex,
          onTap: (index) {
            selectedIndexProvider.setSelectedIndex(index);
            pageController.jumpToPage(
                index); 
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'CoffeeBox',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.coffee_maker),
              label: 'CoffeePods',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
