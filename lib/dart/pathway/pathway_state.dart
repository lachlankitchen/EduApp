import 'package:edu_app/dart/pathway/pathway.dart';
import 'package:flutter/foundation.dart';

import '../degree/degree.dart';
import '../major/major.dart';
import '../paper/paper.dart';

/// A class that manages the state of saved pathways and selections.
///
/// The [PathwayState] class extends [ChangeNotifier] to provide a way to manage
/// the state of selected degrees, majors, papers, and grade point averages (GPAs).
class PathwayState extends ChangeNotifier {
  List<Pathway> savedPathways = [];
  Degree selectedDegree = Degree('');
  List<Major> selectedMajors = [];
  List<Paper> selectedPapers = [];
  List<Paper> remainingPapers = [];
  double gpa = -1;

  /// Adds a selected degree to the state.
  ///
  /// The [degree] parameter represents the degree to be added to the state.
  void addDegree(Degree degree) {
    selectedDegree = degree;
    notifyListeners();
  }

  /// Adds selected majors to the state.
  ///
  /// The [majors] parameter represents the list of majors to be added to the state.
  void addMajors(List<Major> majors) {
    selectedMajors.clear();

    for (var major in majors) {
      if (!selectedMajors.contains(major)) {
        selectedMajors.add(major);
      }
    }
    notifyListeners();
  }

  /// Adds selected papers to the state.
  ///
  /// The [papers] parameter represents the list of papers to be added to the state.
  void addSelectedPapers(List<Paper> papers) {
    for (var paper in papers) {
      if (!selectedPapers.contains(paper)) {
        selectedPapers.add(paper);
      }
    }
    calculateGPA();
    notifyListeners();
  }

  void addRemainingPapers(List<Paper> papers) {
    for (var paper in papers) {
      if (!remainingPapers.contains(paper)) {
        remainingPapers.add(paper);
      }
    }
    notifyListeners();
  }

  /// Adds a calculated GPA to the state.
  ///
  /// The [gradePointAverage] parameter represents the calculated GPA to be added to the state.
  void calculateGPA() {
    // Calculate GPA based on selected papers' grades
    double totalWeightedSum = 0;
    int totalWeight = 0;
    
    for (int i = 0; i < selectedPapers.length; i++) {
      totalWeightedSum += selectedPapers[i].grade !* selectedPapers[i].points;
      totalWeight += selectedPapers[i].points;
    }

    double wam = totalWeightedSum / totalWeight;
    gpa = (wam * 9) / 100;

    notifyListeners();
  }

  /// Saves the current state as a pathway.
  ///
  /// This method creates a new [Pathway] object and adds it to the [savedPathways] list.
  /// The current state, including the selected degree, majors, papers, GPA, and selection status,
  /// is captured and reset after saving.
  void savePathway() {
    print(remainingPapers);
    Pathway pathway = Pathway(
      degree: selectedDegree,
      majors: selectedMajors,
      selectedPapers: selectedPapers,
      remainingPapers: remainingPapers,
      gpa: gpa,
      isSelected: false,
    );
    savedPathways.add(pathway);
    selectedDegree = Degree(''); // Reset the state
    selectedMajors = [];
    selectedPapers = [];
    remainingPapers = [];
    notifyListeners();
  }

  /// Deletes a saved pathway from the state.
  ///
  /// The [pathway] parameter represents the pathway to be removed from the [savedPathways] list.
  /// The state is reset after deletion.
  void deleteState(Pathway pathway) {
    savedPathways.remove(pathway);
    notifyListeners();
  }
}
