import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart/home/home.dart'; // Import your Home screen
import 'dart/state/pathway_state.dart'; // Import the state management class

void main() {
  runApp(const EduApp());
}

class EduApp extends StatelessWidget {
  const EduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PathwayState(),
      child: MaterialApp(
        title: 'Degree Pathway App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 7, 143, 255),
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
