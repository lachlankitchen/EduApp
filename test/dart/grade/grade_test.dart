import 'package:edu_app/dart/grade/grade.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('GradesScreen Widget Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: GradesScreen(),
    ));

    // Verify that the initial average is displayed correctly.
    expect(find.text('Average: 0.0'), findsOneWidget);

    // Enter values in the text fields.
    await tester.enterText(find.byKey(const Key('TitleField')), 'Assignment 1');
    await tester.enterText(find.byKey(const Key('ScoreField')), '85');
    await tester.enterText(find.byKey(const Key('WeightField')), '20');

    // Tap the Add button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the average has been updated.
    expect(find.text('Average: 85.0'), findsOneWidget);

    // Verify that the added grade entry is displayed in the list view.
    expect(find.text('Assignment 1'), findsOneWidget);
    expect(find.text('Score: 85.00, Weight: 20.00%'), findsOneWidget);

        // Enter values in the text fields.
    await tester.enterText(find.byKey(const Key('TitleField')), 'Final Exam');
    await tester.enterText(find.byKey(const Key('ScoreField')), '60');
    await tester.enterText(find.byKey(const Key('WeightField')), '50');

    // Tap the Add button.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the average has been updated.
    expect(find.text('Average: 67.1'), findsOneWidget);

    // Verify that the added grade entry is displayed in the list view.
    expect(find.text('Final Exam'), findsOneWidget);
    expect(find.text('Score: 60.00, Weight: 50.00%'), findsOneWidget);
  });
}
