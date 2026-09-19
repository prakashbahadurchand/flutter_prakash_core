// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetPasswordState {

 Field<String> get otpCode; Field<String> get newPassword; Field<String> get confirmPassword; String get email; bool get isNewPasswordObscured; bool get isConfirmPasswordObscured; BlocStatus get status;
/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordStateCopyWith<ResetPasswordState> get copyWith => _$ResetPasswordStateCopyWithImpl<ResetPasswordState>(this as ResetPasswordState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordState&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.email, email) || other.email == email)&&(identical(other.isNewPasswordObscured, isNewPasswordObscured) || other.isNewPasswordObscured == isNewPasswordObscured)&&(identical(other.isConfirmPasswordObscured, isConfirmPasswordObscured) || other.isConfirmPasswordObscured == isConfirmPasswordObscured)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,otpCode,newPassword,confirmPassword,email,isNewPasswordObscured,isConfirmPasswordObscured,status);

@override
String toString() {
  return 'ResetPasswordState(otpCode: $otpCode, newPassword: $newPassword, confirmPassword: $confirmPassword, email: $email, isNewPasswordObscured: $isNewPasswordObscured, isConfirmPasswordObscured: $isConfirmPasswordObscured, status: $status)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordStateCopyWith<$Res>  {
  factory $ResetPasswordStateCopyWith(ResetPasswordState value, $Res Function(ResetPasswordState) _then) = _$ResetPasswordStateCopyWithImpl;
@useResult
$Res call({
 Field<String> otpCode, Field<String> newPassword, Field<String> confirmPassword, String email, bool isNewPasswordObscured, bool isConfirmPasswordObscured, BlocStatus status
});




}
/// @nodoc
class _$ResetPasswordStateCopyWithImpl<$Res>
    implements $ResetPasswordStateCopyWith<$Res> {
  _$ResetPasswordStateCopyWithImpl(this._self, this._then);

  final ResetPasswordState _self;
  final $Res Function(ResetPasswordState) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? otpCode = null,Object? newPassword = null,Object? confirmPassword = null,Object? email = null,Object? isNewPasswordObscured = null,Object? isConfirmPasswordObscured = null,Object? status = null,}) {
  return _then(ResetPasswordState(
otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as Field<String>,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as Field<String>,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as Field<String>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isNewPasswordObscured: null == isNewPasswordObscured ? _self.isNewPasswordObscured : isNewPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,isConfirmPasswordObscured: null == isConfirmPasswordObscured ? _self.isConfirmPasswordObscured : isConfirmPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ResetPasswordState].
extension ResetPasswordStatePatterns on ResetPasswordState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResetPasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResetPasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ResetPasswordState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResetPasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Field<String> otpCode,  Field<String> newPassword,  Field<String> confirmPassword,  String email,  bool isNewPasswordObscured,  bool isConfirmPasswordObscured,  BlocStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
return $default(_that.otpCode,_that.newPassword,_that.confirmPassword,_that.email,_that.isNewPasswordObscured,_that.isConfirmPasswordObscured,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Field<String> otpCode,  Field<String> newPassword,  Field<String> confirmPassword,  String email,  bool isNewPasswordObscured,  bool isConfirmPasswordObscured,  BlocStatus status)  $default,) {final _that = this;
switch (_that) {
case _ResetPasswordState():
return $default(_that.otpCode,_that.newPassword,_that.confirmPassword,_that.email,_that.isNewPasswordObscured,_that.isConfirmPasswordObscured,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Field<String> otpCode,  Field<String> newPassword,  Field<String> confirmPassword,  String email,  bool isNewPasswordObscured,  bool isConfirmPasswordObscured,  BlocStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ResetPasswordState() when $default != null:
return $default(_that.otpCode,_that.newPassword,_that.confirmPassword,_that.email,_that.isNewPasswordObscured,_that.isConfirmPasswordObscured,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ResetPasswordState extends ResetPasswordState {
  const _ResetPasswordState({required this.otpCode, required this.newPassword, required this.confirmPassword, this.email = '', this.isNewPasswordObscured = true, this.isConfirmPasswordObscured = true, this.status = const BlocStatus.initial()}): super._();
  

@override final  Field<String> otpCode;
@override final  Field<String> newPassword;
@override final  Field<String> confirmPassword;
@override@JsonKey() final  String email;
@override@JsonKey() final  bool isNewPasswordObscured;
@override@JsonKey() final  bool isConfirmPasswordObscured;
@override@JsonKey() final  BlocStatus status;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResetPasswordStateCopyWith<_ResetPasswordState> get copyWith => __$ResetPasswordStateCopyWithImpl<_ResetPasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResetPasswordState&&(identical(other.otpCode, otpCode) || other.otpCode == otpCode)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.email, email) || other.email == email)&&(identical(other.isNewPasswordObscured, isNewPasswordObscured) || other.isNewPasswordObscured == isNewPasswordObscured)&&(identical(other.isConfirmPasswordObscured, isConfirmPasswordObscured) || other.isConfirmPasswordObscured == isConfirmPasswordObscured)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,otpCode,newPassword,confirmPassword,email,isNewPasswordObscured,isConfirmPasswordObscured,status);

@override
String toString() {
  return 'ResetPasswordState(otpCode: $otpCode, newPassword: $newPassword, confirmPassword: $confirmPassword, email: $email, isNewPasswordObscured: $isNewPasswordObscured, isConfirmPasswordObscured: $isConfirmPasswordObscured, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ResetPasswordStateCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory _$ResetPasswordStateCopyWith(_ResetPasswordState value, $Res Function(_ResetPasswordState) _then) = __$ResetPasswordStateCopyWithImpl;
@override @useResult
$Res call({
 Field<String> otpCode, Field<String> newPassword, Field<String> confirmPassword, String email, bool isNewPasswordObscured, bool isConfirmPasswordObscured, BlocStatus status
});




}
/// @nodoc
class __$ResetPasswordStateCopyWithImpl<$Res>
    implements _$ResetPasswordStateCopyWith<$Res> {
  __$ResetPasswordStateCopyWithImpl(this._self, this._then);

  final _ResetPasswordState _self;
  final $Res Function(_ResetPasswordState) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? otpCode = null,Object? newPassword = null,Object? confirmPassword = null,Object? email = null,Object? isNewPasswordObscured = null,Object? isConfirmPasswordObscured = null,Object? status = null,}) {
  return _then(_ResetPasswordState(
otpCode: null == otpCode ? _self.otpCode : otpCode // ignore: cast_nullable_to_non_nullable
as Field<String>,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as Field<String>,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as Field<String>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,isNewPasswordObscured: null == isNewPasswordObscured ? _self.isNewPasswordObscured : isNewPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,isConfirmPasswordObscured: null == isConfirmPasswordObscured ? _self.isConfirmPasswordObscured : isConfirmPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,
  ));
}


}

// dart format on
