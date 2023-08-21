import 'package:edu_app/dart/pathway/pathway_state.dart';
import 'package:edu_app/dart/points/degree_points_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:edu_app/dart/navigation/nav_bar.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:edu_app/dart/grade/grade.dart'; // Import the GradesScreen class
import 'package:edu_app/dart/home/home.dart'; // Import the MyHomePage class

void main() {
  testWidgets('Test NavBar Widget', (WidgetTester tester) async {
    final navigationProvider = NavigationProvider(); // Create a mock NavigationProvider

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => NavigationProvider()),
          ChangeNotifierProvider(create: (context) => PathwayState()),
        ],
        child: const MaterialApp(
          home: NavBar(),
        ),
      ),
    );

    // Verify the presence of the BottomNavigationBar
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Test navigation behavior by tapping each item
    await tester.tap(find.byIcon(Icons.list));
    await tester.pumpAndSettle();
    expect(find.byType(MyHomePage), findsOneWidget);

    await tester.tap(find.byIcon(Icons.book));
    await tester.pumpAndSettle();
    expect(find.byType(GradesScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.pie_chart));
    await tester.pumpAndSettle();
    expect(find.byType(DegreesPointsScreen), findsOneWidget);
  });
}
