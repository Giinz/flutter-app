import 'package:flutter/material.dart';
import 'package:flutter_new_app/utilities/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDiaglog(
    context: context,
    title: 'Log out',
    content: 'Are you sure you want to log out?',
    optionBuilder: () => {'Cancel': false, 'Logout': true},
  ).then((value) => value ?? false);
}
