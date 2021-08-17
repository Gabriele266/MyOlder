/// Created by gabriele on 17/08/21
/// Stateless widget template
import 'package:flutter/material.dart';

/// A widget to display a FaqQuestion
class Question extends StatelessWidget {
  /// Question title
  final String title;

  /// Question body
  final String body;

  /// Question image url
  final String imageUrl;

  /// The leading icon
  final IconData leadingIcon;

  /// A widget to display a FaqQuestion
  Question({@required this.title, @required this.body, this.imageUrl, this.leadingIcon});

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
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Image(
                image: NetworkImage(imageUrl),
                width: media.size.width * 0.1,
                height: media.size.width * 0.1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: media.size.width * 0.02),
              child: Text(this.body, style: theme.textTheme.bodyText2.copyWith(fontSize: 15)),
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
