import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../degree/degree.dart';
import '../form/degree_list.dart';
import '../form/paper_list.dart';
import '../paper/paper.dart';
import '../points/degree_points_screen.dart';

import '../navigation/navigationProvider.dart';

class navBar extends StatelessWidget {
  const navBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Degree> degreeList = [
      Degree("Bachelor's", "Computer Science", 2022),
      Degree("Bachelor's", "Finance", 2022),
      // Add more degrees here
    ];

        List<Paper> papers = [
      Paper(
        papercode: "PAPER123",
        subjectCode: "SUB123",
        year: "2023",
        title: "Introduction to Dart Programming",
        points: 5,
        efts: 0.5,
        teachingPeriods: ["Semester 1", "Semester 2"],
        description: "An introduction to programming in Dart.",
        prerequisites: ["None"],
        restrictions: ["Open to all students"],
        schedule: "Tuesdays and Thursdays, 10:00 AM - 12:00 PM",
      ),
      // Add more papers here
    ];
    

    return BottomNavigationBar(
      currentIndex: context.watch<navigationProvider>().currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DegreesListScreen(degrees: degreeList),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PapersListScreen(papers: papers)),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DegreesPointsScreen(degrees: degreeList)),
            );
            break;
        }
        context.read<navigationProvider>().currentIndex = index;
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Degrees',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Papers',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Points',
        ),
      ],
    );
  }
}
