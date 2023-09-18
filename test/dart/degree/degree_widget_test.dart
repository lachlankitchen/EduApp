import 'package:edu_app/dart/degree/degree.dart';
import 'package:edu_app/dart/degree/degree_list.dart';
import 'package:edu_app/dart/major/major_list.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:edu_app/dart/pathway/pathway_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Import http package
import '../utils/mock_client.dart';

void main() {
  testWidgets('Test DegreeListScreen Widget', (WidgetTester tester) async {
    final List<Degree> mockDegrees = [
      Degree('Bachelor of Science'),
      Degree('Bachelor of Arts'),
      Degree('Bachelor of Engineering'),    
    ];

    // Create a MockClient to intercept and mock HTTP requests
    final mockClient = MockClient(degree: mockDegrees[0]);

    // Assign the mock client to the global http client
    http.Client client = mockClient;

    Degree? selectedDegree;

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: MaterialApp(
          home: Builder(
            builder: (context) => DegreeListScreen(
              degrees: mockDegrees,
              onSelectDegree: (degree) {
                selectedDegree = degree;
              },
            ),
          ),
        ),
      ),
    );

    // Verify that the app bar text is correct
    expect(find.text('Select a Degree'), findsOneWidget);

    // Verify that the correct number of ElevatedButtons are displayed
    expect(find.byType(ElevatedButton), findsNWidgets(mockDegrees.length));

    // Tap the first ElevatedButton
    await tester.tap(find.byType(ElevatedButton).first);
    await tester.pumpAndSettle();

    // Verify that the selected degree is correct
    expect(selectedDegree, mockDegrees.first);

    // // Verify that the MajorListScreen is pushed to the navigator
    // expect(find.byType(MajorListScreen), findsOneWidget);
  });
}