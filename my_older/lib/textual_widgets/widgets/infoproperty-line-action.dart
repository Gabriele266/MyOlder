import 'package:flutter/material.dart';

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
  InfoPropertyLineAction({
    Key key,
    @required this.name,
    @required this.value,
    this.actionIcon,
    this.onOverlayPerformed,
    this.onActionPerformed,
    this.overlayIcon,
    this.overlayWidget,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _InfoPropertyLineActionState();
}

class _InfoPropertyLineActionState extends State<InfoPropertyLineAction> {
  bool _overlay;

  /// Called when an action is performed from the action-button
  void onActionPerformed() {
    if (widget.overlayWidget != null) {
      setState(
        () {
          // Invert state of overlay
          _overlay = !_overlay;

          // Check function to call
          if (_overlay == true) {
            if (widget.onActionPerformed != null) {
              // Call function pointer
              widget.onActionPerformed(widget.name, widget.value);
            }
          } else {
            if (widget.onOverlayPerformed != null) {
              widget.onOverlayPerformed(widget.name, widget.value);
            }
          }
        },
      );
    } else {
      // Call function pointer
      widget.onActionPerformed(widget.name, widget.value);
    }
  }

  // TODO: Make this responsive
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
            style: theme.textTheme.headline3,
            textAlign: TextAlign.center,
          ),
          _overlay == false
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 20),
                    child: Text(
                      widget.value,
                      style: theme.textTheme.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5, left: 10, right: 10, bottom: 5),
                    child: widget.overlayWidget,
                  ),
                ),
          _buildOverlay(),
        ],
      ),
    );
  }

  /// Builds the overlay for this widget
  Widget _buildOverlay() {
    if (widget.actionIcon != null && !_overlay)
      return IconButton(
        icon: widget.actionIcon,
        onPressed: onActionPerformed,
      );
    else if (widget.overlayIcon != null && _overlay)
      return IconButton(
        icon: widget.overlayIcon,
        onPressed: onActionPerformed,
      );
  }
}
