import 'package:scorelivepro/models/user_model.dart';

class AuthResponse {
  final String? refresh;
  final String? access;
  final User? user;

  AuthResponse({
    this.refresh,
    this.access,
    this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      refresh: json['refresh'],
      access: json['access'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
      'user': user?.toJson(),
    };
  }
}
