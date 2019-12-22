// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:randomize/Pages/Randomizer.dart';

import 'package:randomize/main.dart';

void main() {
  testWidgets('Test TheRandomizerApp Composition', (WidgetTester tester) async {
    // Build app and trigger a frame.
    await tester.pumpWidget(TheRandomizerApp());

    //Verify that the app is composed with a RandomizerHomePage is present
    final myCustomTextFieldFinder = find.byType(RandomizerHomePage);
    expect(myCustomTextFieldFinder, findsOneWidget);
  });

  testWidgets('Test RandomizerHomePage composition',
      (WidgetTester tester) async {
    //Build home page and trigger a frame
    await tester.pumpWidget(
      MaterialApp(
        home: RandomizerHomePage(),
      ),
    );

    //Verify that the homepage contain a scaffold
    final randomizerHomePageFinder = find.byType(Scaffold);
    expect(randomizerHomePageFinder, findsOneWidget);

    final titleFinder = find.text("The Randomizer");
    expect(titleFinder, findsOneWidget);
  });
}
