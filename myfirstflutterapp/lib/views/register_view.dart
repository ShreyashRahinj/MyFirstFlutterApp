import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstflutterapp/constants/routes.dart';
import 'package:myfirstflutterapp/services/auth/auth_exceptions.dart';
import 'package:myfirstflutterapp/services/auth/auth_service.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_bloc.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_event.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_state.dart';
import 'package:myfirstflutterapp/utilities/dialogs/show_error_dialog.dart';
import 'package:myfirstflutterapp/utilities/dialogs/show_success_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(context, 'Weak Password');
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(context, 'Email Already in Use');
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(context, 'Invalid Email');
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(context, 'Failde to Register');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register"),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        body: Container(
          color: const Color.fromARGB(255, 46, 49, 51),
          child: Column(
            children: [
              const SizedBox(
                height: 103,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid, color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          enableSuggestions: false,
                          autocorrect: false,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Enter your email here",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          controller: _email,
                          cursorColor: Colors.white,
                        ),
                        TextField(
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          style: const TextStyle(
                              color: Colors.white,
                              decorationColor: Colors.white),
                          decoration: const InputDecoration(
                            hintText: "Enter your password here",
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          controller: _password,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventRegister(email, password));
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                child: const Text("Register"),
              ),
              TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthEventLogout());
                  },
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white)),
                  child: const Text("Already have an account? Login Here"))
            ],
          ),
        ),
      ),
    );
  }
}
