import 'package:flutter/material.dart';

class ClearAllSafeFilesDialog extends StatelessWidget {
  // Called when the user accepts the clearing
  final void Function() onClearAccepted;

/// Creates a new instance of a [ClearAllSafeFilesDialog]
/// 
/// [onClearAccepted] Called when the user accepts the clearing
  ClearAllSafeFilesDialog(this.onClearAccepted);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alert: clear all files?'),
      content: const Text(
          'This operation will remove all your data from the disk, this means that you wont be able to access your files anymore. ARE YOU SHURE??'),
      actions: [
        TextButton(
          child: Text('No'),
          onPressed: () {
            // Remove this alert
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Yes i am shure. '),
          onPressed: onClearAccepted,
        ),
      ],
    );
  }
}
