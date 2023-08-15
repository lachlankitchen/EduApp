import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home.dart';
import '../paper/paper.dart';
import '../pathway/pathway_state.dart';
class PapersListScreen extends StatelessWidget {
  final List<Paper> papers;

  PapersListScreen(this.papers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers List'),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return ListView.builder(
            itemCount: papers.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('${papers[index].subjectCode} - ${papers[index].title}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Enter Grade: '),
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
                                  papers[index].grade = grade;
                                });
                              }
                            },
                          ),
                        ),
                        Checkbox(
                          value: papers[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              papers[index].isSelected = value ?? false;
                            });
                          },
                        ),
                      ],
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
          double gpa = (wam / 10) * (9/10);
          state.addGPA(gpa);
          print('GPA: ${state.gpa}');
          state.addPapers(selectedPapers);
          state.saveState();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyHomePage()),
          );
        },
        child: const Text('Save'),
      ),
    );
  }
}

