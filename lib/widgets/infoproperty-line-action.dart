import 'package:flutter/material.dart';
import 'infoproperty-line.dart';

class InfoPropertyLineAction extends StatefulWidget {
  // Property name
  final String name;

  // Property value
  final String value;

  // Icon to use for the actionIcon
  final Icon actionIcon;

  // Widget to overdraw the current widget when action pressed
  final Widget overlayWidget;

  // Icon for the overlay
  final Icon overlayIcon;

  // Function to call when the action is performed
  final void Function(String, String) onActionPerformed;

  // Function to call when the overlay returns to normal view
  final void Function(String, String) onOverlayPerformed;

  /// Creates a new instance of a property line information with a button
  ///
  /// The InfoPropertyLineAction class represents an information about a logical object with a button
  /// to perform an action. <br>
  /// [name] The name of the parameter <br>
  /// [value] The value of the parameter <br>
  /// [overlayWidget] A widget to show when the button is pressed replacing the value widget <br>
  /// [actionIcon] An icon to set for the action button after the property value <br>
  /// [overlayIcon] An icon to set during the overlay phase of the widget <br>
  /// [onActionPerformed] The function to call when the action is performed <br>
  /// [onOverlayPerformed] The function to call when the overlay widget is hidden and the value widget is shown
  InfoPropertyLineAction(
      {@required this.name,
      @required this.value,
      this.actionIcon,
      this.onOverlayPerformed,
      this.onActionPerformed,
      this.overlayIcon,
      this.overlayWidget});

  @override
  State<StatefulWidget> createState() => _InfoPropertyLineActionState(
        name: name,
        value: value,
        actionIcon: actionIcon,
        overlay: overlayWidget,
        overlayIcon: overlayIcon,
        onActionPerformed: onActionPerformed,
        onOverlayPerformed: onOverlayPerformed,
      );
}

class _InfoPropertyLineActionState extends State<InfoPropertyLineAction> {
  // Property name
  String _name;

  // Property value
  String _value;

  // Icon to use for the actionIcon
  Icon _actionIcon;

  // Widget to overdraw the current widget when action pressed
  Widget _overlayWidget;

  // Status of the overlay
  bool _overlay = false;

  // Icon to show during overlay
  Icon _overlayIcon;

  void Function(String, String) _onActionPerformed;

  void Function(String, String) _onOverlayPerformed;

  _InfoPropertyLineActionState(
      {String name,
      String value,
      Icon actionIcon,
      Widget overlay,
      Icon overlayIcon,
      void Function(String, String) onActionPerformed,
      void Function(String, String) onOverlayPerformed}) {
    _name = name;
    _value = value;
    _actionIcon = actionIcon;
    _overlayWidget = overlay;
    _overlayIcon = overlayIcon;
    _onActionPerformed = onActionPerformed;
    _onOverlayPerformed = onOverlayPerformed;
  }

  /// Called when an action is performed from the action-button
  void onActionPerformed() {
    if (_overlayWidget != null) {
      setState(() {
        // Invert state of overlay
        _overlay = !_overlay;

        // Check function to call
        if (_overlay == true) {
          if (_onActionPerformed != null) {
            // Call function pointer
            _onActionPerformed(_name, _value);
          }
        } else {
          if (_onOverlayPerformed != null) {
            _onOverlayPerformed(_name, _value);
          }
        }
      });
    } else {
      // Call function pointer
      _onActionPerformed(_name, _value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _name,
            style: InfoPropertyLine.nameStyle,
            textAlign: TextAlign.center,
          ),
          _overlay == false
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: Text(
                      _value,
                      style: InfoPropertyLine.valueStyle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 5),
                    child: _overlayWidget,
                  ),
                ),
          if (_actionIcon != null && !_overlay)
            IconButton(
              icon: _actionIcon,
              onPressed: onActionPerformed,
            )
          else if (_overlayIcon != null && _overlay)
            IconButton(
              icon: _overlayIcon,
              onPressed: onActionPerformed,
            ),
        ],
      ),
    );
  }
}
