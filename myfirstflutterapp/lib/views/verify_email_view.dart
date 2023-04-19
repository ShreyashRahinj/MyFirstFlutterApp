import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_bloc.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify your Email"),
      ),
      body: Column(
        children: [
          const Text(
              "We have sent Email verification. Please check your Mailbox"),
          const Text("If you haven't recieved any mail , Click below button"),
          TextButton(
              onPressed: () {
                context
                    .read<AuthBloc>()
                    .add(const AuthEventSendEmailVerification());
              },
              child: const Text("Send emial verification")),
          TextButton(
            onPressed: () {
              context.read<AuthBloc>().add(const AuthEventLogout());
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
