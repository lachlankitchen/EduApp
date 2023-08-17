import 'package:edu_app/dart/pathway/pathway.dart';
import 'package:flutter/foundation.dart';

import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';

class PathwayState extends ChangeNotifier {
  List<Pathway> savedPathways = [];

  Degree selectedDegree = Degree(''); // Default value to prevent null errors
  List<Major> selectedMajors = [];
  List<Paper> selectedPapers = [];
  double gpa = -1;

  void addDegree(Degree degree) {
    selectedDegree = degree;
    notifyListeners();
  }

  void addMajors(List<Major> majors) {
    selectedMajors.addAll(majors);
    notifyListeners();
  }

  void addPapers(List<Paper> papers) {
    selectedPapers.addAll(papers);
    notifyListeners();
  }

  void addGPA(double GPA) {
    gpa = GPA;
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
    selectedDegree = Degree(''); // Reset the state
    selectedMajors = [];
    selectedPapers = [];
    notifyListeners();
  }

  void deleteState(Pathway pathway) {
    savedPathways.remove(pathway);
    selectedDegree = Degree(''); // Reset the state
    selectedMajors = [];
    selectedPapers = [];
    notifyListeners();
  }
}