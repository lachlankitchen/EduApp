import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../major/major.dart';
import '../major/major_list.dart';
import 'degree.dart';
import '../pathway/pathway_state.dart';

/// A screen that displays a list of degrees to choose from.
class DegreeListScreen extends StatelessWidget {
  final List<Degree> degrees;
  final Function(Degree) onSelectDegree;

  /// Constructs a [DegreeListScreen].
  ///
  /// [degrees] is the list of available degrees to display.
  /// [onSelectDegree] is a callback function when a degree is selected.
  const DegreeListScreen({
    Key? key,
    required this.degrees,
    required this.onSelectDegree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Degree'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: ListView.builder(
        itemCount: degrees.length + 1, // Add 1 for SizedBox
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 18.0); // Add padding at the top
          }

          final degreeIndex = index - 1; // Subtract 1 to adjust for SizedBox
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: Hero(
                tag: 'degree-${degrees[degreeIndex].title}',
                child: ElevatedButton(
                  onPressed: () {
                    onSelectDegree(degrees[degreeIndex]);
                    navigateToMajorsListScreen(
                        context, context.read<PathwayState>(), degrees[degreeIndex]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9c000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(14.0),
                  ),
                  child: Text(
                    degrees[degreeIndex].title,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Navigates to the major list screen.
  ///
  /// [context]: The build context to perform navigation.
  /// [state]: The state containing pathway information.
  /// [selectedDegree]: The selected degree to add to the pathway state.
  ///
  /// This function does not return a value.
  Future<void> navigateToMajorsListScreen(BuildContext context, PathwayState state, Degree degree) async {
    // Pass the selected degree to the state
    state.addDegree(degree);

    String jsonData;
    try {
      jsonData = await fetchMajorData(degree);
      // Now you have the degrees from the server, use them to navigate to the next screen
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching majors: $error');
      return; // Early return to exit the function if fetching degrees fails
    }

    final majorsList = List<String>.from(json.decode(jsonData));
    final majors = majorsList.map((major) => Major.fromJsonName(major)).toList();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MajorListScreen(degree: degree, majors: majors),
      ),
    );
  }
  
  Future<String> fetchMajorData(Degree degree) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/majors'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load majors');
    }
  }
}
