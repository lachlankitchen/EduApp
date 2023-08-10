import 'package:flutter/material.dart';
import '../paper/paper.dart'; // Import your Paper class here

class PapersListScreen extends StatelessWidget {
  final List<Paper> papers;

  const PapersListScreen({required this.papers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers List'),
      ),
      body: ListView.builder(
        itemCount: papers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${papers[index].title}'),
            subtitle: Text('Code: ${papers[index].papercode} | Semester: ${papers[index].teachingPeriods.join(", ")}'),
            onTap: () {
              // Handle onTap event, e.g., navigate to a details screen
            },
          );
        },
      ),
    );
  }
}
