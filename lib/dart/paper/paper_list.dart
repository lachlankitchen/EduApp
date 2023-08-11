import 'package:flutter/material.dart';
import '../paper/paper.dart'; // Import the SecondListScreen class

class PaperListScreen extends StatelessWidget {
  final List<Paper> papers;

  const PaperListScreen({required this.papers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Papers'),
      ),
      body: ListView.builder(
        itemCount: papers.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: ElevatedButton(
              onPressed: () {
                // add to list
              },
              child: Text(papers[index].toString()),
            ),
          );
        },
      ),
    );
  }
}
