import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_bloc.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_event.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_state.dart';
import 'package:myfirstflutterapp/utilities/dialogs/password_reset_email_sent_dialog.dart';
import 'package:myfirstflutterapp/utilities/dialogs/show_error_dialog.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            _controller.clear();
            await showPasswordResetDialog(context);
          }
          if (state.exception != null) {
            await showErrorDialog(context,
                'Error while sending password reset mail,You may not be a registered user,Please go back and registre');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reset pasword'),
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
                        style: BorderStyle.solid,
                        color: Colors.white,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        autofocus: true,
                        style: const TextStyle(
                            color: Colors.white, decorationColor: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Enter your registered email adress',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        cursorColor: Colors.white,
                        controller: _controller,
                      ),
                    ]),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  final email = _controller.text;
                  context
                      .read<AuthBloc>()
                      .add(AuthEventForgotPassword(email: email));
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red),
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                child: const Text('Send'),
              ),
              TextButton(
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white)),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
