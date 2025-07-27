import 'package:tick_easy_check_easy_2_0/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:tick_easy_check_easy_2_0/features/qr_scanner/screen/qr_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case QrScannerScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const QrScannerScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(body: Text("Error 404!\n Not Found!")),
      );
  }
}
