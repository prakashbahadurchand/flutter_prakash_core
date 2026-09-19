import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admin/admin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveGrid & 12-Col Grid Tests', () {
    test(
      'ResponsiveGridCol computes span correctly for various screen widths',
      () {
        const col = ResponsiveGridCol(sm: 6, md: 4, lg: 3, child: SizedBox());

        const config = AdminThemeConfig.defaultConfig();

        // Mobile (< 600)
        expect(col.getSpanForWidth(500, config), 12);
        // Tablet (600 - 1024)
        expect(col.getSpanForWidth(800, config), 6);
        // Desktop (1024 - 1440)
        expect(col.getSpanForWidth(1200, config), 4);
        // Ultra-wide (> 1440)
        expect(col.getSpanForWidth(1600, config), 3);
      },
    );

    testWidgets('ResponsiveGridRow renders all column children', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ResponsiveGridRow(
              children: [
                ResponsiveGridCol(md: 6, child: Text('Col 1')),
                ResponsiveGridCol(md: 6, child: Text('Col 2')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Col 1'), findsOneWidget);
      expect(find.text('Col 2'), findsOneWidget);
    });
  });
}
