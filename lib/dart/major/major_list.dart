import 'dart:convert';

import 'package:flutter/material.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart'; // Import the SecondListScreen class

class MajorListScreen extends StatelessWidget {
  final List<Major> majors;

  const MajorListScreen({required this.majors});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Majors'),
      ),
      body: ListView.builder(
        itemCount: majors.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ElevatedButton(
              onPressed: () {
                navigateToPapersListScreen(context);              
              },
              child: Text(majors[index].toString()),
            ),
          );
        },
      ),
    );
  }
  
  void navigateToPapersListScreen(BuildContext context) {
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
      // Add more paper objects here
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
