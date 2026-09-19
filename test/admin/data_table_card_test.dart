import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admin/admin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DataTableCard Widget Tests', () {
    testWidgets(
      'renders title, search input triggers callback, and displays child table',
      (tester) async {
        String searchVal = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DataTableCard(
                title: 'Clients',
                onSearchChanged: (val) => searchVal = val,
                child: const Text('Table Content Placeholder'),
              ),
            ),
          ),
        );

        expect(find.text('Clients'), findsOneWidget);
        expect(find.text('Table Content Placeholder'), findsOneWidget);

        await tester.enterText(find.byType(TextField), 'John');
        expect(searchVal, 'John');
      },
    );

    testWidgets('renders empty state when isEmpty is true', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DataTableCard(
              title: 'Clients',
              isEmpty: true,
              emptyMessage: 'No clients found',
              child: Text('Table Content Placeholder'),
            ),
          ),
        ),
      );

      expect(find.text('No clients found'), findsOneWidget);
      expect(find.text('Table Content Placeholder'), findsNothing);
    });

    testWidgets('renders error state when errorMessage is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DataTableCard(
              title: 'Clients',
              errorMessage: 'Failed to fetch clients from server',
              child: Text('Table Content Placeholder'),
            ),
          ),
        ),
      );

      expect(find.text('Failed to fetch clients from server'), findsOneWidget);
      expect(find.text('Table Content Placeholder'), findsNothing);
    });
  });
}
