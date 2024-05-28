import 'package:flutter/material.dart';
import 'package:foodyfind/apihelper/api.dart';
import 'package:foodyfind/screens/informationscreen.dart';

class CurrentLocationscreen extends StatefulWidget {
  const CurrentLocationscreen({super.key});

  @override
  State<CurrentLocationscreen> createState() => _CurrentLocationscreenState();
}

class _CurrentLocationscreenState extends State<CurrentLocationscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFFFFEEC),
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text("Location Based"),
        ),
        body: FutureBuilder(
          future: APIHelper.instance.fetchRestaurant(),
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
                      name: data[index]['name'], icon: data[index]['icon']),
                );
              },
              itemCount: data.length,
            );
          },
        ));
  }
}

class CardView extends StatelessWidget {
  CardView({super.key, required this.name, required this.icon});

  late String icon;
  late String name;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 255, 255, 251),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        minVerticalPadding: 30,
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(icon),
        ),
        title: Text(name),
      ),
    );
  }
}
