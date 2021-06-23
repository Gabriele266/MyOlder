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
    Key key,
    @required this.name,
    @required this.value,
  }) : super(key: key);

  // TODO: Make this widget responsive
  // TODO: Make this widget follow the theme
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: theme.textTheme.headline3,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                value,
                style: theme.textTheme.bodyText1
                    .copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
