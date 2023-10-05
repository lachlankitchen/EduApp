import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:edu_app/dart/major/major_list.dart'; // Import the MajorListScreen class
import 'package:edu_app/dart/major/major.dart'; // Import the Major class
import 'package:edu_app/dart/degree/degree.dart'; // Import the Degree class
import 'package:edu_app/dart/pathway/pathway_state.dart'; // Import the PathwayState class
import '../utils/mock_client.dart'; // Import your mock client

void main() {
  testWidgets('Test MajorListScreen Widget', (WidgetTester tester) async {
    // Create mock data for degree and majors
    final Degree mockDegree = Degree('Bachelor of Science');
    final List<Major> mockMajors = [
      Major.withName(name: 'Computer Science'),
      Major.withName(name: 'Mathematics'),
      Major.withName(name: 'Physics'),
    ];

    // Create a MockClient to intercept and mock HTTP requests
    final mockClient = MockClient(degree: mockDegree, majors: mockMajors);

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
          home: MajorListScreen(
            degree: mockDegree,
            majors: mockMajors,
          ),
        ),
      ),
    );

    // Verify that the app bar text is correct
    expect(find.text('Select Your Majors'), findsOneWidget);

    // Verify that the checkboxes for majors are displayed
    expect(find.byType(Checkbox), findsNWidgets(mockMajors.length));

    // Tap the first checkbox to select the major
    await tester.tap(find.byType(Checkbox).first);
    await tester.pump();

    // Verify that the selected major is updated
    expect(mockMajors.first.isSelected, true);

    // Verify that the ListTile for the selected major is displayed
    expect(find.text('Computer Science'), findsOneWidget);
  });
}
