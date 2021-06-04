import 'package:flutter/material.dart';

class TextSection extends StatelessWidget {
  final String title;
  final String content;
  final double maxWidth;
  final double maxHeight;
  final TextAlign textAlign;
  final BoxDecoration decoration;
  final EdgeInsetsGeometry padding;
  final IconData titleIcon;

  /// Creates a new [TextSection]. A widget to display a section text with a title and some
  /// contents.
  ///
  /// [title] The section title
  /// [content] The section content
  /// [maxHeight] The maximum height of this section
  /// [maxWidth] The maximum width of this section
  /// [textAlign] The text align to apply (it will also affect the widgets alignment)
  /// [padding] The internal padding of all the text
  TextSection({
    Key key,
    @required this.title,
    @required this.content,
    this.maxHeight = double.infinity,
    this.maxWidth = double.infinity,
    this.textAlign = TextAlign.center,
    this.decoration = const BoxDecoration(),
    this.padding,
    this.titleIcon = null,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simplify
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Container(
      width: maxWidth != double.infinity ? maxWidth : media.size.width,
      height: maxHeight != double.infinity ? maxHeight : media.size.height,
      padding: padding == null
          ? EdgeInsets.only(top: media.size.height * 0.03)
          : padding,
      decoration: decoration,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: _geometryFromTextAlign(textAlign),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                titleIcon != null
                    ? Align(
                        alignment: _geometryFromTextAlign(textAlign),
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: media.size.width * 0.04,
                          ),
                          child: Icon(
                            titleIcon,
                          ),
                        ),
                      )
                    : const SizedBox(
                        width: 0,
                        height: 0,
                      ),
                Align(
                  alignment: _geometryFromTextAlign(textAlign),
                  child: Text(
                    title,
                    style: theme.textTheme.headline1,
                    textAlign: textAlign,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
          Text(
            content,
            style: theme.textTheme.bodyText2,
            textAlign: textAlign,
          ),
        ],
      ),
    );
  }

  /// Gets the corresponding [AlignmentGeometry] from a textalign to apply
  AlignmentGeometry _geometryFromTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.justify:
        return Alignment.center;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.centerLeft;
    }
  }
}
