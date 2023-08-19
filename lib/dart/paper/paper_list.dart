import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';
import '../paper/paper.dart';
import '../pathway/pathway_state.dart';
import '../navigation/nav_bar.dart';

class PapersListScreen extends StatelessWidget {
  final List<Paper> papers;

  const PapersListScreen({Key? key, required this.papers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Select Your Papers'),
        backgroundColor: const Color(0XFF10428C),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return ListView.builder(
            itemCount: papers.length + 1, // Add 1 for SizedBox
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(height: 16.0); // Add padding at the top
              }
              final paperIndex = index - 1; // Adjust index for SizedBox
              return ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${papers[paperIndex].subjectCode} - ${papers[paperIndex].title}'),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              maxLength: 3,
                              decoration: const InputDecoration(
                                hintText: '0-100',
                              ),
                              onChanged: (value) {
                                int? grade = int.tryParse(value);
                                if (grade != null && grade >= 0 && grade <= 100) {
                                  setState(() {
                                    papers[paperIndex].grade = grade;
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Checkbox(
                      value: papers[paperIndex].isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          papers[paperIndex].isSelected = value ?? false;
                        });
                      },
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return const Color(0xFFF9C000); // Set checkbox background color here
                          }
                          return Colors.grey[600]!; // Default background color
                        },
                      ),
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
          final state = Provider.of<PathwayState>(context, listen: false);
          List<Paper> selectedPapers = papers.where((paper) => paper.isSelected).toList();

          // Calculate GPA based on selected papers' grades
          double totalWeightedSum = 0;
          int totalWeight = 0;

          for (int i = 0; i < selectedPapers.length; i++) {
            totalWeightedSum += selectedPapers[i].grade * selectedPapers[i].points;
            totalWeight += selectedPapers[i].points;
          }

          double wam = totalWeightedSum / totalWeight;
          double gpa = (wam / 10) * (9 / 10);
          state.addGPA(gpa);
          state.addPapers(selectedPapers);
          state.saveState();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFf9c000), // Set background color here
        ),
        child: const Text('Save'),
      ),
    );
  }
}
