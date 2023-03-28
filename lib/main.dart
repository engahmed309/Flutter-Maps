import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'smaples/map_sample.dart';

void main() {
  runApp(const FlutterMaps());
}

class FlutterMaps extends StatelessWidget {
  const FlutterMaps({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.lightBlue[100],
      ),
      debugShowCheckedModeBanner: false,
      home: MapSample(),
    );
  }
}
