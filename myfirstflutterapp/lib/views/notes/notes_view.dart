import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myfirstflutterapp/constants/routes.dart';
import 'package:myfirstflutterapp/enums/menu_action.dart';
import 'package:myfirstflutterapp/services/auth/auth_service.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_bloc.dart';
import 'package:myfirstflutterapp/services/auth/bloc/auth_event.dart';
import 'package:myfirstflutterapp/services/cloud/firebase_cloud_storage.dart';
import 'package:myfirstflutterapp/utilities/dialogs/show_logout_dialog.dart';
import 'package:myfirstflutterapp/views/notes/notes_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  String search = "";
  late final TextEditingController _controller;
  Widget appbartitle = const Text("Your Notes");

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: appbartitle,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createupdatenoteroute);
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  appbartitle = TextField(
                    autofocus: true,
                    style: const TextStyle(color: Colors.white),
                    controller: _controller,
                    decoration: InputDecoration(
                        prefixIcon: IconButton(
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              appbartitle = const Text("Your Notes");
                            });
                          },
                          icon: const Icon(Icons.close),
                        ),
                        filled: true,
                        fillColor: Colors.black,
                        hintText: "Search...",
                        hintStyle: const TextStyle(color: Colors.white)),
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                  );
                });
              },
              icon: const Icon(Icons.search),
            ),
            PopupMenuButton<MenuAction>(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldlogout = await showLogoutDialog(context);
                    if (shouldlogout) {
                      context.read<AuthBloc>().add(const AuthEventLogout());
                    }
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text("Log Out"),
                  ),
                ];
              },
            )
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 46, 49, 51),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder(
              stream: _notesService.allNotes(ownerUserId: userId),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allNotes = snapshot.data!;
                      return NotesListView(
                        notes: allNotes.where((element) =>
                            element.ownerUserId == userId &&
                            element.text.contains(search)),
                        onDeleteNote: (note) async {
                          await _notesService.deleteNote(
                              documentId: note.documentId);
                        },
                        onTap: (note) {
                          Navigator.of(context).pushNamed(createupdatenoteroute,
                              arguments: note);
                        },
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ));
  }
}
