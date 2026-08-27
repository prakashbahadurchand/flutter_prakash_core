import 'package:equatable/equatable.dart';

class AuthTokenModel extends Equatable {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;

  const AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    this.tokenType = 'Bearer',
    this.expiresIn = 86400,
  });

  @override
  List<Object?> get props => [accessToken, refreshToken, tokenType, expiresIn];
}
