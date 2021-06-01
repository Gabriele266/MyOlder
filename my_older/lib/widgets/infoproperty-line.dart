import 'package:flutter/material.dart';

class InfoPropertyLine extends StatelessWidget {
  // Name of the property to display
  final String name;

  // value of the property to display
  final String value;

  /// Creates a new instance of a new line information for a specific property of a
  /// generic object.
  ///
  /// To create a line information with a button use the infoproperty-line-button class instead
  /// [name] The name of the property
  /// [value] The value of the property
  InfoPropertyLine({
    required this.name,
    required this.value,
  }) : super();

  // TODO: Make this widget responsive
  // TODO: Make this widget follow the theme
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: nameStyle,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                value != null ? value : '',
                style: valueStyle,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TODO: Put [nameStyle] style into the theme
  /// The style used for names
  static const TextStyle nameStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  // TODO: Put [valueStyle] style into the theme
  /// The style used for names
  static const TextStyle valueStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
    fontFamily: 'Courier New',
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );
}
