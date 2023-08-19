import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../navigation/nav_bar.dart';

class GradesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Calclute Your Grades'),
        backgroundColor: const Color(0xFF10428C)),      
      body: const Center(
        child: Text(
          'TBC: in development',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}