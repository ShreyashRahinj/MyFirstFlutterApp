import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myfirstflutterapp/services/auth/auth_service.dart';
import 'package:myfirstflutterapp/services/autocorrect/dl.dart';
import 'package:myfirstflutterapp/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:myfirstflutterapp/utilities/generics/get_arguments.dart';
import 'package:myfirstflutterapp/services/cloud/cloud_note.dart';
import 'package:myfirstflutterapp/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  late List<String> undoStack;
  late List<String> redoStack;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    undoStack = [];
    redoStack = [];
    super.initState();
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetnote = context.getArgument<CloudNote>();
    if (widgetnote != null) {
      _note = widgetnote;
      _textController.text = widgetnote.text;
      return widgetnote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _savenoteIfNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(documentId: note.documentId, text: text);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _savenoteIfNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Note"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              try {
                Share.share(text);
              } catch (_) {
                showCannotShareEmptyNoteDialog(context);
              }
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
              onPressed: () async {
                final String stringData =
                    await rootBundle.loadString("assets/data/data.json");
                final List<dynamic> json = jsonDecode(stringData);
                final List<String> data = json.cast<String>();
                List<String> paragraph = _textController.text.split(" ");
                _textController.text =
                    DL().autocorrectParagraph(paragraph, data);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Color.fromARGB(255, 46, 49, 51)),
        child: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onChanged: (value) {
                        undoStack.add(value);
                      },
                      decoration: const InputDecoration(
                          hintText: "Start typing your text here",
                          hintStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none),
                    ),
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "fab1",
            onPressed: () {
              try {
                _textController.text =
                    undoStack.elementAt(undoStack.length - 2);
                redoStack.add(undoStack.elementAt(undoStack.length - 1));
                undoStack.remove(undoStack.elementAt(undoStack.length - 1));
              } catch (_) {}
            },
            child: const Icon(Icons.undo),
          ),
          FloatingActionButton(
            heroTag: "fab2",
            onPressed: () {
              try {
                _textController.text =
                    redoStack.elementAt(redoStack.length - 1);
                undoStack.add(redoStack.elementAt(redoStack.length - 1));
                redoStack.remove(redoStack.elementAt(redoStack.length - 1));
              } catch (_) {}
            },
            child: const Icon(Icons.redo),
          )
        ],
      ),
    );
  }
}
