import 'package:flutter/material.dart';

import '../navigation/nav_bar.dart';

/// A screen that allows users to calculate their grades.
class GradesScreen extends StatelessWidget {
  /// Constructs a [GradesScreen].
  const GradesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Calculate Your Grades'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: const Center(
        child: Text(
          'TBC: in development',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
