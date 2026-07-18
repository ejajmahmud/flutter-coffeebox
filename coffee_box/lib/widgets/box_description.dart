import 'package:coffee_box/providers/box_provider.dart';
import 'package:coffee_box/providers/choice_provider.dart';
import 'package:coffee_box/providers/pod_provider.dart';
import 'package:flutter/material.dart';
import 'package:coffee_box/models/coffee_box.dart';
import 'package:provider/provider.dart';

class BoxDescription extends StatelessWidget {
  final CoffeeBox box;

  BoxDescription({required this.box});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                SizedBox(height: 16),
                Center(
                  child: Text(
                    'Details',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/coffeebox-box.png',
                    width: MediaQuery.of(context).size.width * 0.9,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    box.name,
                    style: TextStyle(
                      fontFamily: 'Sora',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    'Coffee at your doorstep',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Sora'),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 0.5,
                  color: Colors.grey,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
                SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    fontFamily: 'Sora',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  box.description,
                  style: TextStyle(
                    fontFamily: 'Sora',
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Price',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '\$${box.price}',
                      style: TextStyle(
                        fontFamily: 'Sora',
                        color: Color(0xFFC67C4E),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<ChoiceProvider>(context, listen: false)
                        .setSelectedCoffeeBox(box);
                    Provider.of<ChoiceProvider>(context, listen: false)
                        .getUsersChoices();
                    Provider.of<BoxProvider>(context, listen: false)
                        .storeSelectedCoffeeBox(box);
                    Provider.of<PodProvider>(context, listen: false)
                        .setSelectedPods(0);
                    Provider.of<PodProvider>(context, listen: false)
                        .resetPodCount();
                    {}
                    ;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFC67C4E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    minimumSize: Size(220, 65),
                  ),
                  child: Text(
                    'Select',
                    style: TextStyle(
                      fontFamily: 'Sora',
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
