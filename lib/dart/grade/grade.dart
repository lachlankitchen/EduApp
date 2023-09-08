import 'package:flutter/material.dart';

import '../navigation/nav_bar.dart';

class GradesScreen extends StatefulWidget {
  GradesScreen({Key? key}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class GradeEntry {
  String name;
  double score;
  double weight;

  GradeEntry(this.name, this.score, this.weight);
}

class _GradesScreenState extends State<GradesScreen> {
  List<GradeEntry> gradeEntries = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  double average = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateAverage();
  }

  void _addGradeEntry() {
    String name = nameController.text;
    double score = double.tryParse(scoreController.text) ?? 0.0;
    double weight = double.tryParse(weightController.text) ?? 0.0;

    setState(() {
      gradeEntries.add(GradeEntry(name, score, weight));
      nameController.clear();
      scoreController.clear();
      weightController.clear();
      _calculateAverage();
    });
  }

  void _calculateAverage() {
    double total = 0.0;
    double totalWeights = 0.0;

    for (var entry in gradeEntries) {
      total += entry.score * (entry.weight / 100.0);
      totalWeights += entry.weight;
    }

    setState(() {
      average = totalWeights > 0 ? 100 * total / totalWeights : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Grades'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Title'),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: scoreController,
                    decoration: InputDecoration(labelText: 'Score (0-100)'),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: weightController,
                    decoration: InputDecoration(labelText: 'Weight (%)'),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addGradeEntry,
                  child: Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9c000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(14.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: gradeEntries.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(gradeEntries[index].name),
                  subtitle: Text(
                      'Score: ${gradeEntries[index].score.toStringAsFixed(2)}, Weight: ${gradeEntries[index].weight.toStringAsFixed(2)}%'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0), // Adjust the top padding as needed
            child: Text(
              'Average: ${average.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24, // Increase the font size
                fontWeight: FontWeight.bold, // Make it bold
                color: Colors.blue, // Change the text color to blue (you can choose any color you like)
              ),
            ),
          ),


        ],
      ),
    );
  }
}