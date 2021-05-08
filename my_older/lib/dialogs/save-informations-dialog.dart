import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class SaveInformationsDialog extends StatelessWidget {
  // Function to call when the dialog is accepted
  final void Function() onDialogAccepted;

  // Function to call when the dialog is canceled
  final void Function() onDialogCanceled;

  // The message content
  final String content;
  // The message title
  final String title;

  /// Creates a new [SaveInformationsDialog] to display a dialog
  /// before saving some informations. 
  SaveInformationsDialog({@required this.content, @required this.title, this.onDialogAccepted, this.onDialogCanceled});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
      ),
      content: Text(content),
      actions: [
        TextButton(
          child: const Text('Save'),
          onPressed: onDialogAccepted,
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: onDialogCanceled,
        ),
      ],
    );
  }
}
