import 'dart:async';
import 'package:flutter/material.dart';

/// Base class for all side-effects emitted by [BaseCubit].
///
/// Side-effects are one-shot signals (toasts, navigation, dialogs) that
/// should NOT be part of the BLoC state tree — they fire once and are consumed.
abstract class FpEffect {
  const FpEffect();
}

/// Emits a toast/snackbar message to the UI layer.
///
/// ```dart
/// emitEffect(const ShowToastEffect('Item saved successfully!'));
/// ```
class ShowToastEffect extends FpEffect {
  final String message;
  const ShowToastEffect(this.message);

  @override
  String toString() => 'ShowToastEffect($message)';
}

/// Emits a navigation signal to the UI layer.
class NavigateEffect extends FpEffect {
  final String route;
  final Object? arguments;
  const NavigateEffect(this.route, {this.arguments});

  @override
  String toString() => 'NavigateEffect($route)';
}

/// Emits a dialog show signal to the UI layer.
class ShowDialogEffect extends FpEffect {
  final String title;
  final String message;
  const ShowDialogEffect({required this.title, required this.message});

  @override
  String toString() => 'ShowDialogEffect($title: $message)';
}

/// Interface for components (such as [BaseCubit] and [BaseBloc]) that emit one-shot [FpEffect] instances.
abstract interface class FpEffectEmitter {
  /// Stream of one-shot side-effects consumed by [FpEffectListener].
  Stream<FpEffect> get effectStream;
}

/// Callback signature for handling [FpEffect] instances.
typedef EffectHandler =
    void Function(BuildContext context, FpEffect effect);

/// A widget that listens to the `effectStream` of a [BaseCubit] or [BaseBloc] and fires
/// one-shot side-effects (toasts, navigation, dialogs) without polluting BLoC state.
///
/// ### Usage:
/// ```dart
/// FpEffectListener(
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
/// FpEffectListener.fromCubit(
///   cubit: myCubit,
///   child: const MyView(),
/// )
/// ```
class FpEffectListener extends StatefulWidget {
  /// The cubit or bloc whose `effectStream` to listen to.
  /// Can be any [FpEffectEmitter] or dynamic object exposing a `Stream<FpEffect> get effectStream`.
  final dynamic cubit;

  /// Custom effect handler. If null, uses default toast handling.
  final EffectHandler? onEffect;

  /// The child widget.
  final Widget child;

  const FpEffectListener({
    super.key,
    required this.cubit,
    this.onEffect,
    required this.child,
  });

  /// Factory constructor that provides default [ShowToastEffect] handling
  /// via [ScaffoldMessenger].
  factory FpEffectListener.fromCubit({
    Key? key,
    required dynamic cubit,
    EffectHandler? onEffect,
    required Widget child,
  }) {
    return FpEffectListener(
      key: key,
      cubit: cubit,
      onEffect: onEffect,
      child: child,
    );
  }

  @override
  State<FpEffectListener> createState() => _FpEffectListenerState();
}

class _FpEffectListenerState extends State<FpEffectListener> {
  StreamSubscription<FpEffect>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  @override
  void didUpdateWidget(covariant FpEffectListener oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cubit != widget.cubit) {
      _unsubscribe();
      _subscribe();
    }
  }

  void _subscribe() {
    final cubit = widget.cubit;
    if (cubit != null) {
      try {
        final Stream<FpEffect>? stream = cubit is FpEffectEmitter
            ? cubit.effectStream
            : (cubit as dynamic).effectStream as Stream<FpEffect>?;
        if (stream != null) {
          _subscription = stream.listen(_handleEffect);
        }
      } catch (e) {
        // In debug mode, surface the error so developers notice wrong cubit types.
        assert(() {
          debugPrint(
            'FpEffectListener: cubit ${cubit.runtimeType} does not expose '
            'effectStream — $e',
          );
          return true;
        }());
      }
    }
  }

  void _handleEffect(FpEffect effect) {
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
