import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:dartz/dartz.dart' hide State;
import '../../network/failures.dart';
import '../../network/result.dart';
import 'base_cubit.dart';
import 'dartz_extensions.dart';
import 'ui_effect.dart';

/// Standard Form Status wrapper.
enum FormStatus { initial, inProgress, success, failure }

/// Generic state representation for Forms built with `Formz`.
class FormCubitState<T> extends Equatable {
  final FormStatus status;
  final bool isValid;
  final Failure? failure;
  final T? result;

  const FormCubitState({
    this.status = FormStatus.initial,
    this.isValid = false,
    this.failure,
    this.result,
  });

  bool get isInitial => status == FormStatus.initial;
  bool get isInProgress => status == FormStatus.inProgress;
  bool get isSuccess => status == FormStatus.success;
  bool get isFailure => status == FormStatus.failure;

  FormCubitState<T> copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    T? result,
  }) {
    return FormCubitState<T>(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [status, isValid, failure, result];
}

/// Abstract base Form Cubit for managing form input lifecycle, validation & submission.
abstract class BaseFormCubit<State extends FormCubitState<T>, T>
    extends BaseCubit<State> {
  BaseFormCubit(super.initialState);

  /// Helper to submit the form asynchronously with a [ResultFuture].
  Future<void> submitForm({
    required Future<Result<T>> Function() call,
    void Function(T result)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    if (!state.isValid) {
      emitEffect(
        const ShowToastEffect(
          'Please complete all required fields correctly.',
          isError: true,
        ),
      );
      return;
    }

    safeEmit(state.copyWith(status: FormStatus.inProgress, failure: null) as State);

    try {
      final result = await call();
      result.when(
        success: (data) {
          safeEmit(
            state.copyWith(status: FormStatus.success, result: data) as State,
          );
          onSuccess?.call(data);
        },
        error: (failure) {
          safeEmit(
            state.copyWith(status: FormStatus.failure, failure: failure)
                as State,
          );
          onError?.call(failure);
          emitEffect(ShowSnackBarEffect(failure.message, isError: true));
        },
      );
    } catch (e) {
      final failure = UnexpectedFailure(e.toString());
      safeEmit(
        state.copyWith(status: FormStatus.failure, failure: failure) as State,
      );
      onError?.call(failure);
      emitEffect(ShowSnackBarEffect(failure.message, isError: true));
    }
  }

  /// Helper to submit form with a `dartz` [Either].
  Future<void> submitFormEither<L>({
    required Future<Either<L, T>> Function() call,
    Failure Function(L left)? failureMapper,
    void Function(T result)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    return submitForm(
      call: () async {
        final either = await call();
        return either.toResult(failureMapper: failureMapper);
      },
      onSuccess: onSuccess,
      onError: onError,
    );
  }
}

// =============================================================================
// PRE-BUILT COMMON FORMZ INPUT VALIDATORS
// =============================================================================

enum EmailValidationError { empty, invalid }

/// Pre-built reusable Email Formz Input.
class PrakashEmailInput extends FormzInput<String, EmailValidationError> {
  const PrakashEmailInput.pure([super.value = '']) : super.pure();
  const PrakashEmailInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&'
    r"'"
    r'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  @override
  EmailValidationError? validator(String value) {
    if (value.trim().isEmpty) return EmailValidationError.empty;
    return _emailRegExp.hasMatch(value.trim())
        ? null
        : EmailValidationError.invalid;
  }
}

enum NonEmptyValidationError { empty }

/// Pre-built reusable Non-Empty Text Formz Input.
class PrakashRequiredInput extends FormzInput<String, NonEmptyValidationError> {
  const PrakashRequiredInput.pure([super.value = '']) : super.pure();
  const PrakashRequiredInput.dirty([super.value = '']) : super.dirty();

  @override
  NonEmptyValidationError? validator(String value) {
    return value.trim().isNotEmpty ? null : NonEmptyValidationError.empty;
  }
}

enum PasswordValidationError { empty, tooShort }

/// Pre-built reusable Password Formz Input.
class PrakashPasswordInput extends FormzInput<String, PasswordValidationError> {
  final int minLength;

  const PrakashPasswordInput.pure([super.value = '', this.minLength = 6])
      : super.pure();
  const PrakashPasswordInput.dirty([super.value = '', this.minLength = 6])
      : super.dirty();

  @override
  PasswordValidationError? validator(String value) {
    if (value.isEmpty) return PasswordValidationError.empty;
    if (value.length < minLength) return PasswordValidationError.tooShort;
    return null;
  }
}

enum PhoneValidationError { empty, invalid }

/// Pre-built reusable Phone Number Formz Input.
class PrakashPhoneInput extends FormzInput<String, PhoneValidationError> {
  const PrakashPhoneInput.pure([super.value = '']) : super.pure();
  const PrakashPhoneInput.dirty([super.value = '']) : super.dirty();

  static final RegExp _phoneRegExp = RegExp(r'^\+?[0-9]{7,15}$');

  @override
  PhoneValidationError? validator(String value) {
    if (value.trim().isEmpty) return PhoneValidationError.empty;
    final sanitized = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    return _phoneRegExp.hasMatch(sanitized) ? null : PhoneValidationError.invalid;
  }
}

enum UrlValidationError { empty, invalid }

/// Pre-built reusable URL Formz Input.
class PrakashUrlInput extends FormzInput<String, UrlValidationError> {
  const PrakashUrlInput.pure([super.value = '']) : super.pure();
  const PrakashUrlInput.dirty([super.value = '']) : super.dirty();

  @override
  UrlValidationError? validator(String value) {
    if (value.trim().isEmpty) return UrlValidationError.empty;
    final uri = Uri.tryParse(value.trim());
    if (uri != null && uri.hasAbsolutePath && (uri.isScheme('http') || uri.isScheme('https'))) {
      return null;
    }
    return UrlValidationError.invalid;
  }
}

enum ConfirmPasswordValidationError { empty, mismatch }

/// Pre-built reusable Confirm Password Formz Input.
class PrakashConfirmPasswordInput
    extends FormzInput<String, ConfirmPasswordValidationError> {
  final String originalPassword;

  const PrakashConfirmPasswordInput.pure({
    String value = '',
    this.originalPassword = '',
  }) : super.pure(value);

  const PrakashConfirmPasswordInput.dirty({
    required String value,
    required this.originalPassword,
  }) : super.dirty(value);

  @override
  ConfirmPasswordValidationError? validator(String value) {
    if (value.isEmpty) return ConfirmPasswordValidationError.empty;
    return value == originalPassword ? null : ConfirmPasswordValidationError.mismatch;
  }
}

enum MinLengthValidationError { empty, tooShort }

/// Pre-built reusable Minimum Length Formz Input.
class PrakashMinLengthInput extends FormzInput<String, MinLengthValidationError> {
  final int minLength;

  const PrakashMinLengthInput.pure({
    String value = '',
    this.minLength = 3,
  }) : super.pure(value);

  const PrakashMinLengthInput.dirty({
    required String value,
    required this.minLength,
  }) : super.dirty(value);

  @override
  MinLengthValidationError? validator(String value) {
    if (value.trim().isEmpty) return MinLengthValidationError.empty;
    return value.trim().length >= minLength ? null : MinLengthValidationError.tooShort;
  }
}

