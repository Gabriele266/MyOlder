import 'package:flutter/material.dart';

// TODO: Abort use of this widget
class MetalPanelContainer extends StatelessWidget {
  // The child widget
  final Widget child;
  // The margin for this container
  final EdgeInsetsGeometry margin;
  // The title of this panel
  final Widget title;
  // The space between the title and the top margin
  final double titleTopMargin;
  // Background opacity
  final double opacity;

  /// Creates a new instance of a MetalPanelContainer to show a metal-look-like
  /// container.
  ///
  /// [child] The widget to show into it
  /// [margin] The space before and after this widget
  /// [title] The widget to show as a title
  /// [titleTopMargin] The space between the top margin and the title widget
  /// [opacity] The background opacity
  MetalPanelContainer({
    @required this.child,
    this.margin,
    this.title,
    this.titleTopMargin = 10,
    this.opacity = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        margin: this.margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey,
              Colors.grey[900],
            ],
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: this.titleTopMargin),
              child: this.title,
            ),
            this.child,
          ],
        ),
      ),
    );
  }
}
