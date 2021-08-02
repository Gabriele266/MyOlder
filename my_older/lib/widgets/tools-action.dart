import 'package:flutter/material.dart';

class ToolAction extends StatelessWidget {
  /// The title of the widget (displayed into the center of it)
  final String title;

  /// The function to call when the widget is pressed
  final void Function() onPressed;

  /// The background color to apply
  final Color backgroundColor;

  /// The text color for this widget
  final Color foregroundColor;

  /// The icon to display at the end of the widget
  final IconData icon;

  /// Creates a new [ToolAction] widget
  const ToolAction({
    Key key,
    @required this.title,
    this.foregroundColor,
    this.backgroundColor,
    this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: theme.primaryColorDark,
            width: 1,
          ),
        ),
        child: GridTile(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: media.size.height * 0.021,
              horizontal: media.size.width * 0.02,
            ),
            child: Text(
              title,
              style: TextStyle(
                color: foregroundColor,
              ),
            ),
          ),
          footer: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(media.size.width * 0.02),
              child: Icon(
                icon,
                color: theme.errorColor,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
