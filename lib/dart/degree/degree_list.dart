import 'package:edu_app/dart/navigation/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/nav_utils.dart';
import 'degree.dart';
import '../pathway/pathway_state.dart';

/// A screen that displays a list of degrees to choose from.
class DegreeListScreen extends StatelessWidget {
  final List<Degree> degrees;
  final Function(Degree) onSelectDegree;

  /// Constructs a [DegreeListScreen].
  ///
  /// [degrees] is the list of available degrees to display.
  /// [onSelectDegree] is a callback function when a degree is selected.
  const DegreeListScreen({
    Key? key,
    required this.degrees,
    required this.onSelectDegree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Select a Degree'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: ListView.builder(
        itemCount: degrees.length + 1, // Add 1 for SizedBox
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 18.0); // Add padding at the top
          }
          final degreeIndex = index - 1; // Subtract 1 to adjust for SizedBox
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: Hero(
                tag: 'degree-${degrees[degreeIndex].title}',
                child: ElevatedButton(
                  onPressed: () {
                    onSelectDegree(degrees[degreeIndex]);
                    navigateToMajorsListScreen(context, context.read<PathwayState>(), degrees[degreeIndex]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9c000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(14.0),
                  ),
                  child: Text(
                    degrees[degreeIndex].title,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
