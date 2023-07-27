import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_new_app/constants/routes.dart';
import 'package:flutter_new_app/enums/menu_action.dart';
import 'package:flutter_new_app/services/auth/auth_service.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_new_app/services/auth/bloc/auth_event.dart';
import 'package:flutter_new_app/services/cloud/cloud_note.dart';
import 'package:flutter_new_app/services/cloud/firebase_cloud_storage.dart';
import 'package:flutter_new_app/utilities/dialogs/logout_dialog.dart';
import 'package:flutter_new_app/view/notes/note_list_view.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;
  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    if (!mounted) return;
                    context.read<AuthBloc>().add(const AuthEventLogOut());
                  }
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final Iterable<CloudNote> allNotes = snapshot.data;
                return NoteListView(
                  onTap: (note) {
                    Navigator.of(context).pushNamed(createUpdateNoteRoute, arguments: note);
                  },
                  noteList: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
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
    );
  }
}
