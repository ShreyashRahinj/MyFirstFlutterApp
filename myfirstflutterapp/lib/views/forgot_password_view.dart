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
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            const Text(
                'If you have forgot your password, simply enter your eail and we will send you a password reset link'),
            TextField(
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              autofocus: true,
              controller: _controller,
              decoration: const InputDecoration(
                  hintText: 'Enter your registered email adress'),
            ),
            TextButton(
              onPressed: () {
                final email = _controller.text;
                context
                    .read<AuthBloc>()
                    .add(AuthEventForgotPassword(email: email));
              },
              child: const Text('Send'),
            ),
            TextButton(
              onPressed: () {
                context.read<AuthBloc>().add(const AuthEventLogout());
              },
              child: const Text('Back to Login'),
            ),
          ]),
        ),
      ),
    );
  }
}
