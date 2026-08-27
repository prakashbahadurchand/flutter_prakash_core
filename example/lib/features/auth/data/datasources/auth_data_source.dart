import 'package:flutter_prakash_core_example/features/auth/data/models/login_request_dto.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/register_request_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_prakash_core_example/features/auth/data/models/user_model.dart';

@lazySingleton
class AuthDataSource {
  Future<UserModel> login(LoginRequestDto dto) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (dto.email.contains('fail')) {
      throw Exception('Invalid email or password credentials');
    }

    return UserModel(
      id: 'usr_89231',
      email: dto.email,
      name: 'Prakash Developer',
      avatarUrl: 'https://i.pravatar.cc/150?u=${dto.email}',
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<UserModel> register(RegisterRequestDto dto) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    return UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: dto.email,
      name: dto.fullName,
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
