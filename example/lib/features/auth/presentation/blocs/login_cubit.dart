import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/features/auth/data/repositories/auth_repository.dart';

/// Form State holding email and password [Field] inputs.
class LoginState extends FormCubitState<String> {
  final Field<String> email;
  final Field<String> password;

  const LoginState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    this.email = const Field(value: '', validators: []),
    this.password = const Field(value: '', validators: []),
  });

  /// Factory with validators pre-configured.
  factory LoginState.initial() {
    return LoginState(
      email: Field<String>(
        value: '',
        labelText: 'Email',
        validators: Validators.required().email(),
      ),
      password: Field<String>(
        value: '',
        labelText: 'Password',
        validators: Validators.required().minLength(6),
      ),
    );
  }

  @override
  LoginState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    String? result,
    Field<String>? email,
    Field<String>? password,
  }) {
    return LoginState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [...super.props, email, password];
}

/// Login Form Cubit managing authentication input validation & submission via BaseFormCubit.
@injectable
class LoginCubit extends BaseFormCubit<LoginState, String> {
  final AuthRepository _authRepository;

  LoginCubit(this._authRepository) : super(LoginState.initial());

  void emailChanged(String value) {
    final email = state.email.update(value);
    safeEmit(
      state.copyWith(
        email: email,
        isValid: email.isValid && state.password.isValid,
      ),
    );
  }

  void passwordChanged(String value) {
    final password = state.password.update(value);
    safeEmit(
      state.copyWith(
        password: password,
        isValid: state.email.isValid && password.isValid,
      ),
    );
  }

  Future<void> submit() async {
    await submitForm(
      call: () async {
        final result = await _authRepository.login(
          email: state.email.value,
          password: state.password.value,
        );
        return result.when(
          success: (user) => Result.success('Welcome back, ${user.name}!'),
          error: (failure) => Result.error(failure),
        );
      },
      onSuccess: (message) {
        emitEffect(ShowToastEffect(message));
      },
    );
  }
}
