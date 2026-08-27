import 'package:equatable/equatable.dart';

class AuthUserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? avatarUrl;
  final bool isEmailVerified;
  final DateTime createdAt;

  const AuthUserModel({
    required this.id,
    required this.email,
    required this.name,
    this.avatarUrl,
    this.isEmailVerified = false,
    required this.createdAt,
  });

  AuthUserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? avatarUrl,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    email,
    name,
    avatarUrl,
    isEmailVerified,
    createdAt,
  ];
}
