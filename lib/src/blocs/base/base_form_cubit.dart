import 'package:equatable/equatable.dart';
import '../../network/failures.dart';
import '../../network/result.dart';
import 'base_cubit.dart';

/// Status of a form submission lifecycle.
enum FormStatus {
  initial,
  inProgress,
  success,
  failure;

  bool get isInitial => this == FormStatus.initial;
  bool get isInProgress => this == FormStatus.inProgress;
  bool get isSuccess => this == FormStatus.success;
  bool get isFailure => this == FormStatus.failure;
}

/// Base state class for form cubits with status tracking, validation,
/// and optional result payload.
///
/// Subclass this for each form, adding your own [Field] properties:
/// ```dart
/// class LoginState extends FormCubitState<String> {
///   final Field<String> email;
///   final Field<String> password;
///
///   const LoginState({
///     super.status,
///     super.isValid,
///     super.failure,
///     super.result,
///     this.email = const Field(value: ''),
///     this.password = const Field(value: ''),
///   });
///
///   @override
///   LoginState copyWith({...}) { ... }
///
///   @override
///   List<Object?> get props => [...super.props, email, password];
/// }
/// ```
abstract class FormCubitState<R> extends Equatable {
  final FormStatus status;
  final bool isValid;
  final Failure? failure;
  final R? result;

  const FormCubitState({
    this.status = FormStatus.initial,
    this.isValid = false,
    this.failure,
    this.result,
  });

  /// Whether the form is currently submitting.
  bool get isInProgress => status.isInProgress;

  /// Whether the form submission was successful.
  bool get isSuccess => status.isSuccess;

  /// Whether the form submission failed.
  bool get isFailure => status.isFailure;

  /// The error message from [failure], if any.
  String? get errorMessage => failure?.errorMessage;

  /// Subclasses must implement to provide a copy with updated fields.
  FormCubitState<R> copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    R? result,
  });

  @override
  List<Object?> get props => [status, isValid, failure, result];
}

/// Enterprise base form cubit that eliminates the
/// validate → loading → API → result boilerplate.
///
/// ### Usage:
/// ```dart
/// @injectable
/// class LoginCubit extends BaseFormCubit<LoginState, String> {
///   final AuthRepository _repo;
///   LoginCubit(this._repo) : super(const LoginState());
///
///   void emailChanged(String v) {
///     final email = state.email.update(v);
///     safeEmit(state.copyWith(email: email, isValid: email.isValid && state.password.isValid));
///   }
///
///   Future<void> submit() async {
///     await submitForm(
///       call: () => _repo.login(email: state.email.value, password: state.password.value),
///       onSuccess: (message) => emitEffect(ShowToastEffect(message)),
///     );
///   }
/// }
/// ```
abstract class BaseFormCubit<S extends FormCubitState<R>, R>
    extends BaseCubit<S> {
  BaseFormCubit(super.initialState);

  /// Executes a form submission with automatic status lifecycle management.
  ///
  /// 1. Validates [state.isValid] — emits failure if invalid.
  /// 2. Emits `FormStatus.inProgress`.
  /// 3. Calls [call] which must return `Result<R>`.
  /// 4. Maps success/error and emits the appropriate status.
  Future<void> submitForm({
    required Future<Result<R>> Function() call,
    void Function(R data)? onSuccess,
    void Function(Failure failure)? onError,
  }) async {
    // Validate
    if (!state.isValid) {
      safeEmit(state.copyWith(status: FormStatus.failure) as S);
      return;
    }

    // Loading
    safeEmit(state.copyWith(status: FormStatus.inProgress) as S);

    // Execute
    final result = await call();
    result.when(
      success: (data) {
        safeEmit(state.copyWith(status: FormStatus.success, result: data) as S);
        onSuccess?.call(data);
      },
      error: (failure) {
        safeEmit(
          state.copyWith(status: FormStatus.failure, failure: failure) as S,
        );
        onError?.call(failure);
      },
    );
  }
}
