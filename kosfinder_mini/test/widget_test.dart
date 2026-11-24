import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kosfinder_mini/main.dart';

void main() {
  testWidgets('shows the six sample kos listings', (WidgetTester tester) async {
    await tester.pumpWidget(const KosFinderApp());

    expect(KosListPage.kosList, hasLength(6));
    expect(find.text('KosFinder Mini'), findsOneWidget);
    expect(find.text('Kos Melati'), findsOneWidget);
  });

  testWidgets('searches names without case sensitivity', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosFinderApp());

    await tester.enterText(find.byType(TextField), 'pOnDoK');
    await tester.pump();

    expect(find.text('Pondok Asri'), findsOneWidget);
    expect(find.text('Kos Melati'), findsNothing);
  });

  testWidgets('shows an empty state when no listing matches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosFinderApp());

    await tester.enterText(find.byType(TextField), 'tidak ada kos');
    await tester.pump();

    expect(find.text('Kos tidak ditemukan.'), findsOneWidget);
  });

  testWidgets('clears the search and restores the listings', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KosFinderApp());
    await tester.enterText(find.byType(TextField), 'Pondok');
    await tester.pump();

    await tester.tap(find.byTooltip('Hapus pencarian'));
    await tester.pump();

    final searchField = tester.widget<TextField>(find.byType(TextField));
    expect(searchField.controller!.text, isEmpty);
    expect(find.text('Kos Melati'), findsOneWidget);
  });

  testWidgets('toggles a listing as a favorite', (WidgetTester tester) async {
    await tester.pumpWidget(const KosFinderApp());
    await tester.enterText(find.byType(TextField), 'Kos Melati');
    await tester.pump();

    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pump();
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
  });
}
