import 'package:flutter/material.dart';
import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';
class DisplayPathway extends StatelessWidget {
  final Degree? degree;
  final List<Major>? majors;
  final List<Paper>? papers;

  const DisplayPathway({Key? key, required this.degree, required this.majors, required this.papers}) : super(key: key);

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
              '${degree?.title ?? "No degree selected"}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            if (majors != null && majors!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Majors:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: majors!.length,
                    itemBuilder: (context, index) {
                      return Text('${majors![index].name}');
                    },
                  ),
                ],
              ),
            if (papers != null && papers!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Papers:'),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: papers!.length,
                    itemBuilder: (context, index) {
                      return Text('${papers![index].subjectCode} - ${papers![index].title}');
                    },
                  ),
                ],
              ),
            // Add more details about the selected degree if needed
          ],
        ),
      ),
    );
  }
}
