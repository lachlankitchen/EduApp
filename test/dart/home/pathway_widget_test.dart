import 'package:edu_app/dart/degree/degree.dart';
import 'package:edu_app/dart/home/home.dart';
import 'package:edu_app/dart/major/major.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:edu_app/dart/paper/paper.dart';
import 'package:edu_app/dart/pathway/display_pathway.dart';
import 'package:edu_app/dart/pathway/pathway.dart';
import 'package:edu_app/dart/pathway/pathway_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Import http package
import '../utils/mock_client.dart';

void main() {
  // Create mock data for degree, major, compulsory papers, and one-of papers
  final Degree mockDegree1 = Degree('Bachelor of Science');
  final Degree mockDegree2 = Degree('Bachelor of Arts');

  final List<Major> mockMajors = [
    Major.withName(name: 'Computer Science'),
    Major.withName(name: 'Oceanography'),
    Major.withName(name: 'Zoology')
  ];

  final List<Paper> mockPapers = [
    Paper.withName(
      papercode: 'CS 101',
      title: 'Introduction to Computer Science',
      teachingPeriods: ['S1', 'S2'],
    ),
    Paper.withName(
      papercode: 'CS 161',
      title: 'Computer Programming',
      teachingPeriods: ['SS', 'S2'],
    ),
    Paper.withName(
      papercode: 'CS 200',
      title: 'Advanced Computer Science',
      teachingPeriods: ['SS', 'S2'],
    )
  ];

  testWidgets('Test MyHomePage Widget', (WidgetTester tester) async {

    // Create a MockClient with the mockDegree and null for majors
    final mockClient = MockClient(degree: mockDegree1);

    // Assign the mock client to the global http client
    http.Client client = mockClient;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: const MaterialApp(
          home: MyHomePage(),
        ),
      ),
    );

    // Verify that the app bar text is correct
    expect(find.text('Plan Your Degree'), findsOneWidget);

    // Verify that the FloatingActionButton is displayed
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the FloatingActionButton
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that the snackbar is dismissed
    expect(find.text('You cannot have more than three degrees.'), findsNothing);
  });

  test('PathwayState Test', () {
    final pathwayState = PathwayState();

    pathwayState.addDegree(mockDegree1);
    pathwayState.addMajors(List.of([mockMajors[0], mockMajors[1]]));
    pathwayState.addPapers(mockPapers);
    pathwayState.addGPA(3.5);

    expect(pathwayState.selectedDegree, mockDegree1);
    expect(pathwayState.selectedMajors, List.of([mockMajors[0], mockMajors[1]]));
    expect(pathwayState.selectedPapers, mockPapers);
    expect(pathwayState.gpa, 3.5);

    pathwayState.saveState();

    final savedPathways = pathwayState.savedPathways;

    expect(savedPathways.length, 1);
    expect(savedPathways[0].degree, mockDegree1);
    expect(savedPathways[0].majors, List.of([mockMajors[0], mockMajors[1]]));
    expect(savedPathways[0].papers, mockPapers);
    expect(savedPathways[0].gpa, 3.5);
    expect(savedPathways[0].isSelected, false);

    pathwayState.deleteState(savedPathways[0]);

    expect(pathwayState.savedPathways.length, 0);
  });

  testWidgets('Test DisplayPathway Widget', (WidgetTester tester) async {

    // Create a list of mock Pathway objects
    final mockPathways = [
      Pathway(
        degree: mockDegree1,
        majors: List.of([mockMajors[0]]),
        papers: mockPapers,
        gpa: 3.5,
        isSelected: false,
      ),
      Pathway(
        degree: mockDegree2,
        majors: List.of([mockMajors[1], mockMajors[2]]),
        papers: mockPapers,
        gpa: 7.8,
        isSelected: false,
      ),
    ];

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: DisplayPathway(
          pathway: mockPathways,
        ),
      ),
    );

    // Verify that the degree titles are displayed correctly
    expect(find.text('Bachelor of Science'), findsOneWidget);
    expect(find.text('Bachelor of Arts'), findsOneWidget);

    // Verify that the major names are displayed correctly
    expect(find.text('  Computer Science, '), findsOneWidget);
    expect(find.text('  Oceanography, '), findsOneWidget);
    expect(find.text('  Zoology, '), findsOneWidget);


    // Verify that the paper names are displayed correctly
    expect(find.text('  CS 101 - Introduction to Computer Science, '), findsNWidgets(2));

    // TODO: Fix GPA text test
    // Verify that the GPA is displayed correctly 
    // expect(find.text('  3.5'), findsOneWidget);
    // expect(find.text('  7.8'), findsOneWidget);
  });
}
