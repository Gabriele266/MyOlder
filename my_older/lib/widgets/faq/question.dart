/// Created by gabriele on 17/08/21
/// Stateless widget template
import 'package:flutter/material.dart';

/// A widget to display a FaqQuestion
class Question extends StatelessWidget {
  /// Question title
  final String title;

  /// Question image url
  final String imageUrl;

  /// The leading icon
  final IconData leadingIcon;

  /// The answer body (complete answer)
  final String answer;

  /// A widget to display a FaqQuestion
  Question({
    @required this.title,
    this.imageUrl,
    @required this.answer,
    this.leadingIcon,
  }) : assert(title != null), assert(answer != null);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return ExpansionTile(
      title: Text(this.title, style: theme.textTheme.headline3),
      iconColor: theme.primaryColorLight,
      childrenPadding: EdgeInsets.symmetric(vertical: media.size.height * 0.02),
      leading: Icon(
        leadingIcon != null ? leadingIcon : Icons.question_answer_outlined,
        size: 20,
        color: theme.primaryColorDark,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(media.size.width * 0.04)),
              child: Image(
                image: NetworkImage(imageUrl),
                width: media.size.width * 0.15,
                height: media.size.width * 0.15,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: media.size.width * 0.03),
              child: Container(
                width: media.size.width * 0.6,
                child: Text(
                  this.answer,
                  style: theme.textTheme.bodyText2.copyWith(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    // TODO: Implement dispose
  }
}
