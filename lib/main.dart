import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart/pathway/pathway_state.dart'; // Import the state management class
import 'dart/home/home.dart';
import 'dart/navigation/navigation_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => PathwayState()),
      ],
      child: const EduApp(),
    ),
  );
}

class EduApp extends StatelessWidget {
  const EduApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}
