import 'package:edu_app/dart/navigation/nav_bar.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('NavBar widget test', (WidgetTester tester) async {
    // Create a mock NavigationProvider
    final navigationProvider = NavigationProvider();

    // Build the widget tree with the NavBar widget wrapped in the MultiProvider
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: navigationProvider),
        ],
        child: const MaterialApp(
          home: Scaffold(
            bottomNavigationBar: NavBar(),
          ),
        ),
      ),
    );

    expect(navigationProvider.currentIndex, 0);

    // Verify that the initial index of the NavBar is 0
    expect(find.text('My Pathway'), findsOneWidget);
    
    // Tap on the second item (Grades)
    await tester.tap(find.byIcon(Icons.book));
    await tester.pump();

    expect(find.text('Grades'), findsOneWidget);

    // Tap on the third item (Points)
    await tester.tap(find.byIcon(Icons.pie_chart));
    await tester.pump();

    expect(find.text('Points'), findsOneWidget);

    // Tap on the first item (Points)
    await tester.tap(find.byIcon(Icons.list));
    await tester.pump();

    expect(navigationProvider.currentIndex, 1);

  });
}
