import 'package:edu_app/dart/degree/degree.dart';
import 'package:edu_app/dart/home/home.dart';
import 'package:edu_app/dart/major/major.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:edu_app/dart/paper/paper.dart';
import 'package:edu_app/dart/paper/paper_list.dart'; // Import the PapersListScreen class
import 'package:edu_app/dart/pathway/pathway_state.dart';

void main() {
  testWidgets('Test PapersListScreen Widget', (WidgetTester tester) async {

    // Create mockDegree, mockMajor, mockCompulsoryPapers, mockOneOfPapers, and mockLevel
    final Degree mockDegree = Degree('Bachelor of Science');
    final Major mockMajor = Major.withName(name: 'Computer Science');
    final List<Paper> mockCompulsoryPapers = [
      Paper(
        papercode: 'CS101',
        subjectCode: 'COMPSCI',
        year: '2023',
        title: 'Introduction to Computer Science',
        points: 18,
        efts: 0.125,
        teachingPeriods: ['Semester 1'],
        description: 'An introduction to...',
        prerequisites: [],
        restrictions: [],
        schedule: 'Lecture 1: Monday 9:00 AM',
        isSelected: false,
        grade: 0,
      ),
      Paper(
        papercode: 'MATH201',
        subjectCode: 'MATH',
        year: '2023',
        title: 'Advanced Mathematics',
        points: 15,
        efts: 0.125,
        teachingPeriods: ['Semester 2'],
        description: 'A deeper exploration of...',
        prerequisites: [],
        restrictions: [],
        schedule: 'Lecture 1: Tuesday 10:00 AM',
        isSelected: false,
        grade: 0,
      ),
      // Add more mock papers as needed
    ];

    final List<Paper> mockOneOfPapers = [
      Paper(
        papercode: 'CS101',
        subjectCode: 'COMPSCI',
        year: '2023',
        title: 'Introduction to Computer Science',
        points: 18,
        efts: 0.125,
        teachingPeriods: ['Semester 1'],
        description: 'An introduction to...',
        prerequisites: [],
        restrictions: [],
        schedule: 'Lecture 1: Monday 9:00 AM',
        isSelected: false,
        grade: 0,
      ),
      Paper(
        papercode: 'MATH201',
        subjectCode: 'MATH',
        year: '2023',
        title: 'Advanced Mathematics',
        points: 15,
        efts: 0.125,
        teachingPeriods: ['Semester 2'],
        description: 'A deeper exploration of...',
        prerequisites: [],
        restrictions: [],
        schedule: 'Lecture 1: Tuesday 10:00 AM',
        isSelected: false,
        grade: 0,
      ),
      // Add more mock papers as needed
    ];
    const int mockLevel = 100;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => PapersListScreen(
              degree: mockDegree,
              major: mockMajor,
              compulsoryPapers: mockCompulsoryPapers,
              oneOfPapers: mockOneOfPapers,
              level: mockLevel,
            ),
          ),
        ),
      ),
    );

    // Verify that the app bar text is correct
    expect(find.text('Select Your $mockLevel-level Papers'), findsOneWidget);

    // Verify that the number of ListTiles matches the number of mock papers
    expect(find.byType(ListTile), findsNWidgets((mockCompulsoryPapers.length + 1) + (mockOneOfPapers.length + 1)));

    // Test interaction with checkboxes
    await tester.tap(find.byType(Checkbox).at(0));
    await tester.pump();

    // Test navigation back to MyHomePage when the "Save" button is tapped
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    // Verify that MyHomePage is pushed to the Navigator
    expect(find.byType(MyHomePage), findsOneWidget);
  });
}
