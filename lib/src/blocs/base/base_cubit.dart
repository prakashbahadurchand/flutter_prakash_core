import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'prakash_effects.dart';

/// Enterprise base Cubit with lifecycle-safe emit and one-shot side-effect stream.
///
/// ### Features:
/// - [safeEmit] — guards against `emit` after `close()` to prevent `StateError`.
/// - [emitEffect] — fires one-shot side-effects (toasts, navigation) via [effectStream].
/// - [effectStream] — consumed by [PrakashEffectListener] widget in the UI layer.
///
/// ### Usage:
/// ```dart
/// @injectable
/// class SettingsCubit extends BaseCubit<SettingsState> {
///   SettingsCubit() : super(const SettingsState());
///
///   void toggleDarkMode(bool value) {
///     safeEmit(state.copyWith(isDarkMode: value));
///     emitEffect(ShowToastEffect(value ? 'Dark mode on' : 'Dark mode off'));
///   }
/// }
/// ```
abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  final StreamController<PrakashEffect> _effectController =
      StreamController<PrakashEffect>.broadcast();

  /// Stream of one-shot side-effects consumed by [PrakashEffectListener].
  Stream<PrakashEffect> get effectStream => _effectController.stream;

  /// Lifecycle-safe emit — prevents [StateError] when cubit is already closed.
  void safeEmit(S newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  /// Fires a one-shot [PrakashEffect] to the UI layer without polluting BLoC state.
  void emitEffect(PrakashEffect effect) {
    if (!_effectController.isClosed) {
      _effectController.add(effect);
    }
  }

  @override
  Future<void> close() {
    _effectController.close();
    return super.close();
  }
}
