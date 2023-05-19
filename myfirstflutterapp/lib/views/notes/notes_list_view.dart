import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/services/cloud/cloud_note.dart';
import 'package:myfirstflutterapp/utilities/dialogs/show_delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromARGB(47, 158, 158, 158),
                  border: Border.all(
                    style: BorderStyle.solid,
                    color: Colors.white,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: ListTile(
                textColor: Colors.white,
                title: Text(
                  note.text,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  color: Colors.white,
                  onPressed: () async {
                    final shouldDelete = await showDeleteDialog(context);
                    if (shouldDelete) {
                      onDeleteNote(note);
                    }
                  },
                  icon: const Icon(Icons.delete),
                ),
                onTap: () {
                  onTap(note);
                },
              ),
            ),
          );
        });
  }
}
