import 'package:edu_app/dart/degree/degree.dart';
import 'package:edu_app/dart/major/major.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:edu_app/dart/paper/paper.dart';
import 'package:edu_app/dart/pathway/pathway.dart';
import 'package:edu_app/dart/pathway/pathway_state.dart';
import 'package:edu_app/dart/points/degree_points_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

void main() {
  testWidgets('Test DegreesPointsScreen Widget', (WidgetTester tester) async {
    final Degree mockDegree = Degree.fromJson({
      'title': 'Bachelor of Science',
    });

    final List<Major> mockMajors = [
      Major.fromJson({
        'name': 'Major 1',
        'levels': [
          {
            'level': 100,
            'papers': ['PAPER1', 'PAPER2'],
            'points': 120,
          },
          {
            'level': 200,
            'papers': ['PAPER3'],
            'points': 150,
          },
        ],
        'totalPoints': 360,
        'isSelected': false,
      }),
      Major.fromJson({
        'name': 'Major 2',
        'requirements': [
              {
            'level': 100,
            'papers': ['PAPER1', 'PAPER2'],
            'points': 120,
          },
          {
            'level': 200,
            'papers': ['PAPER3'],
            'points': 150,
          }
        ],
        'totalPoints': 360,
        'isSelected': false,
      }),
    ];

    List<Paper> mockPapers = [
      Paper(
        papercode: "COMP161",
        subjectCode: "Computer and Information Science",
        year: "2023",
        title: "Computer Programming",
        points: 18,
        efts: 0.1500,
        teachingPeriods: ["S1", "S2"],
        description: "An introduction to computer programming suitable for beginners with little or no prior experience. Introduces the Java programming language, basic object-oriented concepts, and simple graphical applications. If you have no prior computer programming background, then COMP 161 is the paper for you. It is a beginner's introduction to programming in the object-oriented Java language. We offer COMP 161 on campus in S1, and by distance in S2 and in a 'non-standard' period (N1 / Pre Christmas Summer School). COMP 161 occupies an important part in the computer science curriculum because it is normally required preparation for COMP 162 (which is a prerequisite for all 200-level Computer Science papers). Students with prior programming experience may sit an Advanced Placement Test for direct entry to COMP162.",
        prerequisites: [],
        restrictions: ["COMP 160"],
        schedule: "Arts and Music, Commerce, Science",
        isSelected: false,
      ),
      Paper(
        papercode: "COSC201",
        subjectCode: "Computer Science",
        year: "2023",
        title: "Algorithms and Data Structures",
        points: 18,
        efts: 0.1500,
        teachingPeriods: ["S1"],
        description: "Development and analysis of fundamental algorithms and data structures and their applications including: sorting and searching, dynamic programming, graph and tree algorithms, and string processing algorithms.",
        prerequisites: ["COMP 160", "COMP 162"],
        restrictions: ["COSC 242"],
        schedule: "Arts and Music, Commerce, Science",
        isSelected: false,
      ),
      Paper(
        papercode: "COSC326",
        subjectCode: "Computer Science",
        year: "2023",
        title: "Computational Problem Solving",
        points: 18,
        efts: 0.15,
        teachingPeriods: ["S1"],
        description: "Solving problems in a computational environment. Choosing the right techniques, verifying performance, understanding and satisfying client requirements. Working individually and in teams to provide effective solutions. This paper develops and extends the analytical and creative skills required in programming. A series of \u00e9tudes - some individual, some in pairs and some in groups - require solutions that challenge your abilities as programmers. As well as finding solutions, there is an emphasis on testing and verifying them and communicating the outcome to the \"client\" (who, in this case, is the instructor).",
        prerequisites: ["COSC 201", "COSC 202", "COSC 242"],
        restrictions: [],
        schedule: "Arts and Music, Science",
        isSelected: false,
      ),
    ];

    final Pathway mockPathway = Pathway(degree: mockDegree, majors: mockMajors, papers: mockPapers, gpa: 0, isSelected: true);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              final state = Provider.of<PathwayState>(context, listen: false);
              state.savedPathways = [mockPathway];

              return const DegreesPointsScreen();
            },
          ),
        ),
      ),
    );

    // Verify that the PieChart is displayed
    expect(find.byType(PieChart), findsOneWidget);

    // Verify that the PieChart data contains the expected majors and their total points
    final pieChartFinder = find.byType(PieChart);
    final pieChartWidget = tester.widget<PieChart>(pieChartFinder);

    expect(pieChartWidget.dataMap, {
      'Major 1': 54.0, // Updated value based on your mock data
      'Major 2': 54.0, // (3 * 18)
      'Remaining Points': 666.0, // (360 * 2) - (3 * 18)
    });
  });
}
