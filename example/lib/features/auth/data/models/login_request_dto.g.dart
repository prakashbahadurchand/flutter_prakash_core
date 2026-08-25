// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginRequestDtoImpl _$$LoginRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$LoginRequestDtoImpl(
  email: json['email'] as String,
  password: json['password'] as String,
  rememberMe: json['rememberMe'] as bool? ?? false,
);

Map<String, dynamic> _$$LoginRequestDtoImplToJson(
  _$LoginRequestDtoImpl instance,
) => <String, dynamic>{
  'email': instance.email,
  'password': instance.password,
  'rememberMe': instance.rememberMe,
};
