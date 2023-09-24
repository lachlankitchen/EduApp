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
  Map<String, List<Paper>> selectedPapers = {
    '100-level': [],
    '200-level': [],
    '300-level': [],
  };  // 
  Map<String, List<Paper>> remainingPapers = {
    '100-level': [],
    '200-level': [],
    '300-level': [],
  };  // Categorize papers by level
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
  void addMajor(Major major) {
    selectedMajors.add(major);
    notifyListeners();
  }

  /// Adds selected papers to the state.
  ///
  /// The [papers] parameter represents the list of papers to be added to the state.
  void addSelectedPapers(List<Paper> papers) {
    print(papers);
    for (var paper in papers) {
      final level = int.parse(paper.papercode.substring(paper.papercode.length - 3));
      if (level >= 100 && level < 200) {
        selectedPapers['100-level']?.add(paper);
      } else if (level >= 200 && level < 300) {
        selectedPapers['200-level']?.add(paper);
      } else if (level >= 300 && level < 400) {
        selectedPapers['300-level']?.add(paper);
      }
    }
    calculateGPA();
    notifyListeners();
  }

  void addRemainingPapers(List<Paper> papers) {
    for (var paper in papers) {
      final level = int.parse(paper.papercode.substring(paper.papercode.length - 3));
      if (level >= 100 && level < 200 && !remainingPapers['100-level']!.contains(paper)) {
        remainingPapers['100-level']?.add(paper);
      } else if (level >= 200 && level < 300 && !remainingPapers['200-level']!.contains(paper)) {
        remainingPapers['200-level']?.add(paper);
      } else if (level >= 300 && level < 400 && !remainingPapers['300-level']!.contains(paper)) {
        remainingPapers['300-level']?.add(paper);
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
    
    List<Paper> allPapers = [];
    selectedPapers.forEach((level, papers) {
      allPapers.addAll(papers);
    });

    for (int i = 0; i < allPapers.length; i++) {
      totalWeightedSum += allPapers[i].grade !* allPapers[i].points;
      totalWeight += allPapers[i].points;
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
    selectedPapers = {
    '100-level': [],
    '200-level': [],
    '300-level': [],
  };  // 
  remainingPapers = {
    '100-level': [],
    '200-level': [],
    '300-level': [],
  };
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
