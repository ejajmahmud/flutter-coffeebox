import 'package:coffee_box/providers/selected_index_provider.dart';
import 'package:coffee_box/screens/box_selection.dart';
import 'package:coffee_box/screens/coffee_selection.dart';
import 'package:coffee_box/screens/profile_screen.dart';
import 'package:coffee_box/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final List<Widget> _pages = [
    BoxSelection(),
    CoffeeSelection(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();
    final selectedIndexProvider = Provider.of<SelectedIndexProvider>(context);

    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          selectedIndexProvider.setSelectedIndex(index);
        },
        children: _pages,
      ),
      bottomNavigationBar:
          CustomBottomNavigationBar(pageController: pageController),
    );
  }
}
