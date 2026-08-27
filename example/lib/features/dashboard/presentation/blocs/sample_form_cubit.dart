import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/models/sample_item_model.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';

class SampleFormState extends FormCubitState<SampleItemModel> {
  final Field<String> fullName;
  final Field<String> email;
  final Field<String> password;

  SampleFormState({
    super.status,
    super.isValid,
    super.failure,
    super.result,
    Field<String>? fullName,
    Field<String>? email,
    Field<String>? password,
  })  : fullName = fullName ??
            Field(
              value: '',
              labelText: 'Full Name',
              validators: Validators.required(),
            ),
        email = email ??
            Field(
              value: '',
              labelText: 'Email',
              validators: Validators.required().email(),
            ),
        password = password ??
            Field(
              value: '',
              labelText: 'Password',
              validators: Validators.required(),
            );

  @override
  SampleFormState copyWith({
    FormStatus? status,
    bool? isValid,
    Failure? failure,
    SampleItemModel? result,
    Field<String>? fullName,
    Field<String>? email,
    Field<String>? password,
  }) {
    return SampleFormState(
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      failure: failure ?? this.failure,
      result: result ?? this.result,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  List<Object?> get props => [...super.props, fullName, email, password];
}

@injectable
class SampleFormCubit extends BaseFormCubit<SampleFormState, SampleItemModel> {
  final DashboardRepository _repository;

  SampleFormCubit(this._repository) : super(SampleFormState());

  void fullNameChanged(String value) {
    final field = state.fullName(value);
    safeEmit(state.copyWith(
      fullName: field,
      isValid: field.isValid && state.email.isValid && state.password.isValid,
    ));
  }

  void emailChanged(String value) {
    final field = state.email(value);
    safeEmit(state.copyWith(
      email: field,
      isValid: state.fullName.isValid && field.isValid && state.password.isValid,
    ));
  }

  void passwordChanged(String value) {
    final field = state.password(value);
    safeEmit(state.copyWith(
      password: field,
      isValid: state.fullName.isValid && state.email.isValid && field.isValid,
    ));
  }

  Future<void> submit() async {
    await submitForm(
      call: () => _repository.submitForm(
        title: state.fullName.value,
        description: state.email.value,
      ),
      onSuccess: (item) {
        emitEffect(ShowToastEffect('Created ${item.title} successfully!'));
      },
      onError: (failure) {
        emitEffect(ShowToastEffect(failure.errorMessage));
      },
    );
  }
}
