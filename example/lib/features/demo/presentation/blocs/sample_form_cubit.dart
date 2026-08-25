import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/features/demo/data/repositories/demo_repository.dart';

/// Form State holding [Field] inputs.
class SampleFormState extends FormCubitState<String> {
  final Field<String> email;
  final Field<String> password;
  final Field<String> fullName;

  const SampleFormState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    this.email = const Field(value: '', validators: []),
    this.password = const Field(value: '', validators: []),
    this.fullName = const Field(value: '', validators: []),
  });

  /// Factory with validators pre-configured.
  factory SampleFormState.initial() {
    return SampleFormState(
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
      fullName: Field<String>(
        value: '',
        labelText: 'Full Name',
        validators: Validators.required().minLength(2),
      ),
    );
  }

  @override
  SampleFormState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    String? result,
    Field<String>? email,
    Field<String>? password,
    Field<String>? fullName,
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
  List<Object?> get props => [...super.props, email, password, fullName];
}

/// Sample Form Cubit managing form submissions via DemoRepository.
@injectable
class SampleFormCubit extends BaseFormCubit<SampleFormState, String> {
  final DemoRepository _demoRepository;

  SampleFormCubit(this._demoRepository) : super(SampleFormState.initial());

  void emailChanged(String value) {
    final email = state.email.update(value);
    safeEmit(
      state.copyWith(
        email: email,
        isValid:
            email.isValid && state.password.isValid && state.fullName.isValid,
      ),
    );
  }

  void passwordChanged(String value) {
    final password = state.password.update(value);
    safeEmit(
      state.copyWith(
        password: password,
        isValid:
            state.email.isValid && password.isValid && state.fullName.isValid,
      ),
    );
  }

  void fullNameChanged(String value) {
    final fullName = state.fullName.update(value);
    safeEmit(
      state.copyWith(
        fullName: fullName,
        isValid:
            state.email.isValid && state.password.isValid && fullName.isValid,
      ),
    );
  }

  Future<void> submit() async {
    await submitForm(
      call: () async {
        final result = await _demoRepository.submitForm(
          title: state.fullName.value,
          description: 'Registration for email: ${state.email.value}',
        );
        return result.when(
          success: (item) =>
              Result.success('Submitted item ${item.id}: ${item.title}'),
          error: (failure) => Result.error(failure),
        );
      },
      onSuccess: (message) {
        emitEffect(ShowToastEffect(message));
      },
    );
  }
}
