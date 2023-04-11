import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/constants/routes.dart';
import 'package:myfirstflutterapp/services/auth/auth_service.dart';
import 'package:myfirstflutterapp/views/login_view.dart';
import 'package:myfirstflutterapp/views/notes/new_note_view.dart';
import 'package:myfirstflutterapp/views/notes/notes_view.dart';
import 'package:myfirstflutterapp/views/register_view.dart';
import 'package:myfirstflutterapp/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginroute: (context) => const LoginView(),
        registerroute: (context) => const RegisterView(),
        verifyemailroute: (context) => const VerifyEmailView(),
        notesroute: (context) => const NotesView(),
        newnoteroute: (context) => const NewNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initializeApp(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerified) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
            default:
              return Scaffold(
                appBar: AppBar(title: const Text("Loading ...")),
                body: const Center(child: CircularProgressIndicator()),
              );
          }
        });
  }
}
