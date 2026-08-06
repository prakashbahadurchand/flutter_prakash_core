import 'package:equatable/equatable.dart';

/// Abstract base class for one-shot UI effects emitted by BLoCs or Cubits.
///
/// UI Effects represent transient actions that should happen exactly once
/// (e.g. showing a SnackBar, displaying a Toast, opening a bottom sheet, or navigating)
/// without modifying persistent state.
abstract class UiEffect extends Equatable {
  const UiEffect();

  @override
  List<Object?> get props => [];
}

/// Pre-built effect to show a Toast overlay.
class ShowToastEffect extends UiEffect {
  final String message;
  final bool isError;
  final Duration? duration;

  const ShowToastEffect(
    this.message, {
    this.isError = false,
    this.duration,
  });

  @override
  List<Object?> get props => [message, isError, duration];
}

/// Pre-built effect to show a SnackBar.
class ShowSnackBarEffect extends UiEffect {
  final String message;
  final String? actionLabel;
  final void Function()? onAction;
  final bool isError;

  const ShowSnackBarEffect(
    this.message, {
    this.actionLabel,
    this.onAction,
    this.isError = false,
  });

  @override
  List<Object?> get props => [message, actionLabel, isError];
}

/// Pre-built effect to trigger route navigation.
class NavigateToEffect extends UiEffect {
  final String path;
  final Object? arguments;
  final bool isReplacement;
  final bool clearHistory;

  const NavigateToEffect(
    this.path, {
    this.arguments,
    this.isReplacement = false,
    this.clearHistory = false,
  });

  @override
  List<Object?> get props => [path, arguments, isReplacement, clearHistory];
}

/// Pre-built effect to pop the active screen.
class PopRouteEffect extends UiEffect {
  final Object? result;

  const PopRouteEffect({this.result});

  @override
  List<Object?> get props => [result];
}

/// Pre-built custom payload effect.
class CustomUiEffect<T> extends UiEffect {
  final String name;
  final T? payload;

  const CustomUiEffect(this.name, {this.payload});

  @override
  List<Object?> get props => [name, payload];
}

/// Pre-built effect to trigger an AlertDialog display.
class ShowDialogEffect extends UiEffect {
  final String title;
  final String message;
  final String? confirmLabel;
  final String? cancelLabel;
  final void Function()? onConfirm;

  const ShowDialogEffect({
    required this.title,
    required this.message,
    this.confirmLabel,
    this.cancelLabel,
    this.onConfirm,
  });

  @override
  List<Object?> get props => [title, message, confirmLabel, cancelLabel];
}

/// Pre-built effect to trigger a BottomSheet display.
class ShowBottomSheetEffect extends UiEffect {
  final String title;
  final String? message;
  final String contentKey;

  const ShowBottomSheetEffect({
    required this.title,
    this.message,
    this.contentKey = '',
  });

  @override
  List<Object?> get props => [title, message, contentKey];
}

