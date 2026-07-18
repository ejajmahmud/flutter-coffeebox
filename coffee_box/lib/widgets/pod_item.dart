import 'package:coffee_box/providers/choice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coffee_box/models/coffee_pod.dart';
import 'package:coffee_box/providers/pod_provider.dart';

class PodItem extends StatelessWidget {
  final CoffeePod pod;
  final Function()? onPodSelected;

  PodItem({required this.pod, this.onPodSelected});

  @override
  Widget build(BuildContext context) {
    final podProvider = Provider.of<PodProvider>(context);
    final choiceProvider = Provider.of<ChoiceProvider>(context);
    final podCount =
        podProvider.podCounts['${pod.manufacturer} ${pod.name}'] ?? 0;
    final boxLimit = choiceProvider.boxLimit;
    void handleIncrement() {
      if (podProvider.selectedPods < boxLimit) {
        podProvider.incrementPodCount('${pod.manufacturer} ${pod.name}');
        podProvider.storeSelectedCoffeePod(pod);
        if (onPodSelected != null) {
          onPodSelected!();
        }
      } else {
        print('Cannot select more than $boxLimit pods');
        if (onPodSelected != null) {
          onPodSelected!();
        }
      }
    }

    void handleDecrement() {
      if (podProvider.selectedPods > 0) {
        podProvider.decrementPodCount('${pod.manufacturer} ${pod.name}');
        podProvider.removeSelectedCoffeePod(pod);
        if (onPodSelected != null) {
          onPodSelected!();
        }
      } else {
        print('Cannot select more than $boxLimit pods');
        if (onPodSelected != null) {
          onPodSelected!();
        }
      }
    }

    return Container(
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            child: Container(
              height: 100,
              width: double.infinity,
              child: Image.network(
                pod.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pod.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${pod.manufacturer}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              children: [
                if (podCount > 0)
                  Container(
                    height: 36,
                    width: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        handleDecrement();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 198, 124, 78),
                        shape: CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                if (podCount > 0) Spacer(),
                if (podCount > 0)
                  Text(
                    '$podCount',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (podCount > 0) Spacer(),
                if (podCount == 0) Spacer(),
                Container(
                  height: 36,
                  width: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      handleIncrement();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 198, 124, 78),
                      shape: CircleBorder(),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
