import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../major/major.dart';
import '../navigation/nav_bar.dart';
import '../paper/paper_utils.dart';
import '../paper/paper.dart';
import '../paper/paper_list.dart';
import '../pathway/pathway_state.dart'; // Import the SecondListScreen class

class RadioButtonState extends ChangeNotifier {
  int? selectedRadioValue; // Example radio button state

  // Update the radio button state
  void updateRadio(int? newValue) {
    selectedRadioValue = newValue;
    notifyListeners();
  }
}

/// Represents a screen where users can select their majors.
class MajorListScreen extends StatelessWidget {
  final Degree degree;
  final List<Major> majors;

  /// Constructs a [MajorListScreen].
  ///
  /// [majors]: The list of available majors to display.
  const MajorListScreen({Key? key, required this.degree, required this.majors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: const Text('Select Your Majors'),
        backgroundColor: const Color(0xFF10428C),
      ),
      body: ChangeNotifierProvider<RadioButtonState>(
        create: (_) => RadioButtonState(),
        child: Consumer<RadioButtonState>(
          builder: (context, state, child) {
            return ListView(
              children: [
                const SizedBox(height: 16.0),
                ListTile(
                  title: Text(
                    degree.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: majors.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Row(
                        children: [
                          Radio<int>(
                            value: index,
                            groupValue: state.selectedRadioValue,
                            onChanged: (newValue) {
                              state.updateRadio(newValue);
                              Major selectedMajor = majors[index];
                              navigateToPapersListScreen(context, degree, selectedMajor);
                            },
                            fillColor: MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return const Color(0xFFF9C000);
                                }
                                return Colors.grey[600]!;
                              },
                            ),
                          ),
                          Expanded(
                            child: Text(majors[index].name),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Navigates to the papers list screen.
  ///
  /// [context]: The build context for navigation.
  /// [state]: The state containing pathway information.
  /// [selectedMajors]: The list of selected majors.
  Future<void> navigateToPapersListScreen(BuildContext context, Degree degree, Major major) async {
    final state = Provider.of<PathwayState>(context, listen: false);

    int level = 100;

    String jsonRecommendedData;
    List<String> jsonPaperData;

    try {
      jsonRecommendedData = await fetchRecommendedPapers(degree, majors[0], level); // TODO: Make dynamic
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching papers: $error');
      return; // Early return to exit the function if fetching degrees fails
    }

    List<Paper> recommendedPapers = parseJsonPapers(jsonRecommendedData);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PapersListScreen(degree: degree, major: major, recommendedPapers: recommendedPapers, electivePapers: [], level: 100),
      ),
    );
  }
}
