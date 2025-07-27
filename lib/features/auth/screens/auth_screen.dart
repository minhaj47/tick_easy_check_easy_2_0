import 'package:tick_easy_check_easy_2_0/common/widget/custom_button.dart';
import 'package:tick_easy_check_easy_2_0/common/widget/custom_textfield.dart';
import 'package:tick_easy_check_easy_2_0/features/auth/services/auth_services.dart';
import 'package:flutter/material.dart';

enum Auth { signIn, signUp }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signInKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthServices authServices = AuthServices();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signIn() {
    authServices.signIn(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              Text("Welcome", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 30.0),
              Form(
                key: _signInKey,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      CustomTextfield(
                        controller: _emailController,
                        hintText: 'Enter your Email',
                      ),
                      CustomTextfield(
                        controller: _passwordController,
                        hintText: 'Enter a password',
                      ),
                      CustomButton(
                        lebel: 'Log In',
                        onTap: () {
                          if (_signInKey.currentState!.validate()) {
                            signIn();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
