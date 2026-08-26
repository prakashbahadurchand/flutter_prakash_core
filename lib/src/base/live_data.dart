import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Using: `LiveData<T>` instead of `setState({});`
/// for better performance in `StatefulWidget`.
///
///```dart
///
/// :: Define
/// final LiveData<String> _message = LiveData<String>('Hello');
///
/// :: Listen & Build (context, value, widget)
/// _message.listens((c, v, w) =>
///     Text('Message: $v', style: const TextStyle(fontSize: 24)));
/// OR
/// _message.listen((v) =>
///     Text('Message: $v', style: const TextStyle(fontSize: 24)));
///
/// :: Update
/// _message.value = "Hello World!";
///
/// :: Dispose
/// _message.dispose();
///
///```
///

class LiveData<T> implements ValueListenable<T> {
  final ValueNotifier<T> _notifier;

  LiveData(T initialValue) : _notifier = ValueNotifier<T>(initialValue);

  @override
  T get value => _notifier.value;

  set value(T newValue) => _notifier.value = newValue;

  @override
  void addListener(VoidCallback listener) => _notifier.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _notifier.removeListener(listener);

  void observe(VoidCallback listener) => _notifier.addListener(listener);

  void removeObserver(VoidCallback listener) =>
      _notifier.removeListener(listener);

  void dispose() => _notifier.dispose();

  Widget listen(Widget Function(T value) builder) => ValueListenableBuilder<T>(
    valueListenable: _notifier,
    builder: (BuildContext context, T value, Widget? child) => builder(value),
  );

  Widget listens(Widget Function(BuildContext, T, Widget?) builder) =>
      ValueListenableBuilder<T>(valueListenable: _notifier, builder: builder);
}

// Live Data for Flutter HookWidget:

/*LiveData<T> useLiveData<T>(T initialValue) {
  return use(_LiveDataHook(initialValue));
}

class _LiveDataHook<T> extends Hook<LiveData<T>> {
  final T initialValue;

  const _LiveDataHook(this.initialValue);

  @override
  _LiveDataHookState<T> createState() => _LiveDataHookState<T>();
}

class _LiveDataHookState<T> extends HookState<LiveData<T>, _LiveDataHook<T>> {
  late LiveData<T> _liveData;

  @override
  void initHook() {
    super.initHook();
    _liveData = LiveData<T>(hook.initialValue);
  }

  @override
  LiveData<T> build(BuildContext context) {
    return _liveData;
  }

  @override
  void dispose() {
    _liveData.dispose();
    super.dispose();
  }
}*/
