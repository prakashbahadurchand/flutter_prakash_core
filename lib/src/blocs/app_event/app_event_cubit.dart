import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'app_event_state.dart';
import 'app_events.dart';

/// An enterprise global event bus Cubit to dispatch cross-module signals
/// without tight coupling between distinct feature BLoCs.
@lazySingleton
class AppEventCubit extends Cubit<AppEventState?> {
  AppEventCubit() : super(null);

  /// Fires a global reactive change event across the application tree.
  void notifyChanged<E extends AppEvent>(E event) {
    emit(AppEventState(event));
  }
}

/// Convenience extension on [BuildContext] for firing app events cleanly.
///
/// ```dart
/// context.notifyAppEvent(const ProfileChangedEvent());
/// context.notifyAppEvent(ProductLikeEvent(101));
/// ```
extension AppEventContextExtension on BuildContext {
  void notifyAppEvent<E extends AppEvent>(E event) {
    read<AppEventCubit>().notifyChanged(event);
  }
}
