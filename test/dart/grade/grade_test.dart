import 'package:edu_app/dart/grade/grade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'grades.dart'; // Import your GradesScreen widget here

void main() {
  testWidgets('GradesScreen Widget Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: GradesScreen(),
    ));

    // Verify that the initial average is displayed correctly.
    expect(find.text('Average: 0.0'), findsOneWidget);

    // Enter values in the text fields.
    await tester.enterText(find.byLabelText('Title'), 'Assignment 2');
    await tester.enterText(find.byLabelText('Score (0-100)'), '85');
    await tester.enterText(find.byLabelText('Weight (%)'), '20');

    // Tap the Add button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the average has been updated.
    expect(find.text('Average: 17.0'), findsOneWidget);

    // Verify that the added grade entry is displayed in the list view.
    expect(find.text('Assignment 2'), findsOneWidget);
    expect(find.text('Score: 85.00, Weight: 20.00%'), findsOneWidget);
  });
}
