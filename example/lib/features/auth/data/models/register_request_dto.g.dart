// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RegisterRequestDtoImpl _$$RegisterRequestDtoImplFromJson(
  Map<String, dynamic> json,
) => _$RegisterRequestDtoImpl(
  fullName: json['fullName'] as String,
  email: json['email'] as String,
  password: json['password'] as String,
  role: json['role'] as String,
  acceptTerms: json['acceptTerms'] as bool? ?? false,
);

Map<String, dynamic> _$$RegisterRequestDtoImplToJson(
  _$RegisterRequestDtoImpl instance,
) => <String, dynamic>{
  'fullName': instance.fullName,
  'email': instance.email,
  'password': instance.password,
  'role': instance.role,
  'acceptTerms': instance.acceptTerms,
};
