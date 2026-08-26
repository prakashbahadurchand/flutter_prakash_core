import 'package:flutter/cupertino.dart';

extension ValueNotifierExt<T> on ValueNotifier<T> {
  Widget listen(Widget Function(T value) builder) => ValueListenableBuilder<T>(
    valueListenable: this,
    builder: (BuildContext context, T value, Widget? child) => builder(value),
  );

  Widget listens(Widget Function(BuildContext, T, Widget?) builder) =>
      ValueListenableBuilder<T>(valueListenable: this, builder: builder);
}
