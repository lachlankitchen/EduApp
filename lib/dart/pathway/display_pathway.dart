import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        child: Text('No pathway data available.'),
      );
    }

    // Build a list of saved pathways using a ListView builder.
    return ListView.builder(
      itemCount: pathway.length,
      itemBuilder: (context, index) {
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
                      pathway[index].degree.title, // Display degree title
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Delete the saved pathway when the button is pressed.
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
                // Display saved majors, if available.
                if (pathway[index].majors.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Major(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      for (var major in pathway[index].majors)
                        Text('  ${major.name}, '),
                    ],
                  ),
                const SizedBox(height: 10),
                // Display saved papers, if available.
                if (pathway[index].selectedPapers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Papers(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      for (var paper in pathway[index].selectedPapers)
                        Text('  ${paper.papercode} - ${paper.title}, '),
                      const SizedBox(height: 10),
                      const Text(
                        'Remaining Compulsory Papers(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      for (var paper in pathway[index].remainingPapers)
                        Text('  ${paper.papercode} - ${paper.title}, '),
                      const SizedBox(height: 10),
                      // Display GPA if there are papers with grades.
                      if (pathway[index].selectedPapers.any((paper) => paper.grade != 0))
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Grade Point Average:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text('  ${pathway[index].gpa}'),
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
}
