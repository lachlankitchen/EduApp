
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
              final points = attributes['points'];

              papers.add(Paper.withName(
                papercode: paperCode,
                title: attributes['title'] ?? '', // Provide a default value if needed
                teachingPeriods: teachingPeriods, // Provide a default value if needed
                points: points
              ));
            }
          }
        }
      }
    }
    return papers;
  }

  Future<List<String>> fetchAllPapers(String degree, int level) async {
    final response = await http.get(Uri.parse('http://localhost:1234/$degree/papers/$level'));

    if (response.statusCode == 200) {
      // If the server did return an OK response, parse the JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      return List<String>.from(data['papers']);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load $degree papers');
    }
  }

  Future<String> fetchRecommendedPapers(Degree degree, Major major, int level) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/${major.name}/papers/$level'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load recommended papers');
    }
  }

  Future<String> fetchMatchingPapers(Degree degree, String query) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/papers/$query'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load recommended papers');
    }
  }

  List<Paper> parseJsonPapers(String json) {
    final Map<String, dynamic> jsonData = jsonDecode(json);
    
    final List<Paper> recommendedPapers = jsonData.entries.map((entry) {
      final papercode = entry.key;
      final paperData = entry.value;
      return Paper.fromJson(papercode, paperData);
    }).toList();
    return recommendedPapers;
  }