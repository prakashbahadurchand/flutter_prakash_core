import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'fp_effects.dart';

/// Enterprise base Cubit with lifecycle-safe emit and one-shot side-effect stream.
///
/// ### Features:
/// - [safeEmit] — guards against `emit` after `close()` to prevent `StateError`.
/// - [emitEffect] — fires one-shot side-effects (toasts, navigation) via [effectStream].
/// - [effectStream] — consumed by [FpEffectListener] widget in the UI layer.
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

  final StreamController<FpEffect> _effectController =
      StreamController<FpEffect>.broadcast();

  /// Stream of one-shot side-effects consumed by [FpEffectListener].
  Stream<FpEffect> get effectStream => _effectController.stream;

  /// Lifecycle-safe emit — prevents [StateError] when cubit is already closed.
  void safeEmit(S newState) {
    if (!isClosed) {
      emit(newState);
    }
  }

  /// Fires a one-shot [FpEffect] to the UI layer without polluting BLoC state.
  void emitEffect(FpEffect effect) {
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
