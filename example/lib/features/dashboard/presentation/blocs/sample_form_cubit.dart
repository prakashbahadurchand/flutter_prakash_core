import 'package:flutter_prakash_core/flutter_prakash_core.dart';
import 'package:flutter_prakash_core_example/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sample_form_cubit.freezed.dart';

@freezed
abstract class SampleFormState with _$SampleFormState, FormMixin implements FormState {
  const SampleFormState._();

  const factory SampleFormState({
    required Field<String> fullName,
    required Field<String> email,
    required Field<String> password,
    @Default(BlocStatus.initial()) BlocStatus status,
  }) = _SampleFormState;

  factory SampleFormState.initial() => SampleFormState(
        fullName: Field(
          value: '',
          labelText: 'Full Name',
          validators: Validators.required().minLength(2),
        ),
        email: Field(
          value: '',
          labelText: 'Email',
          validators: Validators.required().email(),
        ),
        password: Field(
          value: '',
          labelText: 'Password',
          validators: Validators.required().minLength(6),
        ),
      );

  @override
  List<Field<dynamic>> get formFields => [fullName, email, password];

  @override
  SampleFormState copyWithStatus(BlocStatus status) =>
      copyWith(status: status);

  @override
  SampleFormState makeAllDirty() => copyWith(
        fullName: fullName.makeDirty(),
        email: email.makeDirty(),
        password: password.makeDirty(),
      );
}

@injectable
class SampleFormCubit extends FormCubit<SampleFormState> {
  final DashboardRepository _repository;

  SampleFormCubit(this._repository) : super(SampleFormState.initial());

  void onFullNameChanged(String value) =>
      emit(state.copyWith(fullName: state.fullName(value)));

  void onEmailChanged(String value) =>
      emit(state.copyWith(email: state.email(value)));

  void onPasswordChanged(String value) =>
      emit(state.copyWith(password: state.password(value)));

  void reset() => emit(SampleFormState.initial());

  @override
  Future<Result<dynamic>> performSubmit() {
    return _repository.submitForm(
      title: state.fullName.value,
      description: state.email.value,
    );
  }
}
