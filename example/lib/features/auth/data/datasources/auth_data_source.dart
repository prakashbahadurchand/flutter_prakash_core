import 'package:injectable/injectable.dart';
import 'package:flutter_prakash_example/features/auth/data/models/user_model.dart';

@lazySingleton
class AuthDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    if (email.contains('fail')) {
      throw Exception('Invalid email or password credentials');
    }

    return UserModel(
      id: 'usr_89231',
      email: email,
      name: 'Prakash Developer',
      avatarUrl: 'https://i.pravatar.cc/150?u=$email',
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));

    return UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: name,
      token: 'jwt_mock_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }
}
