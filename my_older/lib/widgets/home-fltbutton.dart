import 'package:flutter/material.dart';

import '../managers/safe-file-manager.dart';
import 'package:provider/provider.dart';

class HomeFloatingActionButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FloatingActionButton(
      onPressed: () {
        SafeFileManager.of(context, listen: false).importNewFile();
      },
      backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
      child: Icon(
        Icons.add,
        size: theme.primaryIconTheme.size + 10,
        color: theme.primaryIconTheme.color,
      ),
      splashColor: theme.floatingActionButtonTheme.splashColor,
    );
  }
}