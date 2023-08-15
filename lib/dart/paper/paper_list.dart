import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';
import '../paper/paper.dart';
import '../state/pathway_state.dart'; // Import the SecondListScreen class

class PaperListScreen extends StatelessWidget {
  final List<Paper> papers;

  const PaperListScreen({required this.papers});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PathwayState>(
      create: (context) => PathwayState(), // Initialize your PathwayState here
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Papers'),
        ),
        body: Consumer<PathwayState>(
          builder: (context, state, child) {
            return ListView.builder(
              itemCount: papers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Checkbox(
                        value: papers[index].isSelected,
                        onChanged: (value) {
                          // Toggle the checkbox and update the state
                          papers[index].isSelected = value!;
                          state.notifyListeners();
                        },
                      ),
                      Expanded(
                        child: Text(papers[index].toString()),
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
            List<Paper> selectedPapers = papers.where((paper) => paper.isSelected).toList();
            Provider.of<PathwayState>(context, listen: false).addPapers(selectedPapers);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyHomePage()));
          },
          child: Text('Save'),
        ),
      ),
    );
  }
}
