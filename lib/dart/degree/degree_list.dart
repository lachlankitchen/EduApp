import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../major/major.dart';
import '../major/major_list.dart';
import 'degree.dart';
import '../pathway/pathway_state.dart';
import 'package:path_provider/path_provider.dart';


class DegreeListScreen extends StatelessWidget {
  final List<Degree> degrees;
  final Function(Degree) onSelectDegree;

  const DegreeListScreen({
    Key? key,
    required this.degrees,
    required this.onSelectDegree,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Degree'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: ListView.builder(
        itemCount: degrees.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const SizedBox(height: 18.0);
          }

          final degreeIndex = index - 1;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: Hero(
                tag: 'degree-${degrees[degreeIndex].title}',
                child: ElevatedButton(
                  onPressed: () {
                    onSelectDegree(degrees[degreeIndex]);
                    navigateToMajorsListScreen(
                        context, context.read<PathwayState>(), degrees[degreeIndex]);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFf9c000),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(14.0),
                  ),
                  child: Text(
                    degrees[degreeIndex].title,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> navigateToMajorsListScreen(BuildContext context, PathwayState state, Degree degree) async {
    state.addDegree(degree);

    String jsonData;
    try {
      jsonData = await fetchMajorData(degree);
    } catch (error) {
      print('Error fetching majors: $error');
      return;
    }

    final majorsList = List<String>.from(json.decode(jsonData));
    final majors = majorsList.map((major) => Major.fromJsonName(major)).toList();

    final degrees = state.degrees.toList()..add(degree);
    await state.savePathwaysToJson(degrees);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MajorListScreen(degree: degree, majors: majors),
      ),
    );
  }

  Future<String> fetchMajorData(Degree degree) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/majors'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load majors');
    }
  }
}
