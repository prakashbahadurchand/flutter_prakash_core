// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SampleFormState {

 Field<String> get fullName; Field<String> get email; Field<String> get password; BlocStatus get status;
/// Create a copy of SampleFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SampleFormStateCopyWith<SampleFormState> get copyWith => _$SampleFormStateCopyWithImpl<SampleFormState>(this as SampleFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SampleFormState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,email,password,status);

@override
String toString() {
  return 'SampleFormState(fullName: $fullName, email: $email, password: $password, status: $status)';
}


}

/// @nodoc
abstract mixin class $SampleFormStateCopyWith<$Res>  {
  factory $SampleFormStateCopyWith(SampleFormState value, $Res Function(SampleFormState) _then) = _$SampleFormStateCopyWithImpl;
@useResult
$Res call({
 Field<String> fullName, Field<String> email, Field<String> password, BlocStatus status
});




}
/// @nodoc
class _$SampleFormStateCopyWithImpl<$Res>
    implements $SampleFormStateCopyWith<$Res> {
  _$SampleFormStateCopyWithImpl(this._self, this._then);

  final SampleFormState _self;
  final $Res Function(SampleFormState) _then;

/// Create a copy of SampleFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? status = null,}) {
  return _then(SampleFormState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as Field<String>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Field<String>,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Field<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [SampleFormState].
extension SampleFormStatePatterns on SampleFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SampleFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SampleFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SampleFormState value)  $default,){
final _that = this;
switch (_that) {
case _SampleFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SampleFormState value)?  $default,){
final _that = this;
switch (_that) {
case _SampleFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Field<String> fullName,  Field<String> email,  Field<String> password,  BlocStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SampleFormState() when $default != null:
return $default(_that.fullName,_that.email,_that.password,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Field<String> fullName,  Field<String> email,  Field<String> password,  BlocStatus status)  $default,) {final _that = this;
switch (_that) {
case _SampleFormState():
return $default(_that.fullName,_that.email,_that.password,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Field<String> fullName,  Field<String> email,  Field<String> password,  BlocStatus status)?  $default,) {final _that = this;
switch (_that) {
case _SampleFormState() when $default != null:
return $default(_that.fullName,_that.email,_that.password,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _SampleFormState extends SampleFormState {
  const _SampleFormState({required this.fullName, required this.email, required this.password, this.status = const BlocStatus.initial()}): super._();
  

@override final  Field<String> fullName;
@override final  Field<String> email;
@override final  Field<String> password;
@override@JsonKey() final  BlocStatus status;

/// Create a copy of SampleFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SampleFormStateCopyWith<_SampleFormState> get copyWith => __$SampleFormStateCopyWithImpl<_SampleFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SampleFormState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,fullName,email,password,status);

@override
String toString() {
  return 'SampleFormState(fullName: $fullName, email: $email, password: $password, status: $status)';
}


}

/// @nodoc
abstract mixin class _$SampleFormStateCopyWith<$Res> implements $SampleFormStateCopyWith<$Res> {
  factory _$SampleFormStateCopyWith(_SampleFormState value, $Res Function(_SampleFormState) _then) = __$SampleFormStateCopyWithImpl;
@override @useResult
$Res call({
 Field<String> fullName, Field<String> email, Field<String> password, BlocStatus status
});




}
/// @nodoc
class __$SampleFormStateCopyWithImpl<$Res>
    implements _$SampleFormStateCopyWith<$Res> {
  __$SampleFormStateCopyWithImpl(this._self, this._then);

  final _SampleFormState _self;
  final $Res Function(_SampleFormState) _then;

/// Create a copy of SampleFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? status = null,}) {
  return _then(_SampleFormState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as Field<String>,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as Field<String>,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as Field<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,
  ));
}


}

// dart format on
