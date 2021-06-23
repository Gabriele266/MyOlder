import 'package:flutter/material.dart';

import 'generics.dart';

class Article extends StatelessWidget {
  /// The title of the article (a brief summary of the contents)
  final String title;

  /// The style of the title [TextStyle]. The default one is flutter's default.
  final TextStyle titleStyle;

  /// The content of the article
  final String content;

  /// The shape of the article
  final ArticleShape shape;

  /// The radius in case of a rounded rectangle shape for this article
  final double radius;

  /// The style of the content into the article (uses the same default as [titleStyle])
  final TextStyle contentStyle;

  /// The top padding to apply at the content of the article (space between [title] and [content])
  final double contentPadding;

  /// The content alignment to apply at the text. To specify a position for the text, use
  /// [contentPosition]
  final TextAlign contentAlignment;

  /// The background color of the article
  final Color backgroundColor;

  /// The color of the border for the article
  final Color borderColor;

  /// The background gradient to use as background for the article
  /// (needs that [backgroundColor] isn't set. ) you can specify only one of this 2.
  final Gradient backgroundGradient;

  /// The content margin to apply. The default one is [EdgeInsets.all(10)]
  final EdgeInsetsGeometry padding;

  /// The external margin before the article
  final EdgeInsetsGeometry margin;

  /// The width of the article
  final double width;

  /// The height of the article (by default it will take all the available space)
  final double height;

  /// The position of the title widget (follow [ParagraphPosition] documentation)
  final ParagraphPosition titlePosition;

  /// The content widget position (follow [ParagraphPosition] documentation)
  final ParagraphPosition contentPosition;

  /// The icon to use into the title
  final Icon titleIcon;

  /// The position of [titleIcon]
  final TitleIconPosition iconPosition;

  /// The padding to apply at the icon
  final EdgeInsetsGeometry iconPadding;

  /// Indicates if the background should be visible or not
  final bool backgroundVisible;

  /// Creates a new [Article] widget to display informations into a box.
  Article({
    Key key,
    @required this.title,
    @required this.content,
    this.shape = ArticleShape.rectangle,
    this.radius = 15,
    this.backgroundColor,
    this.titleStyle = const TextStyle(),
    this.titleIcon,
    this.iconPosition,
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.height,
    this.borderColor,
    this.width,
    this.contentStyle,
    this.contentPadding = 1,
    this.backgroundGradient,
    this.iconPadding,
    this.backgroundVisible = true,
    this.contentPosition = ParagraphPosition.left,
    this.titlePosition = ParagraphPosition.left,
    this.contentAlignment = TextAlign.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: backgroundVisible
          ? BoxDecoration(
              borderRadius: shape == ArticleShape.rectangle
                  ? null
                  : BorderRadius.circular(radius),
              color: backgroundColor,
              gradient: backgroundGradient,
              border: Border.all(
                color: borderColor != null ? borderColor : Colors.transparent,
              ),
            )
          : null,
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildContentPadding(),
          _buildContent(),
        ],
      ),
    );
  }

  /// Builds the [title] widget
  Widget _buildTitle() {
    var pos = iconPosition;

    if (pos == null && titleIcon != null) {
      print(
          'textual_widgets warning: No position was given for the titleIcon. It will be used the TitleIconPosition.left');
      pos = TitleIconPosition.left;
    }

    // Convert the title position into an alignment
    var alignment = _alignmentGeometry(titlePosition);

    return Align(
      alignment: alignment,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            (pos != null && pos == TitleIconPosition.left)
                ? _buildTitleIcon()
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
            _buildTitleText(),
            (pos != null && pos == TitleIconPosition.right)
                ? _buildTitleIcon()
                : SizedBox(
                    height: 0,
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      title,
      style: titleStyle,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds the [titleIcon] widget
  Widget _buildTitleIcon() {
    return Padding(
      padding: iconPadding != null ? iconPadding : const EdgeInsets.all(0),
      child: titleIcon,
    );
  }

  /// Builds the content padding
  Widget _buildContentPadding() {
    return Padding(
      padding: EdgeInsets.only(top: contentPadding),
    );
  }

  /// Converts a [position] into an [AlignmentGeometry]
  AlignmentGeometry _alignmentGeometry(ParagraphPosition position) {
    switch (position) {
      case ParagraphPosition.right:
        return Alignment.topRight;
      case ParagraphPosition.left:
        return Alignment.topLeft;
      case ParagraphPosition.center:
        return Alignment.center;
    }
  }

  /// Builds the [content]
  Widget _buildContent() {
    final alignment = _alignmentGeometry(contentPosition);

    return Align(
      alignment: alignment,
      child: Text(
        content,
        style: contentStyle,
        textAlign: contentAlignment,
        overflow: TextOverflow.clip,
      ),
    );
  }
}
