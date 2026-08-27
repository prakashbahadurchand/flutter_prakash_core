// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sample_form_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SampleFormState {
  Field<String> get fullName => throw _privateConstructorUsedError;
  Field<String> get email => throw _privateConstructorUsedError;
  Field<String> get password => throw _privateConstructorUsedError;
  BlocStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of SampleFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SampleFormStateCopyWith<SampleFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SampleFormStateCopyWith<$Res> {
  factory $SampleFormStateCopyWith(
    SampleFormState value,
    $Res Function(SampleFormState) then,
  ) = _$SampleFormStateCopyWithImpl<$Res, SampleFormState>;
  @useResult
  $Res call({
    Field<String> fullName,
    Field<String> email,
    Field<String> password,
    BlocStatus status,
  });
}

/// @nodoc
class _$SampleFormStateCopyWithImpl<$Res, $Val extends SampleFormState>
    implements $SampleFormStateCopyWith<$Res> {
  _$SampleFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SampleFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
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
abstract class _$$SampleFormStateImplCopyWith<$Res>
    implements $SampleFormStateCopyWith<$Res> {
  factory _$$SampleFormStateImplCopyWith(
    _$SampleFormStateImpl value,
    $Res Function(_$SampleFormStateImpl) then,
  ) = __$$SampleFormStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    Field<String> fullName,
    Field<String> email,
    Field<String> password,
    BlocStatus status,
  });
}

/// @nodoc
class __$$SampleFormStateImplCopyWithImpl<$Res>
    extends _$SampleFormStateCopyWithImpl<$Res, _$SampleFormStateImpl>
    implements _$$SampleFormStateImplCopyWith<$Res> {
  __$$SampleFormStateImplCopyWithImpl(
    _$SampleFormStateImpl _value,
    $Res Function(_$SampleFormStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SampleFormState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fullName = null,
    Object? email = null,
    Object? password = null,
    Object? status = null,
  }) {
    return _then(
      _$SampleFormStateImpl(
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
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as BlocStatus,
      ),
    );
  }
}

/// @nodoc

class _$SampleFormStateImpl extends _SampleFormState {
  const _$SampleFormStateImpl({
    required this.fullName,
    required this.email,
    required this.password,
    this.status = const BlocStatus.initial(),
  }) : super._();

  @override
  final Field<String> fullName;
  @override
  final Field<String> email;
  @override
  final Field<String> password;
  @override
  @JsonKey()
  final BlocStatus status;

  @override
  String toString() {
    return 'SampleFormState(fullName: $fullName, email: $email, password: $password, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SampleFormStateImpl &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, fullName, email, password, status);

  /// Create a copy of SampleFormState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SampleFormStateImplCopyWith<_$SampleFormStateImpl> get copyWith =>
      __$$SampleFormStateImplCopyWithImpl<_$SampleFormStateImpl>(
        this,
        _$identity,
      );
}

abstract class _SampleFormState extends SampleFormState {
  const factory _SampleFormState({
    required final Field<String> fullName,
    required final Field<String> email,
    required final Field<String> password,
    final BlocStatus status,
  }) = _$SampleFormStateImpl;
  const _SampleFormState._() : super._();

  @override
  Field<String> get fullName;
  @override
  Field<String> get email;
  @override
  Field<String> get password;
  @override
  BlocStatus get status;

  /// Create a copy of SampleFormState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SampleFormStateImplCopyWith<_$SampleFormStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
