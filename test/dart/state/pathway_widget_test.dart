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
      grade: 75
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
      grade: 100
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
      grade: 50
    ),
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

    // Verify that the MyHomePage widget has been rendered.
    expect(find.byType(MyHomePage), findsOneWidget);

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

  test('Test Pathway Addition and Deletion Test', () {
    final pathwayState = PathwayState();

    pathwayState.addDegree(mockDegree1);
    pathwayState.addMajors(List.of([mockMajors[0], mockMajors[1]]));
    pathwayState.addPapers(mockPapers);

    expect(pathwayState.selectedDegree, mockDegree1);
    expect(pathwayState.selectedMajors, List.of([mockMajors[0], mockMajors[1]]));
    expect(pathwayState.selectedPapers, mockPapers);

    pathwayState.savePathway();

    final savedPathways = pathwayState.savedPathways;

    expect(savedPathways.length, 1);
    expect(savedPathways[0].degree, mockDegree1);
    expect(savedPathways[0].majors, List.of([mockMajors[0], mockMajors[1]]));
    expect(savedPathways[0].papers, mockPapers);

    pathwayState.deleteState(savedPathways[0]);

    expect(pathwayState.savedPathways.length, 0);
  });

  testWidgets('Test MyHomePage Widget', (WidgetTester tester) async {

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
    expect(find.text('  COMP161 - Computer Programming, '), findsNWidgets(2));
    expect(find.text('  COSC201 - Algorithms and Data Structures, '), findsNWidgets(2));
    expect(find.text('  COSC326 - Computational Problem Solving, '), findsNWidgets(2));

    // TODO: Fix GPA text test
    // Verify that the GPA is displayed correctly 
    expect(find.text('  3.5'), findsOneWidget);
    expect(find.text('  7.8'), findsOneWidget);
  });
}
