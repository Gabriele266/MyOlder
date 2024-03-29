import 'package:flutter/material.dart';

import '../providers/user-file-manager.dart';
import '../widgets/drawer-components/myolder-user-widget.dart';
import '../widgets/tools-action.dart';

// TODO: Implement callbacks
class UserToolsPage extends StatelessWidget {
  static const String routeName = '/user/tools';

  const UserToolsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User tools',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: media.size.width * 0.05,
            vertical: media.size.height * 0.05),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            MyOlderUserWidget.disabled(),
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
      height: media.size.height * 0.6,
      child: GridView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: media.size.height * 0.05),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: media.size.height * 0.22,
          mainAxisExtent: media.size.width * 0.22,
          crossAxisSpacing: media.size.width * 0.10,
          mainAxisSpacing: media.size.width * 0.10,
        ),
        children: [
          ToolAction(
            title: 'Delete user',
            backgroundColor: theme.primaryColorLight,
            onPressed: () => _onDeleteUser(context),
          ),
          ToolAction(
            title: 'Logout',
            backgroundColor: theme.primaryColorLight.withBlue(100),
            onPressed: () => UserFileManager.of(context).logout(),
          ),
          ToolAction(
            title: 'Change password',
            backgroundColor: theme.primaryColorLight.withRed(20),
          ),
          ToolAction(
            title: 'Change username',
            backgroundColor: theme.primaryColorLight.withGreen(110),
          ),
          ToolAction(
            title: 'User details',
            backgroundColor: theme.primaryColorLight.withBlue(20),
          ),
        ],
      ),
    );
  }

  // TODO: Implement _onUserDetails
  void _onUserDetails() {}

  // TODO: Implement _onChangeUserName
  void _onChangeUserName() {}

  // TODO: Implement _onChangePassword
  void _onChangePassword() {}

  /// Deletes the current user
  void _onDeleteUser(BuildContext context) {
    // Check if user agrees
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Remove ${UserFileManager.of(context).user.name}?'),
        content: const Text(
            'The user will be completely removed. He won\'t be able to access this data and all the files will be lost. \nAre you shure?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text('Continue'),
            onPressed: () => UserFileManager.of(context).removeUser(),
          ),
        ],
      ),
    );
  }
}
