import 'package:coffee_box/providers/choice_provider.dart';
import 'package:coffee_box/providers/authentication_provider.dart';
import 'package:coffee_box/widgets/selected_box.dart';
import 'package:coffee_box/widgets/selected_pods.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC67C4E),
      body: SafeArea(
        child: Consumer2<ChoiceProvider, AuthProvider>(
          builder: (context, choiceProvider, authProvider, _) {
            choiceProvider.getUsersChoices();
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/white-transparent.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 10),
                      Text(
                        authProvider.userName ?? 'User Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          authProvider.signOut(context);
                        },
                        icon: Icon(Icons.edit),
                        label: Text('Sign Out'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Color.fromARGB(255, 0, 0, 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          minimumSize: Size(10, 35),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Card(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SelectedBox(
                          name: choiceProvider.selectedCoffeeBox?.name ??
                              'Default Name',
                          description:
                              choiceProvider.selectedCoffeeBox?.description ??
                                  'Default Description',
                          imageUrl:
                              choiceProvider.selectedCoffeeBox?.imagePath ??
                                  'default_image_url',
                        ),
                        SizedBox(height: 20),
                        SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              SelectedPods(
                                  pods: choiceProvider.selectedCoffeePods),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
