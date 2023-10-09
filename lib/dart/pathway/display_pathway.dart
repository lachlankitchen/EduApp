import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../paper/paper.dart';
import 'pathway.dart';
import 'pathway_state.dart'; // Import the Pathway class

/// A widget that displays the details of saved pathways.
///
/// The [DisplayPathway] widget receives a list of [pathway] objects to display
/// the saved pathways, along with their degrees, majors, and papers.
class DisplayPathway extends StatelessWidget {
  /// The list of saved pathways to be displayed.
  final List<Pathway> pathway;

  /// Creates a [DisplayPathway] widget.
  ///
  /// The [pathway] parameter is required and contains the list of saved pathways
  /// that will be displayed on the screen.
  const DisplayPathway({
    super.key,
    required this.pathway,
  });

  @override
  Widget build(BuildContext context) {
    // If no pathways are available, display a message indicating that.
    if (pathway.isEmpty) {
      return const Center(
        child: Text('You have no saved degrees. Press the + button to add your degree.'),
      );
    }
    

    // Build a list of saved pathways using a ListView builder.
    return ListView.builder(
      itemCount: pathway.length,
      itemBuilder: (context, index) {
        Map<String, List<Paper>> selectedPapers = pathway[index].selectedPapers;
        Map<String, List<Paper>> remainingPapers = pathway[index].remainingPapers;

        return Card(
          margin: const EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pathway[index].degree.title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<PathwayState>(context, listen: false).deleteState(pathway[index]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf9c000),
                      ),
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (pathway[index].majors.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Major(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      for (var major in pathway[index].majors)
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('${major.name},'),
                        ),
                    ],
                  ),
                const SizedBox(height: 10),
                if (pathway[index].selectedPapers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Papers(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      buildPapersByLevel(selectedPapers), // Use the helper function
                      const SizedBox(height: 10),
                      // const Text(
                      //   'Remaining Compulsory Papers(s):',
                      //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      // ),
                      // buildPapersByLevel(remainingPapers), // Use the helper function
                      if (pathway[index].requirements.isNotEmpty)
                        const SizedBox(height: 10),
                        const Text(
                          'Remaining Requirements:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(pathway[index].requirements),
                        ),
                      if (pathway[index].remainingPoints != 0)
                        const SizedBox(height: 10),
                        const Text(
                          'Remaining Points:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text('${pathway[index].remainingPoints}'),
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          const Text(
                            'Grade Point Average:',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text('${pathway[index].gpa}'),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Helper function to categorize and display papers by level
  Widget buildPapersByLevel(Map<String, List<Paper>> papersByLevel) {
    List<Widget> paperWidgets = [];
    for (var level in ['100-level', '200-level', '300-level']) {
      if (papersByLevel[level]!.isNotEmpty) {
        paperWidgets.add(
          Padding(
            padding: const EdgeInsets.only(left:  16.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$level:',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                for (var paper in papersByLevel[level]!)
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0), // Adjust the left padding as needed
                    child: Text('${paper.papercode} - ${paper.title},'),
                  ),
              ],
            ),
          ),
        );
      }
    }
    return Column(children: paperWidgets);
  }
}
