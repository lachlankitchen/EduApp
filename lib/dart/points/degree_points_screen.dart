import 'package:flutter/material.dart';
import '../degree/degree.dart';
import '../navigation/nav_bar.dart';

//currently a placeholder. will soon display the pie chart for degree points
class DegreesPointsScreen extends StatelessWidget {
  final List<Degree> degrees;

  const DegreesPointsScreen({Key? key, required this.degrees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Points'),
      ),
      body: ListView.builder(
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          return const ListTile(
   //         title: Text('${degrees[index].title} in ${degrees[index].field}'),
   //         subtitle: Text('Year: ${degrees[index].year}'),
          );
        },
      ),
    );
  }
}