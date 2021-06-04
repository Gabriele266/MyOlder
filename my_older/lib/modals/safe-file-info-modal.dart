import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constructs/safe-file.dart';
import '../widgets/textual/infoproperty-line.dart';

class SafeFileInfoModal extends StatelessWidget {
  // TODO: Make this width responsive in landscape mode
  @override
  Widget build(BuildContext context) {
    // Simplify
    final media = MediaQuery.of(context);
    // final theme = Theme.of(context);

    return Container(
      width: media.size.width,
      height: media.size.height * 0.4,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: media.size.height * 0.02),
          child: Column(
            children: [
              _buildCollapseIconButton(context),
              _buildHeadingTitle(context),
              ..._buildPropertiesList(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the modal heading title
  Widget _buildHeadingTitle(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'File details',
      style: theme.textTheme.headline1,
    );
  }

  /// Builds the properties of this [safeFile] into a list.
  List<Widget> _buildPropertiesList(BuildContext context) {
    final safeFile = SafeFile.of(context);
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return [
      InfoPropertyLine(name: 'Name', value: safeFile.name),
      InfoPropertyLine(name: 'Description', value: safeFile.description!),
      Divider(
        color: theme.primaryColorDark,
        height: media.size.height * 0.02,
        indent: media.size.width * 0.1,
        endIndent: media.size.width * 0.1,
        thickness: 1,
      ),
      InfoPropertyLine(
          name: 'Added on', value: DateFormat.yMd().format(safeFile.dateTime)),
      InfoPropertyLine(name: 'Extension', value: safeFile.suffix),
    ];
  }

  /// Builds the [IconButton] to hide this modal dialog from a single click
  ///
  /// [context] The actual build context
  Widget _buildCollapseIconButton(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () => _hideThis(context),
      icon: Icon(
        Icons.expand_less,
        size: theme.primaryIconTheme.size! + 20,
      ),
    );
  }

  /// Hides this [SafeFileInfoModal]
  void _hideThis(BuildContext context) {
    Navigator.of(context).pop();
  }
}
