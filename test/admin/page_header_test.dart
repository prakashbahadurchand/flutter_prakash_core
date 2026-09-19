import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admin/admin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PageHeader Widget Tests', () {
    testWidgets('renders title, subtitle, breadcrumbs, and actions', (
      tester,
    ) async {
      bool actionTapped = false;
      bool breadcrumbTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageHeader(
              title: 'Orders Management',
              subtitle: 'View and track all client orders',
              breadcrumbs: [
                AdminBreadcrumbItem(
                  label: 'Home',
                  onTap: () => breadcrumbTapped = true,
                ),
                const AdminBreadcrumbItem(label: 'Orders'),
              ],
              actions: [
                ElevatedButton(
                  onPressed: () => actionTapped = true,
                  child: const Text('Export CSV'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Orders Management'), findsOneWidget);
      expect(find.text('View and track all client orders'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Export CSV'), findsOneWidget);

      await tester.tap(find.text('Export CSV'));
      expect(actionTapped, isTrue);

      await tester.tap(find.text('Home'));
      expect(breadcrumbTapped, isTrue);
    });
  });
}
