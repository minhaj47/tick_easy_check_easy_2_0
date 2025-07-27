import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';

enum Role { ADMIN, USER, ORGANIZER }

class JwtPayload {
  String id;
  String? name;
  String email;
  Role role;

  JwtPayload({
    required this.id,
    this.name,
    required this.email,
    required this.role,
  });

  factory JwtPayload.fromMap(Map<String, dynamic> map) {
    return JwtPayload(
      id: map['id'] ?? '',
      name: map['name'],
      email: map['email'] ?? '',
      role: Role.values.firstWhere(
        (e) => e.toString() == 'Role.${map['role'] as String?}',
        orElse: () => Role.USER,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.toString().split('.').last,
    };
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory JwtPayload.fromJson(String token) {
    final Map<String, dynamic> jsonMap = Jwt.parseJwt(token);
    return JwtPayload.fromMap(jsonMap);
  }
}
