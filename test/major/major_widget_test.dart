import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:edu_app/dart/major/major.dart';
import 'package:edu_app/dart/major/major_list.dart';
import 'package:edu_app/dart/paper/paper_list.dart'; // Import the PapersListScreen class
import 'package:edu_app/dart/pathway/pathway_state.dart';

void main() {
  testWidgets('Test MajorListScreen Widget', (WidgetTester tester) async {
    final List<Major> mockMajors = [
      Major(name: 'Computer Science', requirements: [], totalPoints: 0, isSelected: false),
      Major(name: 'Psychology', requirements: [], totalPoints: 0, isSelected: false),
    ];

    final PathwayState mockPathwayState = PathwayState(); // You can customize the mock state as needed

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => MajorListScreen(
              majors: mockMajors,
            ),
          ),
        ),
      ),
    );

    // Verify that the app bar text is correct
    expect(find.text('Select Your Majors'), findsOneWidget);

    // Verify that the number of ListTiles matches the number of mock majors
    expect(find.byType(ListTile), findsNWidgets(mockMajors.length));

    // Test navigation to PapersListScreen when checkbox is selected
    await tester.tap(find.byType(Checkbox).at(0));
    await tester.pumpAndSettle();

    // Verify that PapersListScreen is pushed to the Navigator
    expect(find.byType(PapersListScreen), findsOneWidget);
  });
}
