import 'package:edu_app/dart/pathway/pathway.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;
import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';


class PathwayState extends ChangeNotifier {
  List<Pathway> savedPathways = [];
  Degree selectedDegree = Degree('');
  List<Major> selectedMajors = [];
  List<Paper> selectedPapers = [];
  double gpa = -1;
  List<Degree> degrees = [];

  void addDegree(Degree degree) {
    selectedDegree = degree;
    notifyListeners();
  }

  void addMajors(List<Major> majors) {
    selectedMajors.clear();

    for (var major in majors) {
      if (!selectedMajors.contains(major)) {
        selectedMajors.add(major);
      }
    }
    notifyListeners();
  }

  void addPapers(List<Paper> papers) {
    for (var paper in papers) {
      if (!selectedPapers.contains(paper)) {
        selectedPapers.add(paper);
      }
    }

    print('calculateGPA(); $gpa');
    calculateGPA();

    notifyListeners();
  }

  void calculateGPA() {
    double totalWeightedSum = 0;
    int totalWeight = 0;

    for (int i = 0; i < selectedPapers.length; i++) {
      totalWeightedSum +=
          selectedPapers[i].grade! * selectedPapers[i].points;
      totalWeight += selectedPapers[i].points;
    }

    double wam = totalWeightedSum / totalWeight;
    gpa = (wam * 9) / 100;

    notifyListeners();
  }

  void saveState() {
    Pathway pathway = Pathway(
      degree: selectedDegree,
      majors: selectedMajors,
      papers: selectedPapers,
      gpa: gpa,
      isSelected: false,
    );
    savedPathways.add(pathway);
    selectedDegree = Degree('');
    selectedMajors = [];
    selectedPapers = [];
    notifyListeners();
  }

  void deleteState(Pathway pathway) {
    savedPathways.remove(pathway);
    selectedDegree = Degree('');
    selectedMajors = [];
    selectedPapers = [];
    notifyListeners();
  }

  Future<void> savePathwaysToJson(List<Degree> degrees) async {
    final directory = await getApplicationDocumentsDirectory();
    final pathToSave = path.join(directory.path, 'pathways.json');
    final data = degrees.map((degree) => degree.toJson()).toList();
    final jsonContent = jsonEncode(data);
    await File(pathToSave).writeAsString(jsonContent);
  }

  Future<void> loadPathwaysFromJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final pathToLoad = path.join(directory.path, 'pathways.json');

    try {
      final jsonContent = await File(pathToLoad).readAsString();
      final data = jsonDecode(jsonContent) as List<dynamic>;
      degrees = data.map((json) => Degree.fromJson(json)).toList();
    } catch (e) {
      print('Error loading pathways: $e');
      degrees = [];
    }
    notifyListeners();
  }
}
