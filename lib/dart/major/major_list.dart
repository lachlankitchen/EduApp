import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart';
import '../state/pathway_state.dart'; // Import the SecondListScreen class

class MajorListScreen extends StatelessWidget {
  final List<Major> majors;

  const MajorListScreen({Key? key, required this.majors}) : super(key: key);

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
                title: Hero(
                  tag: 'major-${majors[index].name}',
                  child: ElevatedButton(
                    onPressed: () {
                      navigateToPapersListScreen(context, context.read<PathwayState>(), majors[index]);
                    },
                    child: Text(majors[index].name),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
  
  void navigateToPapersListScreen(BuildContext context, PathwayState state, Major selectedMajor) {
    state.updateMajor(selectedMajor);

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
        builder: (context) => PaperListScreen(papers: papers),
      ),
    );
  }
}
