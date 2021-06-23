import 'package:flutter/material.dart';

import '../providers/user-file-manager.dart';
import '../providers/safe-file-manager.dart';
import '../widgets/drawer-components/myolder-user-widget.dart';

class UserToolsPage extends StatelessWidget {
  static const String routeName = '/user/tools';

  const UserToolsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);
    final userManager = UserFileManager.of(context);
    final safeFileManager = SafeFileManager.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User tools',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MyOlderUserWidget(
              enabled: false,
            ),
            _buildUserTools(context),
          ],
        ),
      ),
    );
  }

  /// Builds the user tools for this page
  Widget _buildUserTools(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return SizedBox(
      height: media.size.height * 0.8,
      child: GridView(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: media.size.height * 0.25,
          mainAxisExtent: media.size.width * 0.25,
        ),
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              
              border: Border.all(
                color: theme.primaryColorDark,
                width: 1,
              ),
            ),
            child: GridTile(
              child: Center(child: const Text('Delete')),
              footer: Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () {
                    // TODO: Implement
                  },
                  icon: Icon(
                    Icons.delete,
                    color: theme.errorColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
