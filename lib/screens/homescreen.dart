import 'package:flutter/material.dart';
import 'package:foodyfind/apihelper/api.dart';
import 'package:foodyfind/geolocator/geolocator.dart';
import 'package:foodyfind/screens/currentlocation.dart';
import 'package:foodyfind/screens/informationscreen.dart';
import 'package:foodyfind/screens/searchlocation.dart';
import 'package:gap/gap.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late bool permission;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationPermision();
  }

  void checkLocationPermision() async {
    permission = await GeolocatorHelper.instance.permissionEnabled();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        toolbarHeight: 70,
        title: const Text('FoodyFind'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
          fontSize: 25,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const Searchlocation()));
              },
              icon: const Icon(Icons.search),
              iconSize: 30)
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 255, 209, 69),
                Color.fromARGB(255, 255, 238, 192),
              ]),
            ),
            child: const Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Did you Search?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Favorite destination must have a good place to eat!',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 100,
                maxHeight: 470,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                      color: Color(0x40000000),
                      spreadRadius: 10,
                      blurRadius: 20),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 120, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Popular Restaurant",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const Gap(20),
                    Expanded(
                      child: FutureBuilder(
                        future: APIHelper.instance.fetchRestaurantbyAddress(
                            "Metro Manila Philippines"),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          var data = snapshot.data!;

                          if (data.isEmpty) {
                            return const Center(
                              child: Text('No data found!'),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              return InkWell(
                                onTap: () {
                                  print(data[index]['place_id']);
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => Informationscreen(
                                          placeid: data[index]['place_id'])));
                                },
                                child: CardView(
                                    name: data[index]['name'] ?? 'none',
                                    icon: data[index]['icon'] ?? 'none'),
                              );
                            },
                            itemCount: data.length,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, -0.4),
            child: Card(
              color: const Color(0xFFFFFFFC),
              shadowColor: Colors.black,
              elevation: 3,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 30, right: 20, bottom: 30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 130,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Find Nearby',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Gap(10),
                          const Text(
                            'See your current location food places!',
                            softWrap: true,
                            textWidthBasis: TextWidthBasis.parent,
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          const Gap(10),
                          MaterialButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) =>
                                      const CurrentLocationscreen()));
                            },
                            color: Colors.amber,
                            child: const Text('Locate now!'),
                          )
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1d/30/54/b2/bidri-ambience.jpg?w=600&h=-1&s=1",
                        height: 150,
                        width: 190,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
