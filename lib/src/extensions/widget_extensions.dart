import 'package:flutter/material.dart';

extension NullableWidget<T> on T? {
  Widget? nullOr(Widget Function(T) widgetBuilder) {
    if (this == null) {
      return null;
    }
    return widgetBuilder(this!);
  }
}

extension NullExtension<T> on T? {
  bool get isNull => this == null;
}
