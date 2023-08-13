import 'package:flutter/material.dart';
import 'dart/home/home.dart';

import 'dart/navigation/navigationProvider.dart';
import 'package:provider/provider.dart';
//import 'dart/degree/degree_storage.dart';                       //commented out bc apparently these files dont exist. 
//import 'package:shared_preferences/shared_preferences.dart';    //will leave here for now in case we need them later ig

void main() {
    runApp(
      ChangeNotifierProvider(
        create: (context) => navigationProvider(),
        child: const EduApp(),
    ),
  );
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