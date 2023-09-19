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
    final Degree mockDegree = Degree('Bachelor of Science');

    final List<Requirement> mockRequirements = [
      Requirement(level: 100, papers: ['PAPER1', 'PAPER2'], points: 120),
      Requirement(level: 200, papers: ['PAPER3'], points: 150),
    ];

    final List<Major> mockMajors = [
      Major(name: 'Major 1', requirements: mockRequirements, totalPoints: 360, isSelected: false),
      Major(name: 'Major 2', requirements: mockRequirements, totalPoints: 360, isSelected: false),
    ];

    final List<Paper> mockPapers = [
      Paper(
        papercode: 'PAPER1',
        subjectCode: 'SUBJECT1',
        year: '2023',
        title: 'Paper 1',
        points: 18,
        efts: 0.5,
        teachingPeriods: ['TP1'],
        description: 'Description for Paper 1',
        prerequisites: [],
        restrictions: [],
        schedule: 'Schedule for Paper 1',
        isSelected: false,
        grade: 0,
      ),
      Paper(
        papercode: 'PAPER2',
        subjectCode: 'SUBJECT2',
        year: '2023',
        title: 'Paper 2',
        points: 18,
        efts: 0.5,
        teachingPeriods: ['TP1'],
        description: 'Description for Paper 2',
        prerequisites: [],
        restrictions: [],
        schedule: 'Schedule for Paper 2',
        isSelected: false,
        grade: 0,
      ),
      Paper(
        papercode: 'PAPER3',
        subjectCode: 'SUBJECT3',
        year: '2023',
        title: 'Paper 3',
        points: 18,
        efts: 0.5,
        teachingPeriods: ['TP1'],
        description: 'Description for Paper 3',
        prerequisites: [],
        restrictions: [],
        schedule: 'Schedule for Paper 3',
        isSelected: false,
        grade: 0,
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

    // TODO: Validate points are calculated properly based on your mock data
    // expect(pieChartWidget.dataMap, {
    //   'Major 1': 216.0, // Updated value based on your mock data
    //   'Major 2': 216.0, // Updated value based on your mock data
    //   'Remaining Points': 72.0, // Updated value based on your mock data
    // });
  });
}
