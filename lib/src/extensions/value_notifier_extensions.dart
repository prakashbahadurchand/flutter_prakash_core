import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

extension ValueListenableExt<T> on ValueListenable<T> {
  Widget listen(Widget Function(T value) builder) => ValueListenableBuilder<T>(
    valueListenable: this,
    builder: (BuildContext context, T value, Widget? child) => builder(value),
  );

  Widget listens(
    Widget Function(BuildContext context, T value, Widget? child) builder,
  ) => ValueListenableBuilder<T>(valueListenable: this, builder: builder);
}
