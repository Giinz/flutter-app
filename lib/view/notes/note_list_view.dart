import 'package:flutter/material.dart';
import 'package:flutter_new_app/services/cloud/cloud_note.dart';
import 'package:flutter_new_app/utilities/dialogs/delete_dialog.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NoteListView extends StatelessWidget {
  final Iterable<CloudNote> noteList;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  const NoteListView({
    super.key,
    required this.noteList,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (context, index) {
        final note = noteList.elementAt(index);
        return ListTile(
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              final shouldelete = await showDeleteDialog(context);
              if (shouldelete) {
                onDeleteNote(note);
              }
            },
            icon: const Icon(Icons.delete),
          ),
          onTap: () {
            onTap(note);
          },
        );
      },
    );
  }
}
