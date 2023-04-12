import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/utilities/dialogs/generic_dialog.dart';

Future<void> showSuccessDialog(BuildContext context, String text) {
  return showGenericDialog(
      context: context,
      title: 'Success',
      content: text,
      optionsBuilder: () => {
            'OK': null,
          });
}
