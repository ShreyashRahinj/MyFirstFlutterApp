import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/constants/routes.dart';
import 'package:myfirstflutterapp/services/auth/auth_exceptions.dart';
import 'package:myfirstflutterapp/services/auth/auth_service.dart';

import '../utilities/show_error_dialog.dart';
import '../utilities/show_success_dialog.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          TextField(
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: "Enter your email here"),
            controller: _email,
          ),
          TextField(
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration:
                const InputDecoration(hintText: "Enter your password here"),
            controller: _password,
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await AuthService.firebase()
                    .logIn(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user != null) {
                  if (user.isEmailVerified) {
                    await showSuccessDialog(context, "Login Successful");
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(notesroute, (route) => false);
                  } else {
                    await showSuccessDialog(context,
                        "Login Successful but you need to verify your Email");
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        verifyemailroute, (route) => false);
                  }
                }
              } on UserNotFoundAuthException {
                await showErrorDialog(context, "User not Found");
              } on WrongPasswordAuthException {
                await showErrorDialog(context, "Wrong Password");
              } on GenericAuthException {
                await showErrorDialog(context, 'Authentication Error');
              }
            },
            child: const Text("Login"),
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(registerroute, (route) => false);
              },
              child: const Text("Don't have an account? Register Here"))
        ],
      ),
    );
  }
}
