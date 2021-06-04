/// Created by gabriele on 13/04/21
/// Project myolder
import 'package:flutter/material.dart';

class DrawerListTileButton extends StatelessWidget {
  final String text;
  final void Function() callBack;
  final IconData icon;

  /// Creates new instance of a DrawerLongButton
  ///
  /// It represents a long button with some properties
  /// [text] The text of the button
  /// [icon] The icon data of the button (for color and size is used the [accentIconTheme])
  /// [callBack] The callback of the button
  DrawerListTileButton({
    Key key,
    @required this.text,
    this.callBack,
    this.icon,
  }) : super(key: key);

  // TODO: Make this widget responsive
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Container(
      height: media.size.height * 0.06,
      margin: EdgeInsets.symmetric(
        horizontal: media.size.width * 0.05,
        vertical: media.size.height * 0.010,
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: theme.primaryColorDark,
            width: 2 * media.textScaleFactor,
          ),
          borderRadius: BorderRadius.circular(media.size.width * 0.03),
        ),
        tileColor: theme.primaryColor,
        onTap: callBack,
        leading: Icon(
          icon,
          size: theme.accentIconTheme.size + (10 * media.textScaleFactor),
          color: theme.accentIconTheme.color,
        ),
        title: Text(
          '$text',
          style: theme.textTheme.headline3,
        ),
      ),
    );
  }
}
