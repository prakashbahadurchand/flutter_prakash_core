// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedState<T,F> {

 String get searchQuery; F? get filter; BlocStatus get status; int get totalLoaded; bool get isLastPage;
/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedStateCopyWith<T, F, PaginatedState<T, F>> get copyWith => _$PaginatedStateCopyWithImpl<T, F, PaginatedState<T, F>>(this as PaginatedState<T, F>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedState<T, F>&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.filter, filter)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalLoaded, totalLoaded) || other.totalLoaded == totalLoaded)&&(identical(other.isLastPage, isLastPage) || other.isLastPage == isLastPage));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,const DeepCollectionEquality().hash(filter),status,totalLoaded,isLastPage);

@override
String toString() {
  return 'PaginatedState<$T, $F>(searchQuery: $searchQuery, filter: $filter, status: $status, totalLoaded: $totalLoaded, isLastPage: $isLastPage)';
}


}

/// @nodoc
abstract mixin class $PaginatedStateCopyWith<T,F,$Res>  {
  factory $PaginatedStateCopyWith(PaginatedState<T, F> value, $Res Function(PaginatedState<T, F>) _then) = _$PaginatedStateCopyWithImpl;
@useResult
$Res call({
 String searchQuery, F? filter, BlocStatus status, int totalLoaded, bool isLastPage
});




}
/// @nodoc
class _$PaginatedStateCopyWithImpl<T,F,$Res>
    implements $PaginatedStateCopyWith<T, F, $Res> {
  _$PaginatedStateCopyWithImpl(this._self, this._then);

  final PaginatedState<T, F> _self;
  final $Res Function(PaginatedState<T, F>) _then;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? searchQuery = null,Object? filter = freezed,Object? status = null,Object? totalLoaded = null,Object? isLastPage = null,}) {
  return _then(_self.copyWith(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as F?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,totalLoaded: null == totalLoaded ? _self.totalLoaded : totalLoaded // ignore: cast_nullable_to_non_nullable
as int,isLastPage: null == isLastPage ? _self.isLastPage : isLastPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedState].
extension PaginatedStatePatterns<T,F> on PaginatedState<T, F> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedState<T, F> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedState<T, F> value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedState<T, F> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String searchQuery,  F? filter,  BlocStatus status,  int totalLoaded,  bool isLastPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedState() when $default != null:
return $default(_that.searchQuery,_that.filter,_that.status,_that.totalLoaded,_that.isLastPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String searchQuery,  F? filter,  BlocStatus status,  int totalLoaded,  bool isLastPage)  $default,) {final _that = this;
switch (_that) {
case _PaginatedState():
return $default(_that.searchQuery,_that.filter,_that.status,_that.totalLoaded,_that.isLastPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String searchQuery,  F? filter,  BlocStatus status,  int totalLoaded,  bool isLastPage)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedState() when $default != null:
return $default(_that.searchQuery,_that.filter,_that.status,_that.totalLoaded,_that.isLastPage);case _:
  return null;

}
}

}

/// @nodoc


class _PaginatedState<T,F> extends PaginatedState<T, F> {
  const _PaginatedState({this.searchQuery = '', this.filter, this.status = const BlocStatus.initial(), this.totalLoaded = 0, this.isLastPage = false}): super._();
  

@override@JsonKey() final  String searchQuery;
@override final  F? filter;
@override@JsonKey() final  BlocStatus status;
@override@JsonKey() final  int totalLoaded;
@override@JsonKey() final  bool isLastPage;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedStateCopyWith<T, F, _PaginatedState<T, F>> get copyWith => __$PaginatedStateCopyWithImpl<T, F, _PaginatedState<T, F>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedState<T, F>&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&const DeepCollectionEquality().equals(other.filter, filter)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalLoaded, totalLoaded) || other.totalLoaded == totalLoaded)&&(identical(other.isLastPage, isLastPage) || other.isLastPage == isLastPage));
}


@override
int get hashCode => Object.hash(runtimeType,searchQuery,const DeepCollectionEquality().hash(filter),status,totalLoaded,isLastPage);

@override
String toString() {
  return 'PaginatedState<$T, $F>(searchQuery: $searchQuery, filter: $filter, status: $status, totalLoaded: $totalLoaded, isLastPage: $isLastPage)';
}


}

/// @nodoc
abstract mixin class _$PaginatedStateCopyWith<T,F,$Res> implements $PaginatedStateCopyWith<T, F, $Res> {
  factory _$PaginatedStateCopyWith(_PaginatedState<T, F> value, $Res Function(_PaginatedState<T, F>) _then) = __$PaginatedStateCopyWithImpl;
@override @useResult
$Res call({
 String searchQuery, F? filter, BlocStatus status, int totalLoaded, bool isLastPage
});




}
/// @nodoc
class __$PaginatedStateCopyWithImpl<T,F,$Res>
    implements _$PaginatedStateCopyWith<T, F, $Res> {
  __$PaginatedStateCopyWithImpl(this._self, this._then);

  final _PaginatedState<T, F> _self;
  final $Res Function(_PaginatedState<T, F>) _then;

/// Create a copy of PaginatedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? searchQuery = null,Object? filter = freezed,Object? status = null,Object? totalLoaded = null,Object? isLastPage = null,}) {
  return _then(_PaginatedState<T, F>(
searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,filter: freezed == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as F?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BlocStatus,totalLoaded: null == totalLoaded ? _self.totalLoaded : totalLoaded // ignore: cast_nullable_to_non_nullable
as int,isLastPage: null == isLastPage ? _self.isLastPage : isLastPage // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
