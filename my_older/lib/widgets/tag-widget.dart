import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget {
  // A function to show all the files ordered by tag
  final void Function(String) showByTag;

  // The tag info to show
  final String tag;

  /// Creates a new Instance of a TagWidget widget
  ///
  /// This widget represents a tag with all its properties
  /// [tag] The tag name
  /// [showByTag] The function to call when the user wan't to sort all the files by tag
  TagWidget({Key? key, required this.tag, required this.showByTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(10),
          ),
          side: const BorderSide(
            width: 1,
            color: Colors.black,
          ),
        ),
        child: Center(
          child: Text(
            tag,
            style: Theme.of(context).textTheme.headline5,
          ),
        ),
        onPressed: () {
          showByTag(tag);
        },
      ),
    );
  }
}
