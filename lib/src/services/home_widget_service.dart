import 'dart:convert';

import 'package:home_widget/home_widget.dart';

/// Bridge for updating iOS WidgetKit and Android home-screen widgets.
class HomeWidgetService {
  const HomeWidgetService._();

  /// Stream of taps initiated on a home-screen widget.
  static Stream<Uri?> get widgetClicks => HomeWidget.widgetClicked;

  /// Updates the shared widget payload that the widget extension reads.
  static Future<void> updateData(
    Map<String, dynamic> data, {
    String androidName = 'PrakashWidgetProvider',
    String? iOSName,
  }) async {
    try {
      await HomeWidget.saveWidgetData('payload', jsonEncode(data));
      await HomeWidget.updateWidget(androidName: androidName, iOSName: iOSName);
    } catch (_) {
      // Widget updates are best-effort; failures are silently ignored.
    }
  }

  /// Reads the current shared payload (decoded from JSON).
  static Future<Map<String, dynamic>?> readData() async {
    final raw = await HomeWidget.getWidgetData<String>('payload');
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
