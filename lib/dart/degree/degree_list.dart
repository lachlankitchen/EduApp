import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'degree.dart';
import '../pathway/pathway_state.dart';

class DegreeListScreen extends StatelessWidget {
  final List<Degree> degrees;
  final Function(Degree) onSelectDegree;

  const DegreeListScreen({Key? key, required this.degrees, required this.onSelectDegree})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Degree'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 25.0), // Add space from header to first degree list item
            ...degrees.map((degree) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    onSelectDegree(degree);
                    navigateToMajorsListScreen(context, context.read<PathwayState>(), degree);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9c000),
                    padding: const EdgeInsets.all(12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    degree.title,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void navigateToMajorsListScreen(
      BuildContext context, PathwayState state, Degree selectedDegree) {
    // Implement the rest of your navigation logic here
  }
}
