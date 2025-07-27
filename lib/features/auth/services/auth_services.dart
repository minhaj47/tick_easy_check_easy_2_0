// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:tick_easy_check_easy_2_0/provider/auth_provider.dart';
import 'package:tick_easy_check_easy_2_0/features/qr_scanner/screen/qr_screen.dart';

import 'package:tick_easy_check_easy_2_0/Constant/error_handling.dart';
import 'package:tick_easy_check_easy_2_0/Constant/global_variable.dart';
import 'package:tick_easy_check_easy_2_0/Constant/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  void signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse('$uri/api/auth/login');

      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'email': email, 'password': password}),
      );

      log(response.body);

      httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          showSnackBar(context: context, message: 'Login Successful!');

          SharedPreferences pref = await SharedPreferences.getInstance();
          String token = jsonDecode(response.body)['token'];
          log('Token received: $token');
          
          // Save token to SharedPreferences
          await pref.setString('jwt-auth-token', token);
          log('Token saved to SharedPreferences');
          
          // Verify token was saved
          String? savedToken = pref.getString('jwt-auth-token');
          log('Token retrieved from SharedPreferences: $savedToken');
          
          // Set JWT payload and token in provider
          Provider.of<AuthProvider>(
            context,
            listen: false,
          ).setJwtPayload(token);

          Provider.of<AuthProvider>(context, listen: false).setJwtToken(token);
          
          log('AuthProvider updated with token and payload');

          Navigator.pushNamedAndRemoveUntil(
            context,
            QrScannerScreen.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context: context, message: e.toString());
    }
  }

  // get data

  Future<void> getData(BuildContext context) async {
    try {
      log('Starting getData - checking for stored token');
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('jwt-auth-token');

      log('Retrieved token from SharedPreferences: ${token != null && token.isNotEmpty ? "${token.substring(0, 20)}..." : "null or empty"}');

      if (token == null || token.isEmpty) {
        log('No token found, setting empty token');
        await pref.setString('jwt-auth-token', '');
        return;
      }

      log('Verifying token with server...');
      final response = await http.get(
        Uri.parse('$uri/api/auth/verify-token'),
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      log('Token verification response: ${response.statusCode}');
      log('Token verification body: ${response.body}');

      if (response.statusCode == 200) {
        // Set both the JWT payload and token in the provider
        log('Token verification successful, updating provider...');
        Provider.of<AuthProvider>(context, listen: false).setJwtPayload(token);

        Provider.of<AuthProvider>(context, listen: false).setJwtToken(token);

        log('Token verification successful, user authenticated');
      } else {
        // Token is invalid, clear it
        log('Token verification failed with status: ${response.statusCode}, clearing stored token');
        await pref.setString('jwt-auth-token', '');
        Provider.of<AuthProvider>(context, listen: false).clearAuth();
      }
    } catch (e) {
      log('Error in getData: ${e.toString()}');
      // Clear invalid token on error
      try {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.setString('jwt-auth-token', '');
        Provider.of<AuthProvider>(context, listen: false).clearAuth();
      } catch (prefError) {
        log('Error clearing preferences: ${prefError.toString()}');
      }
    }
  }

  // logout method
  void logout(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('jwt-auth-token', '');

      Provider.of<AuthProvider>(context, listen: false).clearAuth();

      log('User logged out successfully');
    } catch (e) {
      log('Error during logout: ${e.toString()}');
    }
  }
}
