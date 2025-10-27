// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:practica4/main.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GuessWhoApp());

    // Verify that the app title appears
    expect(find.text('¿QUIÉN ES?'), findsOneWidget);
    expect(find.text('Attack on Titan Edition'), findsOneWidget);

    // Verify that game mode buttons exist
    expect(find.text('Un Jugador'), findsOneWidget);
    expect(find.text('Dos Jugadores'), findsOneWidget);
  });
}
