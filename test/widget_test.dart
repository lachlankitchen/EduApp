// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edu_app/main.dart';
import 'package:edu_app/dart/form/degrees_list_screen.dart';


void main() {
  testWidgets('Renders MyApp and opens DegreesListScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: MyHomePage(title: 'Degree Pathway App'),
    ));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.byType(DegreesListScreen), findsOneWidget);
  });
}
