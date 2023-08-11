import 'package:flutter/material.dart';

import '../degree/degree.dart';
import '../form/degree_list.dart';
import '../form/paper_list.dart';
import '../paper/paper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _openDegreesListScreen(BuildContext context) {
    // Sample degree data
    final degreesJson = {
      "degrees": [
        "Bachelor of Applied Science (BAppSc)",
        "Bachelor of Arts (BA)",
        "Bachelor of Arts and Commerce (BACom)",
        "Bachelor of Arts and Science (BASc)",
        "Bachelor of Biomedical Sciences (BBiomedSc)",
        "Bachelor of Commerce (BCom)",
        "Bachelor of Commerce and Science (BComSc)",
        "Bachelor of Entrepreneurship (BEntr)",
        "Bachelor of Health Sciences (BHealSc)",
        "Bachelor of Music (MusB)",
        "Bachelor of Performing Arts (BPA)",
        "Bachelor of Science (BSc)",
        "Bachelor of Theology (BTheol)",
        "Bachelor of Laws (LLB) (first year only)"
      ]
    };

    List<String>? degreesList = (degreesJson['degrees'] as List<dynamic>).cast<String>();
    List<Degree> degrees = Degree.fromJsonList(degreesList ?? []);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DegreesListScreen(degrees: degrees),
      ),
    );
  }

  void _openPapersListScreen(BuildContext context) {
    // Sample paper data
    List<Paper> papers = [
      Paper(
        papercode: "PAPER123",
        subjectCode: "SUB123",
        year: "2023",
        title: "Introduction to Dart Programming",
        points: 5,
        efts: 0.5,
        teachingPeriods: ["Semester 1", "Semester 2"],
        description: "An introduction to programming in Dart.",
        prerequisites: ["None"],
        restrictions: ["Open to all students"],
        schedule: "Tuesdays and Thursdays, 10:00 AM - 12:00 PM",
      ),
      // Add more papers here
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PapersListScreen(papers: papers),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _openDegreesListScreen(context); // Open degrees list
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              _openPapersListScreen(context); // Open papers list
            },
            child: const Icon(Icons.list),
          ),
        ],
      ),
    );
  }
}
