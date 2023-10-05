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

class SearchPaperState with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<Paper> filteredPapers = [];

  Future<void> filterItems(String query, int level) async {
    String jsonData;
    try {
      jsonData = await fetchMatchingPapers(query, level);
    } catch (error) {
      // Handle error, perhaps show a dialog to the user
      print('Error fetching matching elective papers: $error');
      jsonData = '[]'; // Set jsonData to an empty list if fetching papers fails
    }

    filteredPapers = parseJsonPapers(jsonData);
    notifyListeners();
  }

  Map<String, bool> paperCheckboxStates = {};

  void updateCheckbox(String paperId, bool newValue) {
    paperCheckboxStates[paperId] = newValue;
    notifyListeners();
  }

  bool getCheckboxState(String paperId) {
    return paperCheckboxStates[paperId] ?? false;
  }
}

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
    final searchPaperState = SearchPaperState();

    return Scaffold(
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        title: Text('Select Your $level-level Papers'),
        backgroundColor: const Color(0XFF10428C),
      ),
      body: ChangeNotifierProvider<SearchPaperState>.value(
        value: searchPaperState,
        child: Consumer<SearchPaperState>(
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
                    return buildPaperListItem(paper, state, context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Elective $level-level Papers',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: TextField(
                    controller: state.searchController,
                    onChanged: (query) {
                      if (query.isNotEmpty) {
                        state.filterItems(query, level);
                      }
                    },
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      hintText: 'Search for papers...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 64.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.filteredPapers.length,
                    itemBuilder: (context, index) {
                      final paper = state.filteredPapers[index];
                      return buildPaperListItem(paper, state, context);
                    },
                  ),
                ),
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
              final pathwayState = Provider.of<PathwayState>(context, listen: false);
              List<Paper> allPapers = [...recommendedPapers, ...searchPaperState.filteredPapers];
              List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();
              String jsonData;
              try {
                jsonData = await postPaperData(degree, major, selectedPapers);
              } catch (error) {
                print('Error fetching remaining major requirements: $error');
                return;
              }
              final jsonMap = json.decode(jsonData);
              Map<String, dynamic> jsonDataMap = jsonDecode(jsonData.toString());
              bool hasRemainingPapers = jsonDataMap.containsKey("remaining_compulsory_papers");
              bool hasRemainingPoints = jsonDataMap.containsKey("remaining_points");
              List<dynamic> remainingPapersList = [];
              List<Paper> remainingPapers = [];
              String message = "Remaining Requirements:\n";
              if (hasRemainingPapers) {
                remainingPapersList = jsonDataMap["remaining_compulsory_papers"];
                for (var paperEntry in remainingPapersList) {
                  MapEntry<String, dynamic> paper = paperEntry.entries.first;
                  String paperCode = paper.key;
                  String paperTitle = paper.value["title"];
                  final teachingPeriods = (paper.value['teaching_periods'] as List<dynamic>)
                    ?.map<String>((period) => period.toString())
                    ?.toList() ?? [];
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
              pathwayState.addMajor(major);
              pathwayState.addSelectedPapers(selectedPapers);
              pathwayState.addRemainingPapers(remainingPapers);
              pathwayState.addRemainingPoints(remainingPoints);
              pathwayState.savePathway();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFf9c000),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Confirm Selection'),
          ),
          const SizedBox(width: 16),
          Visibility(
            visible: level < 300,
            child: ElevatedButton(
              onPressed: () async {
                final state = Provider.of<PathwayState>(context, listen: false);
                List<Paper> allPapers = [...recommendedPapers, ...searchPaperState.filteredPapers];
                List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();
                state.addSelectedPapers(selectedPapers);
                state.calculateGPA();
                int nextlevel = level + 100;
                String jsonRecommendedData;
                List<String> jsonPaperData;
                try {
                  jsonRecommendedData = await fetchRecommendedPapers(degree, major, nextlevel);
                } catch (error) {
                  print('Error fetching papers: $error');
                  return;
                }
                List<Paper> nextRecommendedPapers = parseJsonPapers(jsonRecommendedData);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PapersListScreen(degree: degree, major: major, recommendedPapers: nextRecommendedPapers, electivePapers: [], level: nextlevel)),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFf9c000),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text('${level + 100}-level Selection'),
            ),
          ),
          Visibility(
            visible: Provider.of<PathwayState>(context, listen: false).selectedMajors.isEmpty,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final state = Provider.of<PathwayState>(context, listen: false);
                  List<Paper> allPapers = [...recommendedPapers, ...searchPaperState.filteredPapers];
                  List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();
                  String jsonData;
                  try {
                    jsonData = await postPaperData(degree, major, selectedPapers);
                  } catch (error) {
                    print('Error fetching majors: $error');
                    return;
                  }
                  final jsonMap = json.decode(jsonData);
                  Map<String, dynamic> jsonDataMap = jsonDecode(jsonData.toString());
                  bool hasRemainingPapers = jsonDataMap.containsKey("remaining_compulsory_papers");
                  bool hasRemainingPoints = jsonDataMap.containsKey("remaining_points");
                  List<dynamic> remainingPapersList = [];
                  List<Paper> remainingPapers = [];
                  String message = "Remaining Requirements:\n";
                  if (hasRemainingPapers) {
                    remainingPapersList = jsonDataMap["remaining_compulsory_papers"];
                    for (var paperEntry in remainingPapersList) {
                      MapEntry<String, dynamic> paper = paperEntry.entries.first;
                      String paperCode = paper.key;
                      String paperTitle = paper.value["title"];
                      final teachingPeriods = (paper.value['teaching_periods'] as List<dynamic>)
                        ?.map<String>((period) => period.toString())
                        ?.toList() ?? [];
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
                  backgroundColor: const Color(0xFFf9c000),
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Add Major'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPaperListItem(Paper paper, SearchPaperState state, BuildContext context) {
    final paperId = 'paper_${paper.papercode}';
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
                          hintText: '0-100 (%) or A-D (+/-)',
                          hintStyle: TextStyle(fontSize: 8),
                        ),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            return;
                          }
                          if (RegExp(r'^[0-9]+$').hasMatch(value)) {
                            int grade = int.parse(value);
                            if (grade >= 0 && grade <= 100) {
                              paper.grade = grade;
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Invalid input: Please enter a number between 0 and 100.'),
                                ),
                              );
                            }
                          } else if (RegExp(r'^[A-D][\+\-]?$').hasMatch(value)) {
                            paper.grade = convertLetterGradeToNumeric(value);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid input. Please enter a number between 0 and 100 or a valid grade (A+, A, A-, B+, B, B-, C+, C, C-, or D).'),
                              ),
                            );
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
            value: state.getCheckboxState(paperId),
            onChanged: (newValue) {
              state.updateCheckbox(paperId, newValue ?? false);
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

  int? convertLetterGradeToNumeric(String letterGrade) {
    switch (letterGrade) {
      case 'A+':
        return 90;
      case 'A':
        return 85;
      case 'A-':
        return 80;
      case 'B+':
        return 75;
      case 'B':
        return 70;
      case 'B-':
        return 65;
      case 'C+':
        return 60;
      case 'C':
        return 50;
      case 'C-':
        return 45;
      case 'D':
        return 40;
      default:
        return null;
    }
  }
}
