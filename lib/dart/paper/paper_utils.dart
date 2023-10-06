import 'dart:convert';
import 'package:edu_app/dart/paper/paper.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../major/major.dart';

  Future<List<String>> fetchDegrees() async {
    final response = await http.get(Uri.parse('http://localhost:1234/degrees'));

    if (response.statusCode == 200) {
      // If the server did return an OK response, parse the JSON
      Map<String, dynamic> data = jsonDecode(response.body);
      List<String> degrees = List<String>.from(data['degrees']);
      return degrees;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load degrees');
    }
  }
  
  Future<String> fetchMajorData(Degree degree) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/majors'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to load majors');
    }
  }

  Future<String> fetchRecommendedPapers(Degree degree, Major major, int level) async {
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/${major.name}/papers/$level'));
    print(response.body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load recommended papers');
    }
  }

  Future<String> fetchMatchingPapers(String query, int level) async {
    final response = await http.get(Uri.parse('http://localhost:1234/papers/$query/$level'));

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

  Future<String> postPaperData(Degree degree, Major major, List<Paper> papersList) async {

    List<Map<String, dynamic>> jsonPapers = papersListToJson(papersList); 
    String papersString = jsonEncode(jsonPapers);

    print('http://localhost:1234/${degree.title}/${major.name}/$papersString');
    
    final response = await http.get(Uri.parse('http://localhost:1234/${degree.title}/${major.name}/$papersString'));
    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: jsonEncode(jsonPapers), // Replace with your request body
    // );
    
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to validate major requirements');
    }
  }