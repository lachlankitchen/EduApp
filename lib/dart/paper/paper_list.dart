import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../degree/degree.dart';
import '../home/home.dart';
import '../major/major.dart';
import '../paper/paper.dart';
import '../pathway/pathway_state.dart';
import '../navigation/nav_bar.dart';
import 'fetch_paper.dart';

/// A screen that allows users to select papers and enter grades for each paper.
class PapersListScreen extends StatelessWidget {
  final Degree degree;
  final Major major;
  final List<Paper> compulsoryPapers;
  final List<Paper> oneOfPapers;
  final int level;

  const PapersListScreen({
    Key? key,
    required this.degree,
    required this.major,
    required this.compulsoryPapers,
    required this.oneOfPapers,
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
      body: Row(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: compulsoryPapers.length + 2, // Add 2 for SizedBoxes and Title
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 16.0);
                } else if (index == 1) {
                  // Add title for Compulsory Papers
                  return const ListTile(
                    title: Text(
                      'Compulsory Papers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  final paperIndex = index - 2;
                  return buildPaperListItem(compulsoryPapers[paperIndex]);
                }
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: oneOfPapers.length + 2, // Add 2 for SizedBoxes and Title
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const SizedBox(height: 16.0);
                } else if (index == 1) {
                  // Add title for one of Papers
                  return const ListTile(
                    title: Text(
                      'Choose One of:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                } else {
                  final oneOfPaperIndex = index - 2;
                  return buildPaperListItem(oneOfPapers[oneOfPaperIndex]);
                }
              },
            ),
          ),
          
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              final state = Provider.of<PathwayState>(context, listen: false);

              // Combine the two lists into a single list
              List<Paper> allPapers = [...compulsoryPapers, ...oneOfPapers];

              List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();

              state.addPapers(selectedPapers);
              state.saveState();
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
          ElevatedButton(
            onPressed: () async {
              final state = Provider.of<PathwayState>(context, listen: false);

              // Combine the two lists into a single list
              List<Paper> allPapers = [...compulsoryPapers, ...oneOfPapers];

              List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();

              state.addPapers(selectedPapers);
              state.calculateGPA();

              String jsonData;
              try {
                jsonData = await fetchPaperData(degree, major); // TODO: Make dynamic
                // Now you have the degrees from the server, use them to navigate to the next screen
              } catch (error) {
                // Handle error, perhaps show a dialog to the user
                print('Error fetching papers: $error');
                return; // Early return to exit the function if fetching degrees fails
              }

              int nextlevel = level + 100;
              List<Paper> nextCompulsoryPapers = getPaperData(jsonData, nextlevel, 'compulsory_papers');
              List<Paper> nextOneOfPapers = getPaperData(jsonData, nextlevel, 'one_of_papers');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => PapersListScreen(degree: degree, major: major, compulsoryPapers: nextCompulsoryPapers, oneOfPapers: nextOneOfPapers, level: nextlevel)),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFFf9c000), // Button background color
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Adjust padding as needed
              textStyle: const TextStyle(fontSize: 16), // Text style
            ),
            child: Text('${level+100}-level Selection'),
          ),
        ],
      )

    );
  }     

  Widget buildPaperListItem(Paper paper) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${paper.papercode} - ${paper.title}'),
                SizedBox(
                  width: 80,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    decoration: const InputDecoration(
                      hintText: '0-100',
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
              ],
            ),
          ),
          Checkbox(
            value: paper.isSelected,
            onChanged: (value) {
              // Update the isSelected status of the paper here
              paper.isSelected = !paper.isSelected;
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
  
  Future<String> postPaperData(Degree degree, Major major, List<Paper> papersList) async {
    final url = Uri.parse('http://localhost:1234/${degree.title}/${major.name}');
   
    List<Map<String, dynamic>> jsonPapers = papersListToJson(papersList); 
    String papersJsonString = jsonEncode(jsonPapers);
    
    final response = await http.post(
      url,
      // @CONNOR Using the JSON string as the request body doen't work, I'm working on a fix
      // body: papersJsonString, // Set the JSON string as the request body
      // headers: {
      //   'Content-Type': 'application/json', // Set the Content-Type header
      // }
    );
    
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      throw Exception('Failed to validate pathway');
    }
  }
}

      // floatingActionButton: ElevatedButton(
      //   onPressed: () async {
      //     final state = Provider.of<PathwayState>(context, listen: false);
      //     // Combine the two lists into a single list
      //     List<Paper> allPapers = [...compulsoryPapers, ...oneOfPapers];

      //     // Filter the selected papers
      //     List<Paper> selectedPapers = allPapers.where((paper) => paper.isSelected).toList();

      //     // Calculate GPA based on selected papers' grades
      //     double totalWeightedSum = 0;
      //     int totalWeight = 0;

      //     for (int i = 0; i < selectedPapers.length; i++) {
      //       totalWeightedSum += selectedPapers[i].grade * selectedPapers[i].points;
      //       totalWeight += selectedPapers[i].points;
      //     }

      //     double wam = totalWeightedSum / totalWeight;
      //     double gpa = (wam * 9) / 100;
      //     state.addGPA(gpa);


      //     String jsonData;
      //     try {
      //       jsonData = await fetchPaperData(degree, major, selectedPapers);
      //       // Now you have the degrees from the server, use them to navigate to the next screen
      //     } catch (error) {
      //       // Handle error, perhaps show a dialog to the user
      //       print('Error fetching majors: $error');
      //       return; // Early return to exit the function if fetching degrees fails
      //     }

      //     final jsonMap = json.decode(jsonData);

      //     Map<String, dynamic> jsonDataMap = jsonDecode(jsonData.toString());

      //     // Check if there are remaining compulsory papers
      //     bool hasRemainingPapers = jsonDataMap.containsKey("remaining_compulsory_papers");

      //     // Check if there are remaining points
      //     bool hasRemainingPoints = jsonDataMap.containsKey("remaining_points");

      //     state.addDegree(degree);
      //     state.addMajors(List.of([major]));
      //     state.addPapers(selectedPapers);
      
      //     // if (hasRemainingPapers || hasRemainingPoints) {
      //     //   // Display the remaining requirements
      //     //   String message = "Remaining Requirements:\n";

      //     //   if (hasRemainingPapers) {
      //     //     List<dynamic> remainingPapers = jsonDataMap["remaining_compulsory_papers"];
      //     //     for (var paperEntry in remainingPapers) {
      //     //       MapEntry<String, dynamic> paper = paperEntry.entries.first;
      //     //       String paperCode = paper.key;
      //     //       String paperTitle = paper.value["title"];
      //     //       message += "$paperCode: $paperTitle\n";
      //     //     }
      //     //   }

      //     //   if (hasRemainingPoints) {
      //     //     int remainingPoints = jsonDataMap["remaining_points"];
      //     //     message += "Remaining Points: $remainingPoints";
      //     //   }

      //     //   // Display the message to the user
      //     //   ScaffoldMessenger.of(context).showSnackBar(
      //     //     SnackBar(
      //     //       content: Text(message),
      //     //     ),
      //     //   );
      //     // } else {
      //     //   // No remaining requirements, you can perform other actions here
      //     //   // For example, add papers to state and save state as you mentione
      //     //   state.saveState();
      //     // } 

      //     List<Paper> nextCompulsoryPapers = getPaperData(jsonData, level, 'compulsory_papers');
      //     List<Paper> nextOneOfPapers = getPaperData(jsonData, level, 'one_of_papers');

      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PapersListScreen(degree: degree, major: major, compulsoryPapers: nextCompulsoryPapers, oneOfPapers: nextOneOfPapers, level: 200),
      //       ),
      //     );
      //   },
      //   style: ElevatedButton.styleFrom(
      //     backgroundColor: const Color(0xFFf9c000),
      //   ),
      //   child: const Text('Save'),
      // ),