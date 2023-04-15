import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Attention',
      content: 'You are trying to share an empty note. You cannot do that',
      optionsBuilder: () => {
            'Ok': null,
          });
}
