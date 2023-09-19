import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/fetch_paper.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart';
import '../pathway/pathway_state.dart'; // Import the SecondListScreen class

/// Represents a screen where users can select their majors.
class MajorListScreen extends StatelessWidget {
  final Degree degree;
  final List<Major> majors;

  /// Constructs a [MajorListScreen].
  ///
  /// [majors]: The list of available majors to display.
  const MajorListScreen({Key? key, required this.degree, required this.majors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Majors'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Consumer<PathwayState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: majors.length + 1, // Add 1 for SizedBox
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox(height: 16.0); // Add padding at the top
              }
              final majorIndex = index - 1; // Adjust index for SizedBox
              return ListTile(
                title: Row(
                  children: [
                    Checkbox(
                      value: majors[majorIndex].isSelected,
                      onChanged: (value) {
                        // Toggle the checkbox and update the state
                        majors[majorIndex].isSelected = !majors[majorIndex].isSelected;
                        List<Major> selectedMajors =
                            majors.where((major) => major.isSelected).toList();
                        navigateToPapersListScreen(
                            context, context.read<PathwayState>(), degree, selectedMajors);
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFF9C000); // Set checkbox background color here
                          }
                          return Colors.grey[600]!; // Default background color
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(majors[majorIndex].name),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  /// Navigates to the papers list screen.
  ///
  /// [context]: The build context for navigation.
  /// [state]: The state containing pathway information.
  /// [selectedMajors]: The list of selected majors.
  Future<void> navigateToPapersListScreen(BuildContext context, PathwayState state, Degree degree, List<Major> majors) async {
    state.addMajors(majors);

    String jsonData;
    try {
      jsonData = await fetchPaperData(degree, majors[0]); // TODO: Make dynamic
      // Now you have the degrees from the server, use them to navigate to the next screen
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching papers: $error');
      return; // Early return to exit the function if fetching degrees fails
    }

    List<Paper> compulsoryPapers = getPaperData(jsonData, 100, 'compulsory_papers');
    List<Paper> oneOfPapers = getPaperData(jsonData, 100, 'one_of_papers');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PapersListScreen(degree: degree, major: majors[0], compulsoryPapers: compulsoryPapers, oneOfPapers: oneOfPapers, level: 100),
      ),
    );
  }

  // Function to retrieve papers
  List<Paper> getLevelPapers(Map<String, dynamic> parsedData, String levelKey, String paperKey) {
    List<Paper> papers = [];
    for (var level in parsedData['levels']) {
      if (level['level'] == levelKey) {
        var paperList = level[paperKey] as List<dynamic>?; // Use null-safe List
        if (paperList != null) {
          for (var paperData in paperList) {
            for (var entry in paperData.entries) {
              final paperCode = entry.key;
              final attributes = entry.value as Map<String, dynamic>;
              final teachingPeriods = (attributes['teaching_periods'] as List<dynamic>)
                ?.map<String>((period) => period.toString())
                ?.toList() ?? []; // Provide a default value if needed

              papers.add(Paper.withName(
                papercode: paperCode,
                title: attributes['title'] ?? '', // Provide a default value if needed
                teachingPeriods: teachingPeriods, // Provide a default value if needed
              ));
            }
          }
        }
      }
    }
    return papers;
  }
}
