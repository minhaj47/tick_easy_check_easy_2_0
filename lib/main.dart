import 'package:tick_easy_check_easy_2_0/features/qr_scanner/screen/qr_screen.dart';
import 'package:tick_easy_check_easy_2_0/features/user/user_screen.dart';
import 'package:tick_easy_check_easy_2_0/features/auth/screens/auth_screen.dart';
import 'package:tick_easy_check_easy_2_0/features/auth/services/auth_services.dart';
import 'package:tick_easy_check_easy_2_0/models/jwt_payload.dart';
import 'package:tick_easy_check_easy_2_0/provider/auth_provider.dart';
import 'package:tick_easy_check_easy_2_0/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'material-theme/theme.dart';
import 'material-theme/util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (context) => AuthProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthServices authServices = AuthServices();
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    await authServices.getData(context);
    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Actor", "Asap");

    MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'TickEasy - CheckeOut Easy',
      debugShowCheckedModeBanner: false,
      //theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      theme: theme.light(),
      onGenerateRoute: (routeSettings) => generateRoute(routeSettings),
      home: _isInitializing
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Provider.of<AuthProvider>(context).isAuthenticated
          ? Provider.of<AuthProvider>(context).jwtPayload.role == Role.ORGANIZER
                ? const QrScannerScreen()
                : const UserScreen()
          : const AuthScreen(),
      // : const QrScannerScreen(),
    );
  }
}
