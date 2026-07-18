import 'package:coffee_box/providers/box_provider.dart';
import 'package:coffee_box/widgets/box_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoxSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final boxProvider = Provider.of<BoxProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
              child: Image.asset(
                'assets/images/coffeebox-box.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 16),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 270,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF70452A),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'Choose your',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 8),
          ),
          SliverToBoxAdapter(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 220,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFC67C4E),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      'CoffeeBox',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Sora',
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final box = boxProvider.boxes[index];
                  return BoxItem(box: box);
                },
                childCount: boxProvider.boxes.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
