import 'dart:convert';

import 'package:flutter/material.dart';
import '../degree/degree.dart'; 
import '../major/major.dart';
import '../major/major_list.dart'; 

class DegreesListScreen extends StatelessWidget {
  final List<Degree> degrees;

  const DegreesListScreen({required this.degrees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Undergraduate Degrees'),
      ),
      body: ListView.builder(
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          return ListTile(
            
            title: ElevatedButton(
              onPressed: () {
                navigateToMajorsListScreen(context);
              },
              child: Text(degrees[index].toString()),
            ),
          );
        },
      ),
    );
  }


  void navigateToMajorsListScreen(BuildContext context) {

    const String majorsJson = '''
    [
      {
        "name": "English",
        "requirements": [
          {
            "level": 100,
            "papers": ["ENGL 121", "ENGL 131"],
            "selectOneFrom": ["ENGL 120", "ENGL 121", "ENGL 127", "ENGL 128", "ENGL 131", "LING 111"]
          },
          {
            "level": 200,
            "papers": ["Three 200-level ENGL papers", "DHUM 201 or EURO 202"]
          },
          {
            "level": 300,
            "papers": ["Four 300-level ENGL papers", "EURO 302"]
          },
          {
            "points": 198,
            "notes": "Must include 54 points at 200-level or above. Up to 90 points may be taken from outside Arts."
          }
        ],
        "totalPoints": 360
      },
      {
        "name": "Computer Science",
        "requirements": [
          {
            "level": 100,
            "papers": ["CS 101", "CS 102"],
            "selectOneFrom": ["MATH 120", "MATH 121"]
          },
          {
            "level": 200,
            "papers": ["CS 201", "CS 202"]
          },
          {
            "level": 300,
            "papers": ["CS 301", "CS 302"]
          },
          {
            "points": 180,
            "notes": "Must include at least 60 points at 300-level or above."
          }
        ],
        "totalPoints": 360
      }
    ]
    ''';

    List<dynamic> parsedMajorsJson = json.decode(majorsJson);
    List<Major> majors = parsedMajorsJson.map((majorJson) => Major.fromJson(majorJson)).toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MajorListScreen(majors: majors),
      ),
    );
  }
}
