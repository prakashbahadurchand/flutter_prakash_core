import 'dart:async';
import 'package:flutter/material.dart';

/// Base class for all side-effects emitted by [BaseCubit].
///
/// Side-effects are one-shot signals (toasts, navigation, dialogs) that
/// should NOT be part of the BLoC state tree — they fire once and are consumed.
abstract class PrakashEffect {
  const PrakashEffect();
}

/// Emits a toast/snackbar message to the UI layer.
///
/// ```dart
/// emitEffect(const ShowToastEffect('Item saved successfully!'));
/// ```
class ShowToastEffect extends PrakashEffect {
  final String message;
  const ShowToastEffect(this.message);

  @override
  String toString() => 'ShowToastEffect($message)';
}

/// Emits a navigation signal to the UI layer.
class NavigateEffect extends PrakashEffect {
  final String route;
  final Object? arguments;
  const NavigateEffect(this.route, {this.arguments});

  @override
  String toString() => 'NavigateEffect($route)';
}

/// Emits a dialog show signal to the UI layer.
class ShowDialogEffect extends PrakashEffect {
  final String title;
  final String message;
  const ShowDialogEffect({required this.title, required this.message});

  @override
  String toString() => 'ShowDialogEffect($title: $message)';
}

/// Callback signature for handling [PrakashEffect] instances.
typedef EffectHandler =
    void Function(BuildContext context, PrakashEffect effect);

/// A widget that listens to the `effectStream` of a [BaseCubit] and fires
/// one-shot side-effects (toasts, navigation, dialogs) without polluting BLoC state.
///
/// ### Usage:
/// ```dart
/// PrakashEffectListener(
///   cubit: myCubit,
///   onEffect: (context, effect) => switch (effect) {
///     ShowToastEffect(:final message) => showToast(message),
///     NavigateEffect(:final route) => navigate(route),
///     _ => null,
///   },
///   child: const MyView(),
/// )
/// ```
///
/// ### Default Toast Handler:
/// ```dart
/// PrakashEffectListener.fromCubit(
///   cubit: myCubit,
///   child: const MyView(),
/// )
/// ```
class PrakashEffectListener extends StatefulWidget {
  /// The cubit whose `effectStream` to listen to.
  /// Must expose a `Stream<PrakashEffect> get effectStream`.
  final dynamic cubit;

  /// Custom effect handler. If null, uses default toast handling.
  final EffectHandler? onEffect;

  /// The child widget.
  final Widget child;

  const PrakashEffectListener({
    super.key,
    required this.cubit,
    this.onEffect,
    required this.child,
  });

  /// Factory constructor that provides default [ShowToastEffect] handling
  /// via [ScaffoldMessenger].
  factory PrakashEffectListener.fromCubit({
    Key? key,
    required dynamic cubit,
    EffectHandler? onEffect,
    required Widget child,
  }) {
    return PrakashEffectListener(
      key: key,
      cubit: cubit,
      onEffect: onEffect,
      child: child,
    );
  }

  @override
  State<PrakashEffectListener> createState() => _PrakashEffectListenerState();
}

class _PrakashEffectListenerState extends State<PrakashEffectListener> {
  StreamSubscription<PrakashEffect>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant PrakashEffectListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cubit != widget.cubit) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    final cubit = widget.cubit;
    if (cubit != null) {
      // Access effectStream dynamically — BaseCubit/BaseBloc exposes it
      try {
        final Stream<PrakashEffect>? stream = (cubit as dynamic).effectStream;
        if (stream != null) {
          _subscription = stream.listen(_handleEffect);
        }
      } catch (_) {
        // Silently ignore if cubit does not expose effectStream
      }
    }
  }

  void _handleEffect(PrakashEffect effect) {
    if (!mounted) return;

    if (widget.onEffect != null) {
      widget.onEffect!(context, effect);
      return;
    }

    // Default handling for common effect types
    switch (effect) {
      case ShowToastEffect(:final message):
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
      case NavigateEffect(:final route, :final arguments):
        Navigator.of(context).pushNamed(route, arguments: arguments);
      default:
        break;
    }
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
