import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../degree/degree_list.dart';
import '../pathway/pathway_state.dart';
import '../pathway/display_pathway.dart';
import '../navigation/nav_bar.dart';
import 'dart:convert';
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




  Future<List<String>> fetchDegrees() async {
    final response = await http.get(Uri.parse('http://localhost:1234/degrees'));

    if (response.statusCode == 200) {
      // If the server did return an OK response, parse the JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      List<String> degrees = List<String>.from(data['degrees']);
      return degrees;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load degrees');
    }
  }

  /// Opens the degrees list screen.
  void _openDegreesListScreen(BuildContext context) async {
    List<String> degreesList;

    try {
      degreesList = await fetchDegrees();
      // Now you have the degrees from the server, use them to navigate to the next screen
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching degrees: $error');
      return; // Early return to exit the function if fetching degrees fails
    }

    List<Degree> degrees = Degree.fromJsonList(degreesList);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DegreeListScreen(
          degrees: degrees,
          onSelectDegree: (selectedDegree) {
            setState(() {
              Provider.of<PathwayState>(context, listen: false).addDegree(selectedDegree);
            });
          },
        ),
      ),
    );
  }


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
            _openDegreesListScreen(context);
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