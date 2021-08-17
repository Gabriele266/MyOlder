/// Created by gabriele on 17/08/21
/// Stateless widget template
import 'package:flutter/material.dart';

/// A widget to display a 'Continue' or 'Cancel dialog, with some text and a beautyful animation
class ContinueCancelDialog extends StatefulWidget {
  /// The dialog title
  final String title;

  /// The dialog content
  final String content;

  /// The callback called when the dialog is accepted
  final void Function() onAccept;

  /// The callback called when the dialog is dismissed
  final void Function() onDismiss;

  /// An optional icon to display before the title
  final IconData icon;

  /// A widget to display a 'Continue' or 'Cancel dialog, with some text and a beautyful animation
  ContinueCancelDialog({
    @required this.title,
    @required this.content,
    @required this.onAccept,
    this.onDismiss,
    this.icon,
  })  : assert(title != ""),
        assert(content != ""),
        assert(onAccept != null);

  @override
  _ContinueCancelDialogState createState() => _ContinueCancelDialogState();
}

class _ContinueCancelDialogState extends State<ContinueCancelDialog>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: _animation,
        child: _buildAlertDialog(context),
      ),
    );
  }

  /// Builds the alert dialog
  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: _buildHeading(context),
      content: Text(widget.content),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      actions: _buildActions(context),
    );
  }

  /// Builds the heading
  Widget _buildHeading(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (widget.icon != null)
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: Icon(
              widget.icon,
              color: theme.primaryColorDark,
            ),
          ),
        Text(widget.title),
      ],
    );
  }

  /// Builds the dialog actions
  List<Widget> _buildActions(BuildContext context) => [
    TextButton(
      child: const Text('Cancel'),
      onPressed: () => dismiss(),
    ),
    TextButton(
      child: const Text('Continue'),
      onPressed: () => accept(),
    ),
  ];

  /// Dismisses this dialog
  void dismiss() {
    Navigator.of(context).pop();
    assert(widget.onDismiss != null);
    widget.onDismiss();
  }

  /// Accepts the dialog
  void accept() {
    Navigator.of(context).pop();
    assert(widget.onAccept != null);
    widget.onAccept();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
