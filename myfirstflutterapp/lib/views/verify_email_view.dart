import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/constants/routes.dart';
import 'package:myfirstflutterapp/services/auth/auth_service.dart';

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
              onPressed: () async {
                await AuthService.firebase().sendEmailVerification();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(loginroute, (route) => false);
              },
              child: const Text("Send emial verification")),
          TextButton(
            onPressed: () async {
              await AuthService.firebase().logOut();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerroute, (route) => false);
            },
            child: const Text("Restart"),
          )
        ],
      ),
    );
  }
}
