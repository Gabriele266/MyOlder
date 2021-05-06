import 'package:flutter/material.dart';

class RgbColorFormatter{
  // Rgb color formatter
  int _red;
  int _blue;
  int _green;

  // Separator for the formatting
  String _separator = ',';

  /// Creates a new instance of an rgb color formatter
  ///
  RgbColorFormatter (this._red, this._blue, this._green);

  /// Creates a new instance of an rgb color formatter reading informations from a Color object
  ///
  /// [color] The color to use  <br>
  /// [separator] The separator character to use for IO operations
  RgbColorFormatter.fromColor(Color color, {String separator = ','}){
    _red = color.red;
    _blue = color.blue;
    _green = color.green;
    _separator = separator;
  }

  RgbColorFormatter.empty() {
    _separator = ',';
  }

  /// Formats the string representing this color
  String formatString() =>
    '$_red$_separator$_blue$_separator$_green';

  /// Reads the informations about a color from the given string applying the selecetd separator.
  ///
  /// [source] The source string to read <br>
  /// Returns the read color or throws an exception
  /// ** Requires that [_separator] has been set.
  Color fromString(String source) {
    var color;
    if(source != ''){
      if(_separator != ''){
        // Split source into substrings
        try {
          var subStr = source.split(_separator);
          _red = int.parse(subStr[0]);
          _green = int.parse(subStr[1]);
          _blue = int.parse(subStr[2]);

          color = Color.fromARGB(100, _red, _green, _blue);
          return color;
        }on IndexError{
          print('Index error. The source string given is not a color. ');
        }
      }
    }
  }
}