import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/src/features/auth/data/datasources/auth_data_source.dart';
import 'package:flutter_prakash_example/src/features/auth/data/models/user_model.dart';

@lazySingleton
class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  Future<Result<UserModel>> login({
    required String email,
    required String password,
  }) {
    return Result.fromAsync(
      call: () => _dataSource.login(email: email, password: password),
    );
  }

  Future<Result<UserModel>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return Result.fromAsync(
      call: () =>
          _dataSource.register(name: name, email: email, password: password),
    );
  }
}
