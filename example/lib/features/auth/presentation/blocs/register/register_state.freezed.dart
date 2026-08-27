// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RegisterState {
  Field<String> get fullName => throw _privateConstructorUsedError;
  Field<String> get email => throw _privateConstructorUsedError;
  Field<String> get password => throw _privateConstructorUsedError;
  Field<String> get confirmPassword => throw _privateConstructorUsedError;
  Field<bool> get agreeToTerms => throw _privateConstructorUsedError;
  bool get isPasswordObscured => throw _privateConstructorUsedError;
  bool get isConfirmPasswordObscured => throw _privateConstructorUsedError;
  BlocStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RegisterStateCopyWith<RegisterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterStateCopyWith<$Res> {
  factory $RegisterStateCopyWith(
    RegisterState value,
    $Res Function(RegisterState) then,
  ) = _$RegisterStateCopyWithImpl<$Res, RegisterState>;
  @useResult
  $Res call({
    Field<String> fullName,
    Field<String> email,
    Field<String> password,
    Field<String> confirmPassword,
    Field<bool> agreeToTerms,
    bool isPasswordObscured,
    bool isConfirmPasswordObscured,
    BlocStatus status,
  });
}

/// @nodoc
class _$RegisterStateCopyWithImpl<$Res, $Val extends RegisterState>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? agreeToTerms = null,
    Object? isPasswordObscured = null,
    Object? isConfirmPasswordObscured = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            confirmPassword: null == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            agreeToTerms: null == agreeToTerms
                ? _value.agreeToTerms
                : agreeToTerms // ignore: cast_nullable_to_non_nullable
                      as Field<bool>,
            isPasswordObscured: null == isPasswordObscured
                ? _value.isPasswordObscured
                : isPasswordObscured // ignore: cast_nullable_to_non_nullable
                      as bool,
            isConfirmPasswordObscured: null == isConfirmPasswordObscured
                ? _value.isConfirmPasswordObscured
                : isConfirmPasswordObscured // ignore: cast_nullable_to_non_nullable
                      as bool,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as BlocStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$RegisterStateImplCopyWith<$Res>
    implements $RegisterStateCopyWith<$Res> {
  factory _$$RegisterStateImplCopyWith(
    _$RegisterStateImpl value,
    $Res Function(_$RegisterStateImpl) then,
  ) = __$$RegisterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Field<String> fullName,
    Field<String> email,
    Field<String> password,
    Field<String> confirmPassword,
    Field<bool> agreeToTerms,
    bool isPasswordObscured,
    bool isConfirmPasswordObscured,
    BlocStatus status,
  });
}

/// @nodoc
class __$$RegisterStateImplCopyWithImpl<$Res>
    extends _$RegisterStateCopyWithImpl<$Res, _$RegisterStateImpl>
    implements _$$RegisterStateImplCopyWith<$Res> {
  __$$RegisterStateImplCopyWithImpl(
    _$RegisterStateImpl _value,
    $Res Function(_$RegisterStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
    Object? confirmPassword = null,
    Object? agreeToTerms = null,
    Object? isPasswordObscured = null,
    Object? isConfirmPasswordObscured = null,
    Object? status = null,
  }) {
    return _then(
      _$RegisterStateImpl(
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        confirmPassword: null == confirmPassword
            ? _value.confirmPassword
            : confirmPassword // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        agreeToTerms: null == agreeToTerms
            ? _value.agreeToTerms
            : agreeToTerms // ignore: cast_nullable_to_non_nullable
                  as Field<bool>,
        isPasswordObscured: null == isPasswordObscured
            ? _value.isPasswordObscured
            : isPasswordObscured // ignore: cast_nullable_to_non_nullable
                  as bool,
        isConfirmPasswordObscured: null == isConfirmPasswordObscured
            ? _value.isConfirmPasswordObscured
            : isConfirmPasswordObscured // ignore: cast_nullable_to_non_nullable
                  as bool,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BlocStatus,
      ),
    );
  }
}

/// @nodoc

class _$RegisterStateImpl extends _RegisterState {
  const _$RegisterStateImpl({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.agreeToTerms,
    this.isPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.status = const BlocStatus.initial(),
  }) : super._();

  @override
  final Field<String> fullName;
  @override
  final Field<String> email;
  @override
  final Field<String> password;
  @override
  final Field<String> confirmPassword;
  @override
  final Field<bool> agreeToTerms;
  @override
  @JsonKey()
  final bool isPasswordObscured;
  @override
  @JsonKey()
  final bool isConfirmPasswordObscured;
  @override
  @JsonKey()
  final BlocStatus status;

  @override
  String toString() {
    return 'RegisterState(fullName: $fullName, email: $email, password: $password, confirmPassword: $confirmPassword, agreeToTerms: $agreeToTerms, isPasswordObscured: $isPasswordObscured, isConfirmPasswordObscured: $isConfirmPasswordObscured, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterStateImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.agreeToTerms, agreeToTerms) ||
                other.agreeToTerms == agreeToTerms) &&
            (identical(other.isPasswordObscured, isPasswordObscured) ||
                other.isPasswordObscured == isPasswordObscured) &&
            (identical(
                  other.isConfirmPasswordObscured,
                  isConfirmPasswordObscured,
                ) ||
                other.isConfirmPasswordObscured == isConfirmPasswordObscured) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    fullName,
    email,
    password,
    confirmPassword,
    agreeToTerms,
    isPasswordObscured,
    isConfirmPasswordObscured,
    status,
  );

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterStateImplCopyWith<_$RegisterStateImpl> get copyWith =>
      __$$RegisterStateImplCopyWithImpl<_$RegisterStateImpl>(this, _$identity);
}

abstract class _RegisterState extends RegisterState {
  const factory _RegisterState({
    required final Field<String> fullName,
    required final Field<String> email,
    required final Field<String> password,
    required final Field<String> confirmPassword,
    required final Field<bool> agreeToTerms,
    final bool isPasswordObscured,
    final bool isConfirmPasswordObscured,
    final BlocStatus status,
  }) = _$RegisterStateImpl;
  const _RegisterState._() : super._();

  @override
  Field<String> get fullName;
  @override
  Field<String> get email;
  @override
  Field<String> get password;
  @override
  Field<String> get confirmPassword;
  @override
  Field<bool> get agreeToTerms;
  @override
  bool get isPasswordObscured;
  @override
  bool get isConfirmPasswordObscured;
  @override
  BlocStatus get status;

  /// Create a copy of RegisterState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RegisterStateImplCopyWith<_$RegisterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
