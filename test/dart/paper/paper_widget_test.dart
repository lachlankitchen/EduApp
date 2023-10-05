import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:edu_app/dart/paper/paper_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:edu_app/dart/paper/paper.dart';
import 'package:edu_app/dart/pathway/pathway_state.dart';
import 'package:edu_app/dart/navigation/nav_bar.dart';
import 'package:edu_app/dart/major/major.dart';
import 'package:edu_app/dart/degree/degree.dart';
import 'package:edu_app/dart/paper/paper_utils.dart'; // Import fetchPaperData
import '../utils/mock_client.dart'; // Import your mock client

void main() {
  testWidgets('Test PapersListScreen Widget', (WidgetTester tester) async {
    // Create mock data for degree, major, compulsory papers, and one-of papers
    final Degree mockDegree = Degree('Bachelor of Science');
    final Major mockMajor = Major.withName(name: 'Computer Science');
    final List<Paper> mockCompulsoryPapers = [
      Paper.withName(
        papercode: 'COMP161',
        title: 'Computer and Information Science',
        teachingPeriods: ['S1', 'S2'],
        points: 18
      ),
    ];
    final List<Paper> mockOneOfPapers = [
      Paper.withName(
        papercode: 'COSC201',
        title: 'Algorithms and Data Structures',
        teachingPeriods: ['SS', 'S2'],
        points: 18
      )
    ];

    // Create a MockClient to intercept and mock HTTP requests
    final mockClient = MockClient(degree: mockDegree, major: mockMajor);

    // Assign the mock client to the global http client
    http.Client client = mockClient;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: MaterialApp(
          home: PapersListScreen(
            degree: mockDegree,
            major: mockMajor,
            compulsoryPapers: mockCompulsoryPapers,
            oneOfPapers: mockOneOfPapers,
            level: 100,
          ),
        ),
      ),
    );

    // Verify that the app bar text is correct
    expect(find.text('Select Your 100-level Papers'), findsOneWidget);

    // Verify that the checkboxes for papers are displayed
    expect(find.byType(Checkbox), findsNWidgets(mockCompulsoryPapers.length + mockOneOfPapers.length));

    // Tap the first checkbox to select the first paper
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    // Verify that the selected paper is updated
    expect(mockCompulsoryPapers.first.isSelected, true);

    // Verify that the ListTile for the selected paper is displayed
    expect(find.text('COMP161 - Computer and Information Science'), findsOneWidget);

    // Tap the save button
    await tester.tap(find.text('Save'));
    await tester.pump();

    // // Verify the app navigates to the next PapersListScreen with updated data (you can add more specific verification here)
    // expect(find.text('Select Your 200-level Papers'), findsOneWidget);
  });
}
