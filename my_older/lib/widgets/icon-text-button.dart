/// Created by gabriele on 14/04/21
/// Stateless widget template

import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  // Widget text
  final String text;

  // Widget contents
  final Icon icon;

  // Function to call when the button is pressed
  final void Function() callback;

  // Background color of this button
  final Color background;

  // Foreground color of this button
  final Color foreground;

  // Border color of this button
  final Color border;

  /// Creates a new instance of a IconTextButton widget
  ///
  /// [text] The text of this widget
  /// [icon] The icon of this widget
  /// [callback] The function to call when this button is pressed
  /// [border] The border color of this button
  /// [background] The background color of this button
  /// [foreground] The foreground color of this button used for text
  IconTextButton({
    Key key,
    @required this.text,
    @required this.icon,
    this.callback,
    this.border,
    this.background,
    this.foreground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1.5,
          color: (border != null) ? border : Theme.of(context).primaryColor,
        ),
        borderRadius: const BorderRadius.all(
          const Radius.circular(30),
        ),
      ),
      color: (background != null)
          ? background
          : Theme.of(context).appBarTheme.color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          if (icon != null)
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: icon,
            ),
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Text(
              text,
              style: TextStyle(
                color: (foreground != null)
                    ? foreground
                    : Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      onPressed: callback,
    );
  }
}
