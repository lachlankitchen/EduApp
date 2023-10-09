import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../degree/degree.dart';
import '../degree/degree_list.dart';
import '../major/major.dart';
import '../major/major_list.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart';
import '../paper/paper_utils.dart';
import '../pathway/pathway_state.dart';

   /// Opens the degrees list screen.
  void navigateToDegreesListScreen(BuildContext context) async {
    List<String> jsonData;

    try {
      jsonData = await fetchDegrees();
      // Now you have the degrees from the server, use them to navigate to the next screen
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      // print('Error fetching degrees: $error');
      return; // Early return to exit the function if fetching degrees fails
    }

    List<Degree> degrees = Degree.fromJsonList(jsonData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DegreeListScreen(
          degrees: degrees,
          onSelectDegree: (selectedDegree) {
            Provider.of<PathwayState>(context, listen: false).addDegree(selectedDegree);
          },
        ),
      ),
    );
  }

  /// Navigates to the major list screen.
  ///
  /// [context]: The build context to perform navigation.
  /// [state]: The state containing pathway information.
  /// [selectedDegree]: The selected degree to add to the pathway state.
  ///
  /// This function does not return a value.
  Future<void> navigateToMajorsListScreen(BuildContext context, PathwayState state, Degree degree) async {
    // Pass the selected degree to the state
    state.addDegree(degree);

    String jsonData;
    try {
      jsonData = await fetchMajorData(degree);
      // Now you have the degrees from the server, use them to navigate to the next screen
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      // print('Error fetching majors: $error');
      return; // Early return to exit the function if fetching degrees fails
    }

    final majorsList = List<String>.from(json.decode(jsonData));
    final majors = majorsList.map((major) => Major.fromJsonName(major)).toList();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MajorListScreen(degree: degree, majors: majors),
      ),
    );
  }

  /// Navigates to the papers list screen.
  ///
  /// [context]: The build context for navigation.
  /// [state]: The state containing pathway information.
  /// [selectedMajors]: The list of selected majors.
  Future<void> navigateToPapersListScreen(BuildContext context, Degree degree, Major major, int level) async {
      final state = Provider.of<PathwayState>(context, listen: false);

      String jsonData;
      try {
        jsonData = await fetchRecommendedPapers(degree, major, level);
      } catch (error) {
        // Handle error, perhaps show a dialog to the user
        print('Error fetching recommended papers: $error');
        return; // Early return to exit the function if fetching degrees fails
      }

      List<Paper> recommendedPapers = parseJsonPapers(jsonData);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PapersListScreen(degree: degree, major: major, recommendedPapers: recommendedPapers, electivePapers: [], level: level),
        ),
      );
  }