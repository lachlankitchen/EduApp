import 'package:flutter/material.dart';

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

  TextEditingController nameController = TextEditingController(text: 'Assignment 1');
  TextEditingController scoreController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController targetGradeController = TextEditingController();
  double average = 0.0;
  double targetGrade = 0.0;

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
      print(gradeEntries.toString());

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
      appBar: AppBar(
        title: const Text('Grades'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1, // Takes 50% of the row
                      child: Text(
                        'Average: ${average.toStringAsFixed(1)}',
                        style: const TextStyle(
                          fontSize: 16.0, // Adjust the font size as needed
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1, // Takes 50% of the row
                      child: TextFormField(
                        controller: targetGradeController,
                        decoration: const InputDecoration(labelText: 'Target Grade'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0), // Add some space between the two elements
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        key: const Key('TitleField'), // Add this line
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        key: const Key('ScoreField'), // Add this line
                        controller: scoreController,
                        decoration: const InputDecoration(labelText: 'Score (0-100)'),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        key: const Key('WeightField'), // Add this line
                        controller: weightController,
                        decoration: const InputDecoration(labelText: 'Weight (%)'),
                      ),
                    ),
                  ],
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
        ],
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            backgroundColor: const Color(0xFFf9c000),
            onPressed: _addGradeEntry,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}