import 'package:flutter_prakash/flutter_prakash.dart';

/// Form State holding email and password Formz inputs.
class LoginState extends FormCubitState<String> {
  final PrakashEmailInput email;
  final PrakashPasswordInput password;

  const LoginState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    this.email = const PrakashEmailInput.pure(),
    this.password = const PrakashPasswordInput.pure(),
  });

  @override
  LoginState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    String? result,
    PrakashEmailInput? email,
    PrakashPasswordInput? password,
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
class LoginCubit extends BaseFormCubit<LoginState, String> {
  LoginCubit() : super(const LoginState());

  void emailChanged(String value) {
    final email = PrakashEmailInput.dirty(value);
    final isValid = Formz.validate([email, state.password]);
    safeEmit(state.copyWith(email: email, isValid: isValid));
  }

  void passwordChanged(String value) {
    final password = PrakashPasswordInput.dirty(value);
    final isValid = Formz.validate([state.email, password]);
    safeEmit(state.copyWith(password: password, isValid: isValid));
  }

  Future<void> submit() async {
    await submitForm(
      call: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        if (state.email.value.contains('fail')) {
          return const Result.error(AuthFailure('Invalid login credentials.'));
        }
        return Result.success('User ${state.email.value} authenticated successfully!');
      },
      onSuccess: (message) {
        emitEffect(ShowToastEffect(message));
      },
    );
  }
}
