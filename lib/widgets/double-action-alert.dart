/// Created by gabriele on 14/04/21
/// Stateless widget template
import 'package:flutter/material.dart';

/// A widget with 2 buttons to perform 2 actions
class DoubleActionAlert extends StatelessWidget {
  String _title;
  String _contents;
  void Function() _firstAction;
  void Function() _secondAction;

  String _firstActionText;
  String _secondActionText;

  /// Creates a new instance of a DoubleActionAlert to display an alert with 2 actions
  ///
  /// [title] The title of this alert
  /// [content] The content of this alert
  /// [firstCallback] The function to call when the first action button is pressed
  /// [secondCallback] The function to call when the second action button is pressed
  /// [firstAction] The first action text
  /// [secondAction] The second action text
  DoubleActionAlert(
      {@required String title,
        @required String content,
        void Function() firstCallback,
        void Function() secondCallback,
        String firstAction,
        String secondAction}) {
    _title = title;
    _contents = content;
    _firstAction = firstCallback;
    _secondAction = secondCallback;
    _firstActionText = firstAction;
    _secondActionText = secondAction;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        _title
      ),
      content: Text(
        _contents
      ),
      actions: [
        if(_firstAction != null) TextButton(
          child: Text(
            _firstActionText
          ),
          onPressed: _firstAction,
        ),

        if(_secondAction != null) TextButton(
          child: Text(
            _secondActionText
          ),
          onPressed: _secondAction,
        )
      ],
    );
  }
}