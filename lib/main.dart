import 'package:flutter/material.dart';
import 'package:picnic_search/welcome.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Product Search',
      home: WelcomePage(),
    );
  }
}
