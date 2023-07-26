import 'package:flutter/material.dart';
import 'package:flutter_new_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDiaglog(
    context: context,
    title: 'Delete',
    content: 'Are you sure you want to delete this note?',
    optionBuilder: () => {'Cancel': false, 'Yes': true},
  ).then((value) => value ?? false);
}
