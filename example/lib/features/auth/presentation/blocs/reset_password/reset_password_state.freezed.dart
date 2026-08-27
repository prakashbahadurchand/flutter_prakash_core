// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$ResetPasswordState {
  Field<String> get otpCode => throw _privateConstructorUsedError;
  Field<String> get newPassword => throw _privateConstructorUsedError;
  Field<String> get confirmPassword => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  bool get isNewPasswordObscured => throw _privateConstructorUsedError;
  bool get isConfirmPasswordObscured => throw _privateConstructorUsedError;
  BlocStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ResetPasswordStateCopyWith<ResetPasswordState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordStateCopyWith(
    ResetPasswordState value,
    $Res Function(ResetPasswordState) then,
  ) = _$ResetPasswordStateCopyWithImpl<$Res, ResetPasswordState>;
  @useResult
  $Res call({
    Field<String> otpCode,
    Field<String> newPassword,
    Field<String> confirmPassword,
    String email,
    bool isNewPasswordObscured,
    bool isConfirmPasswordObscured,
    BlocStatus status,
  });
}

/// @nodoc
class _$ResetPasswordStateCopyWithImpl<$Res, $Val extends ResetPasswordState>
    implements $ResetPasswordStateCopyWith<$Res> {
  _$ResetPasswordStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otpCode = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
    Object? email = null,
    Object? isNewPasswordObscured = null,
    Object? isConfirmPasswordObscured = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            otpCode: null == otpCode
                ? _value.otpCode
                : otpCode // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            newPassword: null == newPassword
                ? _value.newPassword
                : newPassword // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            confirmPassword: null == confirmPassword
                ? _value.confirmPassword
                : confirmPassword // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            isNewPasswordObscured: null == isNewPasswordObscured
                ? _value.isNewPasswordObscured
                : isNewPasswordObscured // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ResetPasswordStateImplCopyWith<$Res>
    implements $ResetPasswordStateCopyWith<$Res> {
  factory _$$ResetPasswordStateImplCopyWith(
    _$ResetPasswordStateImpl value,
    $Res Function(_$ResetPasswordStateImpl) then,
  ) = __$$ResetPasswordStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Field<String> otpCode,
    Field<String> newPassword,
    Field<String> confirmPassword,
    String email,
    bool isNewPasswordObscured,
    bool isConfirmPasswordObscured,
    BlocStatus status,
  });
}

/// @nodoc
class __$$ResetPasswordStateImplCopyWithImpl<$Res>
    extends _$ResetPasswordStateCopyWithImpl<$Res, _$ResetPasswordStateImpl>
    implements _$$ResetPasswordStateImplCopyWith<$Res> {
  __$$ResetPasswordStateImplCopyWithImpl(
    _$ResetPasswordStateImpl _value,
    $Res Function(_$ResetPasswordStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otpCode = null,
    Object? newPassword = null,
    Object? confirmPassword = null,
    Object? email = null,
    Object? isNewPasswordObscured = null,
    Object? isConfirmPasswordObscured = null,
    Object? status = null,
  }) {
    return _then(
      _$ResetPasswordStateImpl(
        otpCode: null == otpCode
            ? _value.otpCode
            : otpCode // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        newPassword: null == newPassword
            ? _value.newPassword
            : newPassword // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        confirmPassword: null == confirmPassword
            ? _value.confirmPassword
            : confirmPassword // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        isNewPasswordObscured: null == isNewPasswordObscured
            ? _value.isNewPasswordObscured
            : isNewPasswordObscured // ignore: cast_nullable_to_non_nullable
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

class _$ResetPasswordStateImpl extends _ResetPasswordState {
  const _$ResetPasswordStateImpl({
    required this.otpCode,
    required this.newPassword,
    required this.confirmPassword,
    this.email = '',
    this.isNewPasswordObscured = true,
    this.isConfirmPasswordObscured = true,
    this.status = const BlocStatus.initial(),
  }) : super._();

  @override
  final Field<String> otpCode;
  @override
  final Field<String> newPassword;
  @override
  final Field<String> confirmPassword;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final bool isNewPasswordObscured;
  @override
  @JsonKey()
  final bool isConfirmPasswordObscured;
  @override
  @JsonKey()
  final BlocStatus status;

  @override
  String toString() {
    return 'ResetPasswordState(otpCode: $otpCode, newPassword: $newPassword, confirmPassword: $confirmPassword, email: $email, isNewPasswordObscured: $isNewPasswordObscured, isConfirmPasswordObscured: $isConfirmPasswordObscured, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResetPasswordStateImpl &&
            (identical(other.otpCode, otpCode) || other.otpCode == otpCode) &&
            (identical(other.newPassword, newPassword) ||
                other.newPassword == newPassword) &&
            (identical(other.confirmPassword, confirmPassword) ||
                other.confirmPassword == confirmPassword) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isNewPasswordObscured, isNewPasswordObscured) ||
                other.isNewPasswordObscured == isNewPasswordObscured) &&
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
    otpCode,
    newPassword,
    confirmPassword,
    email,
    isNewPasswordObscured,
    isConfirmPasswordObscured,
    status,
  );

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ResetPasswordStateImplCopyWith<_$ResetPasswordStateImpl> get copyWith =>
      __$$ResetPasswordStateImplCopyWithImpl<_$ResetPasswordStateImpl>(
        this,
        _$identity,
      );
}

abstract class _ResetPasswordState extends ResetPasswordState {
  const factory _ResetPasswordState({
    required final Field<String> otpCode,
    required final Field<String> newPassword,
    required final Field<String> confirmPassword,
    final String email,
    final bool isNewPasswordObscured,
    final bool isConfirmPasswordObscured,
    final BlocStatus status,
  }) = _$ResetPasswordStateImpl;
  const _ResetPasswordState._() : super._();

  @override
  Field<String> get otpCode;
  @override
  Field<String> get newPassword;
  @override
  Field<String> get confirmPassword;
  @override
  String get email;
  @override
  bool get isNewPasswordObscured;
  @override
  bool get isConfirmPasswordObscured;
  @override
  BlocStatus get status;

  /// Create a copy of ResetPasswordState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ResetPasswordStateImplCopyWith<_$ResetPasswordStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
