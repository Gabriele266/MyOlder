import 'package:flutter/cupertino.dart';

/// Created by gabriele on 14/04/21
/// Stateless widget template
import 'package:flutter/material.dart';

/// A button with a text and an icon
class IconTextButton extends StatelessWidget {
  String _text;
  Icon _icon;
  void Function() _callback;
  Color _background;
  Color _foreground;
  Color _border;

  /// A button with a text and an icon
  IconTextButton(
      {@required String text,
      @required Icon icon,
      @required void Function() callback,
      Color foreground,
      Color background,
      Color border}) {
    _text = text;
    _icon = icon;
    _callback = callback;
    _foreground = foreground;
    _background = background;
    _border = border;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1.5,
          color: (_border != null) ? _border : Theme.of(context).primaryColor
        ),
        borderRadius: BorderRadius.all(Radius.circular(30))
      ),
      color: (_background != null)
          ? _background
          : Theme.of(context).appBarTheme.color,
      child: Row(
        children: [
          if (_icon != null)
            Padding(padding: EdgeInsets.only(left: 20), child: _icon),
          Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text(_text,
                style: TextStyle(
                    color: (_foreground != null)
                        ? _foreground
                        : Theme.of(context).primaryColor)),
          )
        ],
      ),
      onPressed: _callback,
    );
  }
}
