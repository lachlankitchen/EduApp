import 'package:flutter/material.dart';
import 'dart/home/home.dart';

void main() {
  runApp(const EduApp());
}

class EduApp extends StatelessWidget {
  const EduApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Degree Pathway App',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 7, 143, 255)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Degree Pathway App'),
    );
  }
}