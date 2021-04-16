/// Created by gabriele on 13/04/21
/// Project myolder
import 'package:flutter/material.dart';

class DrawerLongButton extends StatelessWidget {
  final String text;
  final void Function() callBack;
  final Icon icon;

  /// Creates new instance of a DrawerLongButton
  ///
  /// It represents a long button with some properties
  /// [text] The text of the button
  /// [icon] The icon of the button
  /// [callBack] The callback of the button
  DrawerLongButton({@required this.text, this.callBack, this.icon});

  @override
  Widget build(BuildContext context) {
    return Flex(direction: Axis.horizontal, children: [
      Expanded(
        child: MaterialButton(
          onPressed: callBack,
          color: Theme.of(context).canvasColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (icon != null)
                Padding(
                  child: icon,
                  padding: const EdgeInsets.only(right: 20),
                ),
              Text(
                text,
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
