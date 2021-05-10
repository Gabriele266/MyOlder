/// Created by gabriele on 14/04/21
/// Stateless widget template
import 'package:flutter/material.dart';

class DoubleActionAlert extends StatelessWidget {
  // Widget title
  final String title;

  // Widget contents
  final String contents;

  // Function to call when the first action is performed
  final void Function() firstAction;

  // Function to call when the second action is performed
  final void Function() secondAction;

  // Text of the first action
  final String firstActionText;

  // Text of the second action
  final String secondActionText;

  /// Creates a new instance of a DoubleActionAlert to display an alert with 2 actions
  ///
  /// [title] The title of this alert
  /// [contents] The content of this alert
  /// [firstAction] The function to call when the first action button is pressed
  /// [secondAction] The function to call when the second action button is pressed
  /// [firstAction] The first action text
  /// [secondAction] The second action text
  DoubleActionAlert({
    Key key,
    @required this.title,
    @required this.contents,
    this.firstAction,
    this.secondAction,
    this.firstActionText,
    this.secondActionText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(contents),
      actions: [
        if (firstAction != null)
          TextButton(
            child: Text(firstActionText),
            onPressed: firstAction,
          ),
        if (secondAction != null)
          TextButton(
            child: Text(secondActionText),
            onPressed: secondAction,
          )
      ],
    );
  }
}
