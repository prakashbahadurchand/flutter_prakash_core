import 'package:flutter/material.dart';

extension NullableWidget<T> on T? {
  Widget? nullOr(Widget Function(T) widgetBuilder) {
    final value = this;
    if (value == null) {
      return null;
    }
    return widgetBuilder(value);
  }
}

extension NullExtension<T> on T? {
  bool get isNull => this == null;
}
