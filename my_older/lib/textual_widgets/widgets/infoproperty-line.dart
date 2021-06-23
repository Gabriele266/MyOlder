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
  const InfoPropertyLine({
    Key key,
    @required this.name,
    @required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: media.size.height * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FittedBox(
            child: Text(
              name,
              style: theme.textTheme.headline3,
            ),
          ),
          FittedBox(
            child: Text(
              value,
              style: theme.textTheme.headline3,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
