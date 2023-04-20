import 'package:flutter/material.dart';
import 'package:myfirstflutterapp/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Forgot Password',
      content:
          'Password Reset Mail Sent.Please check your mailbox.tari nahi bhetle tr spam check kr',
      optionsBuilder: () => {'Ok': null});
}
