import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart';
import '../pathway/pathway_state.dart'; // Import the SecondListScreen class

class MajorListScreen extends StatelessWidget {
  final List<Major> majors;

  const MajorListScreen({required this.majors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Majors'),
      ),
       body: Consumer<PathwayState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: majors.length,
            itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: majors[index].isSelected,
                        onChanged: (value) {
                          // Toggle the checkbox and update the state
                          majors[index].isSelected = value!;
                          state.notifyListeners();
                          navigateToPapersListScreen(context, context.read<PathwayState>(), majors);
                        },
                      ),
                      Expanded(
                        child: Text(majors[index].name),
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
          print(selectedMajors.length);
          Provider.of<PathwayState>(context, listen: false).addMajors(selectedMajors);
        },
        child: Text('Save'),
      ),
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
        "points": 15,
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
        "points": 15,
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
        builder: (context) => PapersListScreen(papers),
      ),
    );
  }
}
