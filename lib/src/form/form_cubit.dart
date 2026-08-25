import '../blocs/base/base_cubit.dart';
import 'bloc_status.dart';
import 'form_mixin.dart';
import '../network/result.dart';

/// A base state interface that all form states must satisfy.
///
/// This enables [FormCubit] to generically read/write [status] and
/// dirty all fields without knowing the concrete state shape.
abstract class FormState implements FormMixin {
  BlocStatus get status;

  /// Creates a copy with the given [status].
  FormState copyWithStatus(BlocStatus status);

  /// Returns a copy with all fields marked dirty (for submit-time validation).
  FormState makeAllDirty();
}

/// A generic form cubit that eliminates the validate→loading→result boilerplate.
///
/// Subclasses only need to:
/// 1. Define the concrete state class (extending [FormState]).
/// 2. Add field updater methods.
/// 3. Override [performSubmit] with the actual API call.
///
/// ```dart
/// @injectable
/// class LoginCubit extends FormCubit<LoginState> {
///   final AuthRepository _repo;
///   LoginCubit(this._repo) : super(LoginState.initial());
///
///   void updateEmail(String v) => emit(state.copyWith(email: state.email.update(v)));
///   void updatePassword(String v) => emit(state.copyWith(password: state.password.update(v)));
///
///   @override
///   Future<Result<dynamic>> performSubmit() => _repo.login(
///     email: state.email.value,
///     password: state.password.value,
///   );
/// }
/// ```
abstract class FormCubit<S extends FormState> extends BaseCubit<S> {
  FormCubit(super.initialState);

  /// Override this to execute the actual API call.
  /// Only called after validation passes.
  Future<Result<dynamic>> performSubmit();

  /// Standard submit flow: dirty → validate → loading → API → result.
  Future<void> submit() async {
    // 1. Force all fields dirty to show errors
    final evaluatedState = state.makeAllDirty() as S;
    safeEmit(evaluatedState);

    // 2. Validate
    if (!evaluatedState.isFormValid) {
      final errorMsg =
          evaluatedState.firstError ?? 'Please fix the errors in the form.';
      safeEmit(evaluatedState.copyWithStatus(BlocStatus.failure(errorMsg)) as S);
      return;
    }

    // 3. Loading
    safeEmit(evaluatedState.copyWithStatus(const BlocStatus.loading()) as S);

    // 4. Execute and map result
    final result = await performSubmit();
    result.when(
      success: (_) =>
          safeEmit(state.copyWithStatus(const BlocStatus.success()) as S),
      error: (error) => safeEmit(
        state.copyWithStatus(BlocStatus.failure(error.errorMessage)) as S,
      ),
    );
  }
}
