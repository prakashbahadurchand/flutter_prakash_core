import 'package:flutter_prakash/flutter_prakash.dart';
import 'package:flutter_prakash_example/features/auth/data/datasources/auth_data_source.dart';
import 'package:flutter_prakash_example/features/auth/data/models/login_request_dto.dart';
import 'package:flutter_prakash_example/features/auth/data/models/register_request_dto.dart';
import 'package:flutter_prakash_example/features/auth/data/models/user_model.dart';

@lazySingleton
class AuthRepository {
  final AuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  FutureResult<UserModel> login(LoginRequestDto dto) {
    return Result.fromAsync(call: () => _dataSource.login(dto));
  }

  Future<Result<UserModel>> register(RegisterRequestDto dto) {
    return Result.fromAsync(call: () => _dataSource.register(dto));
  }
}
