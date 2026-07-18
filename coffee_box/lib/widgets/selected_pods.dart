import 'package:coffee_box/models/coffee_pod.dart';
import 'package:flutter/material.dart';
import 'package:coffee_box/widgets/selected_pod.dart';

class SelectedPods extends StatelessWidget {
  final List<CoffeePod> pods;

  const SelectedPods({required this.pods});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Your coffee collection',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Container(
          color: Color.fromARGB(0, 0, 0, 0),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.5,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final pod = pods[index];
              return SelectedPodItem(pod: pod);
            },
            itemCount: pods.length,
          ),
        ),
      ],
    );
  }
}
