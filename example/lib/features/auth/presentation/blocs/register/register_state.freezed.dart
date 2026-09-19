// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RegisterState {

 Field<String> get fullName; Field<String> get email; Field<String> get password; Field<String> get confirmPassword; Field<bool> get agreeToTerms; bool get isPasswordObscured; bool get isConfirmPasswordObscured; BlocStatus get status;
/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterStateCopyWith<RegisterState> get copyWith => _$RegisterStateCopyWithImpl<RegisterState>(this as RegisterState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.agreeToTerms, agreeToTerms) || other.agreeToTerms == agreeToTerms)&&(identical(other.isPasswordObscured, isPasswordObscured) || other.isPasswordObscured == isPasswordObscured)&&(identical(other.isConfirmPasswordObscured, isConfirmPasswordObscured) || other.isConfirmPasswordObscured == isConfirmPasswordObscured)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,email,password,confirmPassword,agreeToTerms,isPasswordObscured,isConfirmPasswordObscured,status);

@override
String toString() {
  return 'RegisterState(fullName: $fullName, email: $email, password: $password, confirmPassword: $confirmPassword, agreeToTerms: $agreeToTerms, isPasswordObscured: $isPasswordObscured, isConfirmPasswordObscured: $isConfirmPasswordObscured, status: $status)';
}


}

/// @nodoc
abstract mixin class $RegisterStateCopyWith<$Res>  {
  factory $RegisterStateCopyWith(RegisterState value, $Res Function(RegisterState) _then) = _$RegisterStateCopyWithImpl;
@useResult
$Res call({
 Field<String> fullName, Field<String> email, Field<String> password, Field<String> confirmPassword, Field<bool> agreeToTerms, bool isPasswordObscured, bool isConfirmPasswordObscured, BlocStatus status
});




}
/// @nodoc
class _$RegisterStateCopyWithImpl<$Res>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._self, this._then);

  final RegisterState _self;
  final $Res Function(RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? confirmPassword = null,Object? agreeToTerms = null,Object? isPasswordObscured = null,Object? isConfirmPasswordObscured = null,Object? status = null,}) {
  return _then(RegisterState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as Field<String>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Field<String>,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Field<String>,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as Field<String>,agreeToTerms: null == agreeToTerms ? _self.agreeToTerms : agreeToTerms // ignore: cast_nullable_to_non_nullable
as Field<bool>,isPasswordObscured: null == isPasswordObscured ? _self.isPasswordObscured : isPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,isConfirmPasswordObscured: null == isConfirmPasswordObscured ? _self.isConfirmPasswordObscured : isConfirmPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterState].
extension RegisterStatePatterns on RegisterState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterState value)  $default,){
final _that = this;
switch (_that) {
case _RegisterState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterState value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Field<String> fullName,  Field<String> email,  Field<String> password,  Field<String> confirmPassword,  Field<bool> agreeToTerms,  bool isPasswordObscured,  bool isConfirmPasswordObscured,  BlocStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.fullName,_that.email,_that.password,_that.confirmPassword,_that.agreeToTerms,_that.isPasswordObscured,_that.isConfirmPasswordObscured,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Field<String> fullName,  Field<String> email,  Field<String> password,  Field<String> confirmPassword,  Field<bool> agreeToTerms,  bool isPasswordObscured,  bool isConfirmPasswordObscured,  BlocStatus status)  $default,) {final _that = this;
switch (_that) {
case _RegisterState():
return $default(_that.fullName,_that.email,_that.password,_that.confirmPassword,_that.agreeToTerms,_that.isPasswordObscured,_that.isConfirmPasswordObscured,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Field<String> fullName,  Field<String> email,  Field<String> password,  Field<String> confirmPassword,  Field<bool> agreeToTerms,  bool isPasswordObscured,  bool isConfirmPasswordObscured,  BlocStatus status)?  $default,) {final _that = this;
switch (_that) {
case _RegisterState() when $default != null:
return $default(_that.fullName,_that.email,_that.password,_that.confirmPassword,_that.agreeToTerms,_that.isPasswordObscured,_that.isConfirmPasswordObscured,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _RegisterState extends RegisterState {
  const _RegisterState({required this.fullName, required this.email, required this.password, required this.confirmPassword, required this.agreeToTerms, this.isPasswordObscured = true, this.isConfirmPasswordObscured = true, this.status = const BlocStatus.initial()}): super._();
  

@override final  Field<String> fullName;
@override final  Field<String> email;
@override final  Field<String> password;
@override final  Field<String> confirmPassword;
@override final  Field<bool> agreeToTerms;
@override@JsonKey() final  bool isPasswordObscured;
@override@JsonKey() final  bool isConfirmPasswordObscured;
@override@JsonKey() final  BlocStatus status;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterStateCopyWith<_RegisterState> get copyWith => __$RegisterStateCopyWithImpl<_RegisterState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.agreeToTerms, agreeToTerms) || other.agreeToTerms == agreeToTerms)&&(identical(other.isPasswordObscured, isPasswordObscured) || other.isPasswordObscured == isPasswordObscured)&&(identical(other.isConfirmPasswordObscured, isConfirmPasswordObscured) || other.isConfirmPasswordObscured == isConfirmPasswordObscured)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,email,password,confirmPassword,agreeToTerms,isPasswordObscured,isConfirmPasswordObscured,status);

@override
String toString() {
  return 'RegisterState(fullName: $fullName, email: $email, password: $password, confirmPassword: $confirmPassword, agreeToTerms: $agreeToTerms, isPasswordObscured: $isPasswordObscured, isConfirmPasswordObscured: $isConfirmPasswordObscured, status: $status)';
}


}

/// @nodoc
abstract mixin class _$RegisterStateCopyWith<$Res> implements $RegisterStateCopyWith<$Res> {
  factory _$RegisterStateCopyWith(_RegisterState value, $Res Function(_RegisterState) _then) = __$RegisterStateCopyWithImpl;
@override @useResult
$Res call({
 Field<String> fullName, Field<String> email, Field<String> password, Field<String> confirmPassword, Field<bool> agreeToTerms, bool isPasswordObscured, bool isConfirmPasswordObscured, BlocStatus status
});




}
/// @nodoc
class __$RegisterStateCopyWithImpl<$Res>
    implements _$RegisterStateCopyWith<$Res> {
  __$RegisterStateCopyWithImpl(this._self, this._then);

  final _RegisterState _self;
  final $Res Function(_RegisterState) _then;

/// Create a copy of RegisterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? confirmPassword = null,Object? agreeToTerms = null,Object? isPasswordObscured = null,Object? isConfirmPasswordObscured = null,Object? status = null,}) {
  return _then(_RegisterState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as Field<String>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Field<String>,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Field<String>,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as Field<String>,agreeToTerms: null == agreeToTerms ? _self.agreeToTerms : agreeToTerms // ignore: cast_nullable_to_non_nullable
as Field<bool>,isPasswordObscured: null == isPasswordObscured ? _self.isPasswordObscured : isPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,isConfirmPasswordObscured: null == isConfirmPasswordObscured ? _self.isConfirmPasswordObscured : isConfirmPasswordObscured // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,
  ));
}


}

// dart format on
