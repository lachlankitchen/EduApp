import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../grade/grade.dart';
import '../points/degree_points_screen.dart';
import '../home/home.dart';
import 'navigation_provider.dart';

/// Represents the bottom navigation bar for the app.
class NavBar extends StatelessWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: const Color(0xFF10428C),
      // Get the current index from the NavigationProvider using context.watch
      currentIndex: context.watch<NavigationProvider>().currentIndex,
      onTap: (index) {
        // Navigate to different screens based on the selected index
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyHomePage(),
              ),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GradesScreen()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DegreesPointsScreen()),
            );
            break;
        }
        // Update the current index in the NavigationProvider using context.read
        context.read<NavigationProvider>().currentIndex = index;
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'My Pathway',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Grades',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Points',
        ),
      ],
    );
  }
}