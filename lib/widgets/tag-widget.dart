import 'package:flutter/material.dart';

class TagWidget extends StatelessWidget{
  // A function to show all the files ordered by tag
  final void Function(String) _showByTag;
  // The tag info to show
  final String _tag;

  TagWidget(this._showByTag, this._tag);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            side: BorderSide(
              width: 1,
              color: Colors.black,
            ),
          ),
          child: Center(
              child: Text(
                  _tag,
                  style: Theme.of(context).textTheme.headline5
              )
          ),
          onPressed: (){
            _showByTag(_tag);
          }
      )
    );
  }
}