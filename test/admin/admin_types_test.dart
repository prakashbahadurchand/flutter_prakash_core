import 'package:flutter/material.dart';
import 'package:flutter_prakash_core/src/admin/admin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminNavItem Tests', () {
    test('default properties and id fallback to label', () {
      const item = AdminNavItem(label: 'Dashboard', icon: Icons.dashboard);

      expect(item.id, 'Dashboard');
      expect(item.label, 'Dashboard');
      expect(item.icon, Icons.dashboard);
      expect(item.hasChildren, isFalse);
      expect(item.isDivider, isFalse);
      expect(item.isHeader, isFalse);
    });

    test('custom id is preserved', () {
      const item = AdminNavItem(
        id: 'custom-id',
        label: 'Dashboard',
        icon: Icons.dashboard,
      );

      expect(item.id, 'custom-id');
    });

    test('divider constructor sets isDivider to true', () {
      const divider = AdminNavItem.divider();
      expect(divider.isDivider, isTrue);
      expect(divider.isHeader, isFalse);
      expect(divider.id, 'divider');
    });

    test('header constructor sets isHeader to true', () {
      const header = AdminNavItem.header(label: 'Management');
      expect(header.isHeader, isTrue);
      expect(header.isDivider, isFalse);
      expect(header.id, 'Management');
    });

    test('role-based access control evaluation', () {
      const openItem = AdminNavItem(label: 'Public', icon: Icons.public);
      expect(openItem.isVisibleForRoles(null), isTrue);
      expect(openItem.isVisibleForRoles([]), isTrue);
      expect(openItem.isVisibleForRoles(['viewer']), isTrue);

      const restrictedItem = AdminNavItem(
        label: 'Settings',
        icon: Icons.settings,
        roles: ['admin', 'superadmin'],
      );

      expect(restrictedItem.isVisibleForRoles(null), isFalse);
      expect(restrictedItem.isVisibleForRoles([]), isFalse);
      expect(restrictedItem.isVisibleForRoles(['viewer']), isFalse);
      expect(restrictedItem.isVisibleForRoles(['editor', 'admin']), isTrue);
    });

    test('nested children presence', () {
      const parent = AdminNavItem(
        label: 'Reports',
        icon: Icons.bar_chart,
        children: [
          AdminNavItem(label: 'Sales', icon: Icons.attach_money),
          AdminNavItem(label: 'Traffic', icon: Icons.traffic),
        ],
      );

      expect(parent.hasChildren, isTrue);
      expect(parent.children.length, 2);
    });

    test('copyWith works correctly', () {
      const item = AdminNavItem(id: '1', label: 'Users', icon: Icons.people);

      final updated = item.copyWith(label: 'All Users', badgeText: '5');
      expect(updated.id, '1');
      expect(updated.label, 'All Users');
      expect(updated.badgeText, '5');
    });
  });
}
