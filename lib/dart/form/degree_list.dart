import 'package:flutter/material.dart';
import '../degree/degree.dart';
import '../navigation/navBar.dart';

class DegreesListScreen extends StatelessWidget {
  final List<Degree> degrees;

  const DegreesListScreen({required this.degrees});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: navBar(),
      appBar: AppBar(
        title: const Text('Degrees List'),
      ),
      body: ListView.builder(
        itemCount: degrees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${degrees[index].title} in ${degrees[index].field}'),
            subtitle: Text('Year: ${degrees[index].year}'),
          );
        },
      ),
    );
  }
}