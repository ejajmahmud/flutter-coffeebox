import 'package:coffee_box/models/coffee_box.dart';
import 'package:coffee_box/models/coffee_pod.dart';

class CoffeeSubscription {
  final CoffeeBox selectedCoffeeBox;
  final List<CoffeePod> selectedCoffeePods;

  CoffeeSubscription({
    required this.selectedCoffeeBox,
    required this.selectedCoffeePods,
  });
}
