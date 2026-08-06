import 'package:flutter_prakash/flutter_prakash.dart';

/// Form State holding Formz inputs.
class SampleFormState extends FormCubitState<String> {
  final PrakashEmailInput email;
  final PrakashPasswordInput password;
  final PrakashRequiredInput fullName;

  const SampleFormState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    this.email = const PrakashEmailInput.pure(),
    this.password = const PrakashPasswordInput.pure(),
    this.fullName = const PrakashRequiredInput.pure(),
  });

  @override
  SampleFormState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    String? result,
    PrakashEmailInput? email,
    PrakashPasswordInput? password,
    PrakashRequiredInput? fullName,
  }) {
    return SampleFormState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        email,
        password,
        fullName,
      ];
}

/// Sample Form Cubit demonstrating zero-boilerplate form management.
class SampleFormCubit extends BaseFormCubit<SampleFormState, String> {
  SampleFormCubit() : super(const SampleFormState());

  void emailChanged(String value) {
    final email = PrakashEmailInput.dirty(value);
    final isValid = Formz.validate([email, state.password, state.fullName]);
    safeEmit(state.copyWith(email: email, isValid: isValid));
  }

  void passwordChanged(String value) {
    final password = PrakashPasswordInput.dirty(value);
    final isValid = Formz.validate([state.email, password, state.fullName]);
    safeEmit(state.copyWith(password: password, isValid: isValid));
  }

  void fullNameChanged(String value) {
    final fullName = PrakashRequiredInput.dirty(value);
    final isValid = Formz.validate([state.email, state.password, fullName]);
    safeEmit(state.copyWith(fullName: fullName, isValid: isValid));
  }

  Future<void> submit() async {
    await submitForm(
      call: () async {
        await Future.delayed(const Duration(seconds: 1));
        if (state.email.value.contains('error')) {
          return const Result.error(ServerFailure('Invalid email address domain'));
        }
        return Result.success('User ${state.fullName.value} registered successfully!');
      },
      onSuccess: (message) {
        emitEffect(ShowToastEffect(message));
      },
    );
  }
}
