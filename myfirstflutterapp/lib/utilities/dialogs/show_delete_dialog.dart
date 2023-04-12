import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: 'Atention',
      content: 'Are uu sure u want to delete this note?',
      optionsBuilder: () => {
            'Cancel': false,
            'Delete': true,
          }).then((value) => value ?? false);
}
