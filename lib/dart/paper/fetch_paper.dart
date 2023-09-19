
// Function to retrieve papers
import 'dart:convert';
import 'package:edu_app/dart/paper/paper.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../major/major.dart';

  List<Paper> getLevelPapers(Map<String, dynamic> parsedData, String levelKey, String paperKey) {
    List<Paper> papers = [];
    for (var level in parsedData['levels']) {
      if (level['level'] == levelKey) {
        var paperList = level[paperKey] as List<dynamic>?; // Use null-safe List
        if (paperList != null) {
          for (var paperData in paperList) {
            for (var entry in paperData.entries) {
              final paperCode = entry.key;
              final attributes = entry.value as Map<String, dynamic>;
              final teachingPeriods = (attributes['teaching_periods'] as List<dynamic>)
                ?.map<String>((period) => period.toString())
                ?.toList() ?? []; // Provide a default value if needed

              papers.add(Paper.withName(
                papercode: paperCode,
                title: attributes['title'] ?? '', // Provide a default value if needed
                teachingPeriods: teachingPeriods, // Provide a default value if needed
              ));
            }
          }
        }
      }
    }
    return papers;
  }

  // Function to retrieve and display paper data for each level
  List<Paper> getPaperData(String jsonData, int levelInt, String paperKey) {
    Map<String, dynamic> parsedData = json.decode(jsonData);

    List<dynamic> levels = parsedData['levels'];
    for (var level in levels) {
      if(level["level"] == "$levelInt-level") {
        return getLevelPapers(parsedData, level['level'], paperKey);
      }
    }
    return [];
  }

  Future<String> fetchPaperData(Degree degree, Major major) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/${major.name}'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load majors');
    }
  }