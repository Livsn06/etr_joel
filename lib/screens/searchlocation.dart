import 'package:flutter/material.dart';
import 'package:foodyfind/apihelper/api.dart';
import 'package:foodyfind/geolocator/geocoding.dart';
import 'package:foodyfind/screens/currentlocation.dart';
import 'package:foodyfind/screens/informationscreen.dart';
import 'package:gap/gap.dart';

class Searchlocation extends StatefulWidget {
  const Searchlocation({super.key});

  @override
  State<Searchlocation> createState() => _SearchlocationState();
}

class _SearchlocationState extends State<Searchlocation> {
  TextEditingController addressController = TextEditingController();

  String location = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFEFBF0),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text("Search Places"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(30),
            const Text(
              'Search a City you want...',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const Gap(5),
            const Text(
              'The best way to find your happy meal..',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const Gap(15),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                hintText: "Search Places",
                border: OutlineInputBorder(),
              ),
            ),
            const Gap(10),
            MaterialButton(
              onPressed: () async {
                location = await GeocodingrHelper.instance
                    .getAddressLocation(addressController.text);
                setState(() {});
              },
              color: Colors.amber,
              child: const Text("Search"),
            ),
            const Gap(30),
            const Text(
              'Results',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            Expanded(
              child: FutureBuilder(
                future: APIHelper.instance.fetchRestaurantbyAddress(location),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                    padding: const EdgeInsets.all(10),
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
                          icon: data[index]['icon'] ?? 'none',
                        ),
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
    );
  }
}
