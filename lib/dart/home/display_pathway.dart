import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pathway/pathway.dart';
import '../pathway/pathway_state.dart'; // Import the Pathway class

class DisplayPathway extends StatelessWidget {
  final List<Pathway> pathway;

  const DisplayPathway({
    required this.pathway,
  });

  @override
  Widget build(BuildContext context) {
    if (pathway.isEmpty) {
      return const Center(
        child: Text('No pathway data available.'),
      );
    }

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
                        Provider.of<PathwayState>(context, listen: false).deleteState(pathway[index]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFf9c000), // Set background color here
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
                      ), // Display major heading
                      for (var major in pathway[index].majors)
                        Text('  ${major.name}, '), // Display major name
                    ],
                  ),
                const SizedBox(height: 10),
                if (pathway[index].papers.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Papers(s):',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ), // Display major heading
                      for (var paper in pathway[index].papers)
                        Text('  ${paper.subjectCode} - ${paper.title}, '), // Display paper details

                      if (pathway[index].papers.any((paper) => paper.grade != 0)) 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            const Text(
                              'Grade Point Average:',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ), // Display paper details
                            Text('  ${pathway[index].gpa}'), // Display paper details
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
