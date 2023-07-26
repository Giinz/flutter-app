import 'package:flutter/material.dart';
import 'package:flutter_new_app/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(BuildContext context, String text) async {
  return showGenericDiaglog<void>(
    context: context,
    title: 'An error occurred',
    content: text,
    optionBuilder: () => {'OK': null},
  );
}
