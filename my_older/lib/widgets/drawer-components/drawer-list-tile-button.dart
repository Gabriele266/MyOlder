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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: media.size.width * 0.08,
        vertical: media.size.height * 0.01,
      ),
      child: ListTile(
        tileColor: theme.primaryColor,
        onTap: callBack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            width: 1,
            color: theme.primaryColorDark,
          ),
        ),
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
