import 'package:flutter/material.dart';
import 'package:foodyfind/screens/homescreen.dart';

void main() {
  runApp(const FoodyFind());
}

class FoodyFind extends StatelessWidget {
  const FoodyFind({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homescreen(),
    );
  }
}
