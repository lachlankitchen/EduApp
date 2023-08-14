import 'package:flutter/material.dart';
import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';

class DisplayPathway extends StatelessWidget {
  final Degree? degree;
  final List<Major>? majors;
  final List<Paper>? papers;

  const DisplayPathway({required this.degree, required this.majors, required this.papers});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              degree != null ? '${degree!.title}' : 'No degree selected',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            if (degree != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (majors != null && majors!.isNotEmpty)
                    Text('Majors: ${majors![0].name}'),
                  if (papers != null && papers!.isNotEmpty)
                    Text('Papers: ${papers![0].title}'),
                  // Add more details about the selected degree if needed
                ],
              )
          ],
        ),
      ),
    );
  }
}
