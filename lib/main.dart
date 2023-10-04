import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart/pathway/pathway_state.dart';
import 'dart/home/home.dart';
import 'dart/navigation/navigation_provider.dart';
import 'dart/paper/paper_list.dart'; // Import the necessary classes

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        ChangeNotifierProvider(create: (context) => PathwayState()),
        ChangeNotifierProvider(create: (context) => SearchPaperState()), // Add SearchPaperState provider
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
