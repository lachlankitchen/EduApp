import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../degree/degree.dart';
import '../degree/degree_list.dart';
import '../pathway/pathway_state.dart';
import 'display_pathway.dart';

import '../navigation/nav_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Degree?> selectedDegrees = List.filled(3, null);

  void _openDegreesListScreen(BuildContext context) {
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
    List<Degree> degrees = Degree.fromJsonList(degreesList);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DegreeListScreen(
          degrees: degrees,
          onSelectDegree: (selectedDegree) {
            setState(() {
              Provider.of<PathwayState>(context, listen: false).addDegree(selectedDegree);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 6, // Adjust the height as needed
            color: const Color(0xFFf9c000),
          ),
          AppBar(
            backgroundColor: const Color(0xFF10428c),            
            title: const Text("Plan Your Degree"),
            leading: Image.asset(
              'assets/images/otago-crest@2x.png', // Add your logo here
              height: 40, // Adjust the height as needed
              fit: BoxFit.contain,
            ),
            toolbarHeight: 60, // Adjust the toolbar height as needed
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Consumer<PathwayState>(
                builder: (context, state, child) {
                  return DisplayPathway(
                    pathway: state.savedPathways, // Pass the chosen degree
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final state = Provider.of<PathwayState>(context, listen: false);
          int pathwayCount = state.savedPathways.where((pathway) => pathway != null).length;

          if (pathwayCount < 3) {
            _openDegreesListScreen(context);
          } else {
            // Display a snackbar to inform the user
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('You cannot have more than three degrees.'),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

}
