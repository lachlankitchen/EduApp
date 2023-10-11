import 'dart:convert';
import 'package:edu_app/dart/paper/paper.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../major/major.dart';
import '../pathway/pathway_state.dart';

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


  // Future<String> postPaperData(Degree degree, Major major, PathwayState state) async {

  //   List<Paper> papers = state.getAllPapers();

  //   List<Map<String, dynamic>> jsonMap = papersListToJson(papers); 
    
  //   print("jsonMap: $jsonMap");

  //   // String jsonPapers = jsonEncode(jsonMap);

  //   // print("jsonPapers: $jsonPapers");

  //   Uri url = Uri.parse('http://localhost:1234/${degree.title}/${major.name}/$jsonMap');
  //   final response = await http.post(url);

  //   if (response.statusCode == 200) {
  //     return response.body;
  //   } else {
  //     print('Error validating degree requirements: ${response.statusCode}');
  //     // If the server did not return a 200 OK response, throw an exception.
  //     throw Exception('Failed to validate major requirements');
  //   }
  // }

  Future<String> postPaperData(Degree degree, Major major, PathwayState state) async {
    String bodyContent = '{"key":"value"}';

    Uri url = Uri.parse('http://localhost:1234/Bachelor of Science (BSc)/Computer Science');
    final response = await http.post(
      url, 
      body: bodyContent,  // Use the stringified JSON here
      headers: {
        // "Content-Type": "application/json",
        "Content-Length": "1000",
        "Accept": "*/*",
        "Connection": "keep-alive",
        "Accept-Encoding": "gzip, deflate, br",
        // Add any other headers if needed
      }
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print('Error validating degree requirements: ${response.statusCode}');
      throw Exception('Failed to validate major requirements');
    }
  }

  