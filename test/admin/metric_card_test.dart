import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admin/admin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MetricCard Widget Tests', () {
    testWidgets('renders title, value, change, and badge correctly', (
      tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MetricCard(
              title: 'Revenue',
              value: r'$50,000',
              change: '+15%',
              trend: TrendDirection.up,
              subLabel: 'vs last week',
              badgeText: 'Live',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text(r'$50,000'), findsOneWidget);
      expect(find.text('+15%'), findsOneWidget);
      expect(find.text('vs last week'), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);

      await tester.tap(find.byType(MetricCard));
      expect(tapped, isTrue);
    });

    testWidgets('renders skeleton state when isLoading is true', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: MetricCard(
              title: 'Revenue',
              value: r'$50,000',
              isLoading: true,
            ),
          ),
        ),
      );

      // Title & Value text should not be visible when skeleton placeholder is rendered
      expect(find.text('Revenue'), findsNothing);
      expect(find.text(r'$50,000'), findsNothing);
    });
  });
}
