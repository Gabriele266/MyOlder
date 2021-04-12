import 'package:flutter/material.dart';

/// Style for the name
var nameStyle = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

var valueStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

class InfoPropertyLine extends StatelessWidget {
  // Name of the property to display
  final String _name;

  // value of the property to display
  final String _value;

  /// Creates a new instance of a new line information for a specific property of a
  /// generic object.
  ///
  /// To create a line information with a button use the infoproperty-line-button class instead
  InfoPropertyLine(this._name, this._value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(_name,
              style: nameStyle,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                _value,
                style: valueStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
