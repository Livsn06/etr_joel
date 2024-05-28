import 'package:flutter/material.dart';
import 'package:foodyfind/apihelper/api.dart';
import 'package:gap/gap.dart';

class Informationscreen extends StatelessWidget {
  Informationscreen({super.key, required this.placeid});
  String placeid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: APIHelper.instance.fetchDetails(placeid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Information Not found!"),
            );
          }

          Map<dynamic, dynamic> place = snapshot.data!;

          return Stack(
            fit: StackFit.expand,
            alignment: Alignment.topCenter,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.only(top: 50, bottom: 10),
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 32, 32, 32)
                            .withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Comments(reviews: place['reviews']),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 25),
                    width: double.infinity,
                    constraints: const BoxConstraints(
                        minHeight: 100,
                        minWidth: double.infinity,
                        maxHeight: 430),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9E6700),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF292929).withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Cardratings(ratings: '${place['rating']}'),
                        const Gap(20),
                        Logos(
                          logo:
                              "${place['icon'] ?? 'https://cdn.vectorstock.com/i/500p/73/82/food-logo-vector-38377382.jpg'}",
                        ),
                        const Gap(10),
                        Text(
                          "${place['name'] ?? 'No name'}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            letterSpacing: 1,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const Gap(20),
                        Informations(
                          address: "${place['vicinity'] ?? 'None'}",
                          contact:
                              "${place['formatted_phone_number'] ?? 'None'}",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Cardratings extends StatelessWidget {
  const Cardratings({super.key, required this.ratings});
  final String ratings;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0x24000000),
          borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 30,
          ),
          const Gap(5),
          Text(
            ratings != 'null' ? "${ratings}k Ratings" : "0 Rating",
            style: const TextStyle(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}

class Logos extends StatelessWidget {
  const Logos({super.key, required this.logo});

  final String logo;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 65,
      child: ClipOval(
        child: Image.network(logo),
      ),
    );
  }
}

class Informations extends StatelessWidget {
  Informations({super.key, required this.address, required this.contact});

  String address = "none", contact = "none";

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: const Color.fromARGB(39, 0, 0, 0),
      child: Column(
        children: [
          const Text(
            'Address',
            style: TextStyle(
              color: Color(0xFFDCDCDC),
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          Text(
            address,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
          const Gap(10),
          const Text(
            'Contact',
            style: TextStyle(
              color: Color(0xFFDCDCDC),
              fontWeight: FontWeight.w300,
              fontSize: 13,
            ),
          ),
          Text(
            contact,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class Comments extends StatelessWidget {
  const Comments({super.key, required this.reviews});
  final List? reviews;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Reviews",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
            child: reviews != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10),
                          leading: CircleAvatar(
                            radius: 25,
                            child: ClipOval(
                              child: Image.network(
                                  '${reviews![index]['profile_photo_url']}'),
                            ),
                          ),
                          title: Text(
                            '${reviews![index]['author_name']}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          subtitle: Text('${reviews![index]['text']}'),
                        ),
                      );
                    },
                    itemCount: reviews?.length ?? 0,
                  )
                : const Center(
                    child: Text(
                      "No reviews",
                      textAlign: TextAlign.center,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
