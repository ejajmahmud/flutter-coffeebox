import 'package:coffee_box/providers/authentication_provider.dart';
import 'package:coffee_box/providers/choice_provider.dart';
import 'package:coffee_box/providers/pod_provider.dart';
import 'package:coffee_box/providers/selected_index_provider.dart';
import 'package:coffee_box/providers/box_provider.dart';
import 'package:coffee_box/screens/starting_screen.dart';
import 'package:coffee_box/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:square_in_app_payments/in_app_payments.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await InAppPayments.setSquareApplicationId(
      'sandbox-sq0idb-FrwHUoe3HJ64LYMoOJdUaQ');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SelectedIndexProvider()),
        ChangeNotifierProvider(create: (_) => PodProvider()),
        ChangeNotifierProvider(create: (_) => ChoiceProvider()),
        ChangeNotifierProvider(
            create: (_) => BoxProvider()..fetchBoxesFromFirestore()),
      ],
      child: MaterialApp(
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            if (authProvider.user != null) {
              return HomeScreen();
            } else {
              return StartingScreen();
            }
          },
        ),
      ),
    );
  }
}
