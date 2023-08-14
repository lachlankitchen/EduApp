import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../degree/degree.dart';
import '../degree/degree_list.dart';
import '../state/pathway_state.dart';
import 'display_pathway.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Create a list to store selected degrees (up to 3)
  List<Degree?> selectedDegrees = List.filled(3, null);

  void _openDegreesListScreen(BuildContext context, int index) {
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
        builder: (context) => DegreeListScreen(
          degrees: degrees,
          onSelectDegree: (selectedDegree) {
            setState(() {
              selectedDegrees[index] = selectedDegree;
            });
            Navigator.pop(context); // Close the degrees list screen
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Degree Pathway App"),
      ),
      body: Consumer<PathwayState>(
        builder: (context, state, child) {
          return DisplayPathway(
            degree: state.chosenDegree, // Pass the chosen degree
            majors: state.chosenMajors,
            papers: state.chosenPapers,
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          for (int i = 0; i < 3; i++)
            if (selectedDegrees[i] == null)
              FloatingActionButton(
                onPressed: () {
                  _openDegreesListScreen(context, i); // Open degrees list for a specific index
                },
                child: const Icon(Icons.add),
              ),
          // ... other FloatingActionButton widgets ...
        ],
      ),
    );
  }
}
