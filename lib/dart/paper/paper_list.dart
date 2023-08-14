import 'package:edu_app/dart/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../paper/paper.dart';
import '../state/pathway_state.dart'; // Import the SecondListScreen class

class PaperListScreen extends StatelessWidget {
  final List<Paper> papers;

  const PaperListScreen({required this.papers});

  void addPapersToPathway(BuildContext context, PathwayState state, Paper selectedPaper) {
    state.addPaper(selectedPaper);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers'),
      ),
      body: Consumer<PathwayState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: papers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: ElevatedButton(
                  onPressed: () {
                    addPapersToPathway(context, state, papers[index]);
                  },
                  child: Text(papers[index].toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}