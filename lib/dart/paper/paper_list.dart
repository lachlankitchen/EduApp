import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../degree/degree.dart';
import '../home/home.dart';
import '../major/major.dart';
import '../navigation/nav_utils.dart';
import '../paper/paper.dart';
import '../pathway/pathway_state.dart';
import '../navigation/nav_bar.dart';
import 'paper_utils.dart';

class PapersListState with ChangeNotifier {
    
  TextEditingController searchController = TextEditingController();
  List<Paper> filteredPapers = [Paper.withName(papercode: "GHJK", title: "HJK", teachingPeriods: ["S1", "S2"], points: 18)];

  Future<void> filterItems(Degree degree, String query) async {

    String jsonData;
    try {
      jsonData = await fetchMatchingPapers(degree, query); // TODO: Make dynamic
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching papers: $error');
      jsonData = '[]'; // Set jsonData to empty list if fetching papers fails
    }

    filteredPapers = parseJsonPapers(jsonData);
    notifyListeners();
  }

  Map<String, bool> paperCheckboxStates = {}; // Map to store checkbox states for each paper

  // Update the checkbox state for a specific paper
  void updateCheckbox(String paperId, bool newValue) {
    paperCheckboxStates[paperId] = newValue;
    notifyListeners();
  }

  // Get the checkbox state for a specific paper
  bool getCheckboxState(String paperId) {
    return paperCheckboxStates[paperId] ?? false;
  } 
}

/// A screen that allows users to select papers and enter grades for each paper.
class PapersListScreen extends StatelessWidget {
  final Degree degree;
  final Major major;
  final List<Paper> recommendedPapers;
  final List<Paper> electivePapers;
  final int level;

  const PapersListScreen({
    Key? key,
    required this.degree,
    required this.major,
    required this.recommendedPapers,
    required this.electivePapers,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: Text('Select Your $level-level Papers'),
        backgroundColor: const Color(0XFF10428C),
      ),
      body: ChangeNotifierProvider<PapersListState>(
        create: (_) => PapersListState(),
        child: Consumer<PapersListState>(
          builder: (context, state, child) {
            return ListView(
              children: [
                const SizedBox(height: 16.0),
                const ListTile(
                  title: Text(
                    'Recommended Papers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: recommendedPapers.length,
                  itemBuilder: (context, index) {
                    final paper = recommendedPapers[index];
                    return buildPaperListItem(paper, state);
                  },
                ),
                const ListTile(
                  title: Text(
                    'Elective Papers',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        controller: state.searchController,
                        onChanged: (query) {
                          state.filterItems(degree, query);
                        },
                        decoration: const InputDecoration(
                          labelText: 'Search',
                          hintText: 'Search for papers...',
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: ListView.builder(
                    //     itemCount: state.filteredPapers.length,
                    //     itemBuilder: (context, index) {
                    //       return ListTile(
                    //         title: Text('${state.filteredPapers[index].papercode} - ${state.filteredPapers[index].title}'),
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                )
              ],
            );
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () async {
              final state = Provider.of<PathwayState>(context, listen: false);
              // Combine the two lists into a single list
              List<Paper> allPapers = [...recommendedPapers, ...electivePapers];

              // Filter the selected papers
              List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();

              String jsonData;
              try {
                jsonData = await postPaperData(degree, major, selectedPapers);
                // Now you have the degrees from the server, use them to navigate to the next screen
              } catch (error) {
                // Handle error, perhaps show a dialog to the user
                print('Error fetching remaining major requirements: $error');
                return; // Early return to exit the function if fetching degrees fails
              }

              final jsonMap = json.decode(jsonData);

              Map<String, dynamic> jsonDataMap = jsonDecode(jsonData.toString());

              // Check if there are remaining compulsory papers
              bool hasRemainingPapers = jsonDataMap.containsKey("remaining_compulsory_papers");

              // Check if there are remaining points
              bool hasRemainingPoints = jsonDataMap.containsKey("remaining_points");

              List<dynamic> remainingPapersList = [];
              List<Paper> remainingPapers = [];

              // Display the remaining requirements
              String message = "Remaining Requirements:\n";

              if (hasRemainingPapers) {
                remainingPapersList = jsonDataMap["remaining_compulsory_papers"];
                for (var paperEntry in remainingPapersList) {
                  MapEntry<String, dynamic> paper = paperEntry.entries.first;
                  String paperCode = paper.key;
                  String paperTitle = paper.value["title"];
                  final teachingPeriods = (paper.value['teaching_periods'] as List<dynamic>)
                    ?.map<String>((period) => period.toString())
                    ?.toList() ?? []; // Provide a default value if needed

                  Paper remainingPaper = Paper.withName(papercode: paperCode, title: paper.value["title"], teachingPeriods: teachingPeriods, points: paper.value["points"]);
                  remainingPapers.add(remainingPaper);
                  message += "$paperCode: $paperTitle\n";
                }
              }

              int remainingPoints = 0;
              if (hasRemainingPoints) {
                remainingPoints = jsonDataMap["remaining_points"];
                message += "Remaining Points: $remainingPoints";
              }

              // Display the message to the user
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            
              state.addMajor(major);
              state.addSelectedPapers(selectedPapers);
              state.addRemainingPapers(remainingPapers);
              state.addRemainingPoints(remainingPoints);
              state.savePathway();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf9c000), // Button background color
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Adjust padding as needed
              textStyle: const TextStyle(fontSize: 16), // Text style
            ),
            child: const Text('Save'),
          ),
          const SizedBox(width: 16), // Add spacing between buttons
          Visibility(
            visible: level < 300, // Check if the level is less than to 300
            child: ElevatedButton(
              onPressed: () async {
                final state = Provider.of<PathwayState>(context, listen: false);
          
                // Combine the two lists into a single list
                List<Paper> allPapers = [...recommendedPapers, ...electivePapers];
          
                List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();
          
                state.addSelectedPapers(selectedPapers);
                state.calculateGPA();
          
                int nextlevel = level + 100;

                String jsonRecommendedData;
                List<String> jsonPaperData;
                try {
                  jsonRecommendedData = await fetchRecommendedPapers(degree, major, nextlevel); // TODO: Make dynamic
                } catch (error) {
                  // Handle error, perhaps show a dialog to the user
                  print('Error fetching papers: $error');
                  return; // Early return to exit the function if fetching degrees fails
                }

                List<Paper> nextRecommendedPapers = parseJsonPapers(jsonRecommendedData);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PapersListScreen(degree: degree, major: major, recommendedPapers: nextRecommendedPapers, electivePapers: [], level: nextlevel)),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFf9c000), // Button background color
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Adjust padding as needed
                textStyle: const TextStyle(fontSize: 16), // Text style
              ),
              child: Text('${level+100}-level Selection'),
            ),
          ),
          Visibility(
            visible: Provider.of<PathwayState>(context, listen: false).selectedMajors.isEmpty, // Check if the level is less than to 300
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final state = Provider.of<PathwayState>(context, listen: false);
                  
                  print(state.selectedMajors.length);
                  // Combine the two lists into a single list
                  List<Paper> allPapers = [...recommendedPapers, ...electivePapers];
            
                  // Filter the selected papers
                  List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();
            
                  String jsonData;
                  try {
                    jsonData = await postPaperData(degree, major, selectedPapers);
                    // Now you have the degrees from the server, use them to navigate to the next screen
                  } catch (error) {
                    // Handle error, perhaps show a dialog to the user
                    print('Error fetching majors: $error');
                    return; // Early return to exit the function if fetching degrees fails
                  }
            
                  final jsonMap = json.decode(jsonData);
            
                  Map<String, dynamic> jsonDataMap = jsonDecode(jsonData.toString());
            
                  // Check if there are remaining compulsory papers
                  bool hasRemainingPapers = jsonDataMap.containsKey("remaining_compulsory_papers");
            
                  // Check if there are remaining points
                  bool hasRemainingPoints = jsonDataMap.containsKey("remaining_points");
            
                  List<dynamic> remainingPapersList = [];
                  List<Paper> remainingPapers = [];
            
                  // Display the remaining requirements
                  String message = "Remaining Requirements:\n";
            
                  if (hasRemainingPapers) {
                    remainingPapersList = jsonDataMap["remaining_compulsory_papers"];
                    for (var paperEntry in remainingPapersList) {
                      MapEntry<String, dynamic> paper = paperEntry.entries.first;
                      String paperCode = paper.key;
                      String paperTitle = paper.value["title"];
                      final teachingPeriods = (paper.value['teaching_periods'] as List<dynamic>)
                        ?.map<String>((period) => period.toString())
                        ?.toList() ?? []; // Provide a default value if needed
            
                      Paper remainingPaper = Paper.withName(papercode: paperCode, title: paper.value["title"], teachingPeriods: teachingPeriods, points: paper.value["points"]);
                      remainingPapers.add(remainingPaper);
                      message += "$paperCode: $paperTitle\n";
                    }
                  }
            
                  int remainingPoints = 0;
                  if (hasRemainingPoints) {
                    remainingPoints = jsonDataMap["remaining_points"];
                    message += "Remaining Points: $remainingPoints";
                  }
            
                  // Display the message to the user
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                    ),
                  );
                
                  state.addMajor(major);
                  state.addSelectedPapers(selectedPapers);
                  state.addRemainingPapers(remainingPapers);
                  state.addRemainingPoints(remainingPoints);
            
                  navigateToMajorsListScreen(context, context.read<PathwayState>(), degree);
                },
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xFFf9c000), // Button background color
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Adjust padding as needed
                  textStyle: const TextStyle(fontSize: 16), // Text style
                ),
                child: const Text('Select Another Major'),
              ),
            ),
          ),
        ],
      )
    );
  }     

  Widget buildPaperListItem(Paper paper, PapersListState state) {
    final paperId = 'paper_${paper.papercode}'; // Generate a unique identifier for each paper
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${paper.papercode} - ${paper.title}'),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Text('Grade:'),
                    ),
                    SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        decoration: const InputDecoration(
                          hintText: '0-100 (%)',
                        ),
                        onChanged: (value) {
                          int? grade = int.tryParse(value);
                          if (grade != null && grade >= 0 && grade <= 100) {
                            // Update the grade of the paper here
                            paper.grade = grade;
                          }
                        },
                      ),
                    ),
                  ]
                )
              ],
            ),
          ),
          Checkbox(
            value: state.getCheckboxState(paperId), // Use the state for the checkbox
            onChanged: (newValue) {
              state.updateCheckbox(paperId, newValue ?? false);
              // Update the isSelected status of the paper here
              paper.isSelected = newValue ?? false;
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
        ],
      ),
    );
  }   
}
      