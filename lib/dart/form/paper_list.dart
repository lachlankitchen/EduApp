import 'package:flutter/material.dart';
import '../paper/paper.dart'; // Import your Paper class here

import '../navigation/nav_bar.dart';

class PapersListScreen extends StatelessWidget {
  final List<Paper> papers;

  const PapersListScreen({Key? key, required this.papers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
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
