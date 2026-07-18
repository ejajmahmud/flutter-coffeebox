import 'package:coffee_box/models/coffee_pod.dart';
import 'package:coffee_box/providers/choice_provider.dart';
import 'package:coffee_box/providers/pod_provider.dart';
import 'package:coffee_box/widgets/pod_item.dart';
import 'package:coffee_box/widgets/search_bar_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoffeeSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PodProvider, ChoiceProvider>(
      builder: (context, podProvider, choiceProvider, _) {
        final List<CoffeePod> pods = podProvider.pods;
        int selectedIndex = podProvider.selectedIndex;
        final List<String> tags = [
          'All',
          'Dolce Gusto',
          'Nespresso',
          'Barcaffe',
          'Illy'
        ];

        List<CoffeePod> getFilteredPods() {
          if (selectedIndex == 0) {
            return List.from(pods); 
          } else {
            String selectedTag = tags[selectedIndex];
            return pods
                .where((pod) => pod.manufacturer == selectedTag)
                .toList();
          }
        }

        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 249, 249, 249),
          body: Padding(
            padding: EdgeInsets.zero,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: const Color.fromARGB(255, 22, 22, 22),
                  expandedHeight: MediaQuery.of(context).size.height * 0.25,
                  floating: true,
                  pinned: false,
                  flexibleSpace: FlexibleSpaceBar(
                    background: YourSearchBarAndProfileWidget(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 22, 22, 22),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/images/pod-banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: tags.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              podProvider.setSelectedIndex(index);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: selectedIndex == index
                                  ? const Color.fromARGB(255, 198, 124, 78)
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              tags[index],
                              style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.5,
                    ),
                    itemBuilder: (context, index) {
                      final pod = getFilteredPods()[index];
                      return PodItem(
                        pod: pod,
                        onPodSelected: () async {
                          if (podProvider.selectedPods ==
                              choiceProvider.boxLimit) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 198, 124, 78),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Text(
                                    'Maximum number of pods reached!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0, 
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      );
                    },
                    itemCount: getFilteredPods().length,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


