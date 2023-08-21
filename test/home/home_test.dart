import 'package:edu_app/dart/home/home.dart';
import 'package:edu_app/dart/navigation/navigation_provider.dart';
import 'package:edu_app/dart/pathway/pathway_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';


void main() {
  testWidgets('Test MyHomePage Widget', (WidgetTester tester) async {
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
}
