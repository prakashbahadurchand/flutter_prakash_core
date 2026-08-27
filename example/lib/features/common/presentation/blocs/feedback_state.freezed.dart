// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feedback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$FeedbackState {
  Field<String> get email => throw _privateConstructorUsedError;
  Field<String> get feedback => throw _privateConstructorUsedError;
  BlocStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeedbackStateCopyWith<FeedbackState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackStateCopyWith<$Res> {
  factory $FeedbackStateCopyWith(
    FeedbackState value,
    $Res Function(FeedbackState) then,
  ) = _$FeedbackStateCopyWithImpl<$Res, FeedbackState>;
  @useResult
  $Res call({Field<String> email, Field<String> feedback, BlocStatus status});
}

/// @nodoc
class _$FeedbackStateCopyWithImpl<$Res, $Val extends FeedbackState>
    implements $FeedbackStateCopyWith<$Res> {
  _$FeedbackStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? feedback = null,
    Object? status = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as Field<String>,
            feedback: null == feedback
                ? _value.feedback
                : feedback // ignore: cast_nullable_to_non_nullable
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
abstract class _$$FeedbackStateImplCopyWith<$Res>
    implements $FeedbackStateCopyWith<$Res> {
  factory _$$FeedbackStateImplCopyWith(
    _$FeedbackStateImpl value,
    $Res Function(_$FeedbackStateImpl) then,
  ) = __$$FeedbackStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Field<String> email, Field<String> feedback, BlocStatus status});
}

/// @nodoc
class __$$FeedbackStateImplCopyWithImpl<$Res>
    extends _$FeedbackStateCopyWithImpl<$Res, _$FeedbackStateImpl>
    implements _$$FeedbackStateImplCopyWith<$Res> {
  __$$FeedbackStateImplCopyWithImpl(
    _$FeedbackStateImpl _value,
    $Res Function(_$FeedbackStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? feedback = null,
    Object? status = null,
  }) {
    return _then(
      _$FeedbackStateImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as Field<String>,
        feedback: null == feedback
            ? _value.feedback
            : feedback // ignore: cast_nullable_to_non_nullable
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

class _$FeedbackStateImpl extends _FeedbackState {
  const _$FeedbackStateImpl({
    required this.email,
    required this.feedback,
    this.status = const BlocStatus.initial(),
  }) : super._();

  @override
  final Field<String> email;
  @override
  final Field<String> feedback;
  @override
  @JsonKey()
  final BlocStatus status;

  @override
  String toString() {
    return 'FeedbackState(email: $email, feedback: $feedback, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeedbackStateImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, email, feedback, status);

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeedbackStateImplCopyWith<_$FeedbackStateImpl> get copyWith =>
      __$$FeedbackStateImplCopyWithImpl<_$FeedbackStateImpl>(this, _$identity);
}

abstract class _FeedbackState extends FeedbackState {
  const factory _FeedbackState({
    required final Field<String> email,
    required final Field<String> feedback,
    final BlocStatus status,
  }) = _$FeedbackStateImpl;
  const _FeedbackState._() : super._();

  @override
  Field<String> get email;
  @override
  Field<String> get feedback;
  @override
  BlocStatus get status;

  /// Create a copy of FeedbackState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeedbackStateImplCopyWith<_$FeedbackStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
