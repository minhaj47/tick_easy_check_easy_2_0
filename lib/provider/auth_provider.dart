import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tick_easy_check_easy_2_0/models/jwt_payload.dart';

class AuthProvider extends ChangeNotifier {
  // change notifier is for notifying the consumers
  // Organization _organization = Organization(
  //   id: '',
  //   name: '',
  //   email: '',
  //   description: '',
  //   address: '',
  //   logoUrl: '',
  //   phone: '',
  //   websiteUrl: '',
  // );

  // Organization get organization => _organization;

  // void setOrg(String orgJson) {
  //   _organization = Organization.fromJson(orgJson);
  //   notifyListeners();
  // }

  JwtPayload _jwtPayload = JwtPayload(
    id: '',
    name: '',
    email: '',
    role: Role.USER,
  );

  JwtPayload get jwtPayload => _jwtPayload;

  void setJwtPayload(String token) {
    // Decode the JWT token to get the payload
    _jwtPayload = JwtPayload.fromJson(token);
    log('JWT Payload: ${_jwtPayload.toJson()}');
    notifyListeners();
  }

  String _token = '';

  String get jwtToken => _token;

  void setJwtToken(String token) {
    _token = token;
    notifyListeners();
  }

  void clearAuth() {
    _jwtPayload = JwtPayload(
      id: '',
      name: '',
      email: '',
      role: Role.USER,
    );
    _token = '';
    notifyListeners();
  }

  bool get isAuthenticated => _jwtPayload.id.isNotEmpty && _token.isNotEmpty;
}
