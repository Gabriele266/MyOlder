/// Created by gabriele on 13/04/21
/// Project myolder
import 'package:flutter/material.dart';

class DrawerLongButton extends StatelessWidget {
  String _text;
  void Function() _callBack;
  Icon _icon;

  DrawerLongButton({Icon icon, String text, void Function() callBack}) {
    _text = text;
    _callBack = callBack;
    _icon = icon;
  }

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
        children: [
      Expanded(
          child: MaterialButton(
              onPressed: _callBack,
              color: Theme.of(context).canvasColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (_icon != null)
                    Padding(
                      child: _icon,
                      padding: EdgeInsets.only(right: 20),
                    ),
                  Text(
                    _text,
                  ),
                ],
              ))),
    ]);
  }
}
