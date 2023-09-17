import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../home/home.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import '../pathway/pathway_state.dart';
import '../navigation/nav_bar.dart';

/// A screen that allows users to select papers and enter grades for each paper.
class PapersListScreen extends StatelessWidget {
  final Major major;
  final List<Paper> compulsoryPapers;
  final List<Paper> optionalPapers;
  final String level;

  const PapersListScreen({
    Key? key,
    required this.major,
    required this.compulsoryPapers,
    required this.optionalPapers,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: Text('Select Your $level-level Papers'),
        backgroundColor: const Color(0XFF10428C),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: compulsoryPapers.length + 2, // Add 2 for SizedBoxes and Title
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 16.0);
                } else if (index == 1) {
                  // Add title for Compulsory Papers
                  return ListTile(
                    title: Text(
                      'Compulsory Papers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  final paperIndex = index - 2;
                  return buildPaperListItem(compulsoryPapers[paperIndex]);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: optionalPapers.length + 2, // Add 2 for SizedBoxes and Title
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 16.0);
                } else if (index == 1) {
                  // Add title for Optional Papers
                  return ListTile(
                    title: Text(
                      'Optional Papers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  final optionalPaperIndex = index - 2;
                  return buildPaperListItem(optionalPapers[optionalPaperIndex]);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          final state = Provider.of<PathwayState>(context, listen: false);
          // Combine the two lists into a single list
          List<Paper> allPapers = [...compulsoryPapers, ...optionalPapers];

          // Filter the selected papers
          List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();

          // Calculate GPA based on selected papers' grades
          double totalWeightedSum = 0;
          int totalWeight = 0;

          for (int i = 0; i < selectedPapers.length; i++) {
            totalWeightedSum += selectedPapers[i].grade * selectedPapers[i].points;
            totalWeight += selectedPapers[i].points;
          }

          double wam = totalWeightedSum / totalWeight;
          double gpa = (wam * 9) / 10;
          state.addGPA(gpa);
          state.addPapers(selectedPapers);
          state.saveState();
          // validatePatshway(major, selectedPapers);

          // if (pathwayCount < 3) {
          //   _openDegreesListScreen(context);
          // } else {
          //   // Display a snackbar to inform the user
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(
          //       content: Text('You cannot have more than three degrees.'),
          //     ),
          //   );
          // }




          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFf9c000),
        ),
        child: const Text('Save'),
      ),
    );
  }

  Widget buildPaperListItem(Paper paper) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${paper.papercode} - ${paper.title}'),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      hintText: '0-100',
                    ),
                    onChanged: (value) {
                      int? grade = int.tryParse(value);
                      if (grade != null && grade >= 0 && grade <= 100) {
                        // Update the grade of the paper here
                        paper.grade = grade;
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: paper.isSelected,
            onChanged: (value) {
              // Update the isSelected status of the paper here
              paper.isSelected = !paper.isSelected;
            },
            fillColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return const Color(0xFFF9C000);
                }
                return Colors.grey[600]!;
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Future<String> fetchPaperData(Major major, List<Paper> papersList) async {
    final url = Uri.parse('http://localhost:1234/degree/majors/${major.name}');

    final response = await http.post(
      url,
      body: jsonEncode(papersList), // Set the JSON string as the request body
      headers: {
        'Content-Type': 'application/json', // Set the Content-Type header
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to validate pathway');
    }
  }
  
  Future<String> parseData(Major major, List<Paper> selectedPapers) async {
    String jsonData;
    try {
      jsonData = await fetchPaperData(major, selectedPapers); // TODO: Make dynamic
      return jsonData;
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching papers: $error');
      return '';
    }
  }
}