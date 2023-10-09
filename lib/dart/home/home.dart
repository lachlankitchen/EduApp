import 'package:edu_app/dart/navigation/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../degree/degree.dart';
import '../pathway/pathway_state.dart';
import '../pathway/display_pathway.dart';
import '../navigation/nav_bar.dart';

/// The main screen of the application where users can plan their degrees.
class MyHomePage extends StatefulWidget {
  /// Constructs a [MyHomePage].
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a list to store selected degrees (up to 3)
  List<Degree?> selectedDegrees = List.filled(3, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10428C), // Set background color here
        title: const Text("Plan Your Degree"),
      ),
      body: Consumer<PathwayState>(
        builder: (context, state, child) {
          return DisplayPathway(
            pathway: state.savedPathways, // Pass the chosen degree
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFf9c000), // Set background color here
        onPressed: () {
          final state = Provider.of<PathwayState>(context, listen: false);
          int pathwayCount = state.savedPathways.length;

          if (pathwayCount < 3) {
            navigateToDegreesListScreen(context);
          } else {
            // Display a snackbar to inform the user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You cannot have more than three degrees.'),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}