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
  String requirements = "";
  int furtherPoints = 0;
  int pointsAt200Level = 0;
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
    bool containsMajor = false;

    for (Major selectedMajor in selectedMajors) {
        if (selectedMajor.name == major.name) {
            containsMajor = true;
            break;
        }
    }

    if (!containsMajor) {
        selectedMajors.add(major);
        notifyListeners();
    }
  }



  /// Adds selected papers to the state.
  ///
  /// The [papers] parameter represents the list of papers to be added to the state.
  void addSelectedPapers(List<Paper> papers) {
    for (var paper in papers) {
      final level = int.parse(paper.papercode.substring(paper.papercode.length - 3));
      final key = levelToKey(level);
      final paperSet = selectedPapers[key];

      if (!paperSet!.any((existingPaper) => existingPaper.papercode == paper.papercode)) {
        paperSet.add(paper);
      }
    }
    calculateGPA();
    notifyListeners();
  }

  List<Paper> getAllPapers() {
    List<Paper> allPapers = [];
    selectedPapers.values.forEach((papers) => allPapers.addAll(papers));
    return allPapers;
  }

  void addRemainingPapers(List<Paper> papers) {
    for (var paper in papers) {
      final level = int.parse(paper.papercode.substring(paper.papercode.length - 3));
      final key = levelToKey(level);
      final paperSet = remainingPapers[key];

      if (!paperSet!.any((existingPaper) => existingPaper.papercode == paper.papercode)) {
        paperSet.add(paper);
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
      if(allPapers[i].grade != -1) {
        totalWeightedSum += allPapers[i].grade !* allPapers[i].points;
        totalWeight += allPapers[i].points;
      }
    }

    double wam = totalWeightedSum / totalWeight;
    gpa = (wam * 9) / 100;
    notifyListeners();
  }

  void addFurtherPoints(int furtherPoints){
    this.furtherPoints = furtherPoints;
    notifyListeners();
  }

  void addPointsAt200Level(int pointsAt200Level){
    this.pointsAt200Level = pointsAt200Level;
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
      furtherPoints: furtherPoints,
      pointsAt200Level: pointsAt200Level,
      requirements: requirements,
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
  
  String levelToKey(int level) {
    if (level >= 100 && level < 200) {
      return '100-level';
    } else if (level >= 200 && level < 300) {
      return '200-level';
    } else if (level >= 300 && level < 400) {
      return '300-level';
    }
    throw ArgumentError('Invalid level: $level');
  }

  void addRequirements(String message) {
    requirements = message;
    notifyListeners();
  }
}
