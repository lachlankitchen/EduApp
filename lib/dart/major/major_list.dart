import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart';
import '../pathway/pathway_state.dart'; // Import the SecondListScreen class

class MajorListScreen extends StatelessWidget {
  final List<Major> majors;

  const MajorListScreen({Key? key, required this.majors}) : super(key: key);

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
                        state.notifyListeners();
                        List<Major> selectedMajors = majors.where((major) => major.isSelected).toList();
                        navigateToPapersListScreen(context, context.read<PathwayState>(), selectedMajors);
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
      floatingActionButton: ElevatedButton(
        onPressed: () {
          // Save selected papers to the pathway state
          List<Major> selectedMajors = majors.where((major) => major.isSelected).toList();
          Provider.of<PathwayState>(context, listen: false).addMajors(selectedMajors);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFf9c000), // Set background color here
        ),
        child: const Text('Save'),
      )
    );
  }
  

  void navigateToPapersListScreen(BuildContext context, PathwayState state, List<Major> selectedMajors) {
    state.addMajors(selectedMajors);
    const String papersJson = '''
    [
      {
        "papercode": "CS 101",
        "subject_code": "COMPSCI",
        "year": "2023",
        "title": "Introduction to Computer Science",
        "points": 18,
        "efts": 0.125,
        "teaching_periods": ["Semester 1"],
        "description": "An introduction to...",
        "prerequisites": [],
        "restrictions": [],
        "schedule": "Lecture 1: Monday 9:00 AM"
      },
      {
        "papercode": "CS 162",
        "subject_code": "COMPSCI",
        "year": "2023",
        "title": "Computer Programming",
        "points": 18,
        "efts": 0.125,
        "teaching_periods": ["Semester 1"],
        "description": "An introduction to...",
        "prerequisites": [],
        "restrictions": [],
        "schedule": "Lecture 1: Monday 9:00 AM"
      }
    ]
    ''';

    List<dynamic> parsedPapersJson = json.decode(papersJson);
    List<Paper> papers = parsedPapersJson.map((paperJson) => Paper.fromJson(paperJson)).toList();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PapersListScreen(papers: papers),
      ),
    );
  }
}
