import 'formatting-exception.dart';

class DateTimeFormatter {
  // DateTime to format
  DateTime _dateTime;
  // Pattern to use
  String _pattern;

  /// Creates a new instance of a datetime formatter
  ///
  /// [dateTime] Represents the date and the time to format. <br>
  /// [pattern] Represents a pattern to use for the formatting <br>
  DateTimeFormatter({DateTime dateTime, String pattern = 'dd/mm/yy-hh:MM:ss'}) {
    _dateTime = dateTime;
    _pattern = pattern;
  }

  /// Creates a new instance of a DateTimeFormatter using a specific datetime and a complete pattern,
  /// with also microseconds
  ///
  /// The complete pattern is ** dd/mm/yy-hh:MM:ss:ms **
  DateTimeFormatter.complete(DateTime dateTime) {
    _dateTime = dateTime;
    _pattern = 'dd/mm/yy-hh:MM:ss:ms';
  }

  DateTimeFormatter.onlyDate(DateTime dateTime){
    _pattern = 'dd/mm/yy';
    _dateTime = dateTime;
  }

  /// Creates a new instance of a datetimeformatter with a complete pattern and no datetime set
  DateTimeFormatter.completePattern(){
    _pattern = 'dd/mm/yy-hh:MM:ss:ms';
  }

  /// Creates a new instance of a datetime formatter using the default pattern and a given datetime
  ///
  DateTimeFormatter.dateTime(this._dateTime);

  set pattern(String pattern) => _pattern = pattern;
  set dateTime(DateTime dateTime) => _dateTime = dateTime;

  /// Gets the pattern element at the given index
  ///
  /// ** requires that [_pattern] has been set **
  String getPatternElement(int index) {
    var split = _pattern.split('-');
    // Split first portion
    var split1 = split[0].split('/');
    var split2 = split[1].split(':');

    if (index > split1.length) {
      return split2[index];
    }
    return split1[index];
  }

  /// Returns the pattern element in the date pattern at the given index
  ///
  /// [index] The index of the element.
  String getDatePatternElement(int index) {
    String datePattern = getDatePattern();
    var split = datePattern.split('/');
    return split[index];
  }

  /// Returns the date pattern taken from the [_pattern]
  String getDatePattern() {
    var split = _pattern.split('-');
    if (split[0].contains('/')) return split[0];
    return split[1];
  }

  /// Returns the time pattern taken from the [_pattern]
  String getTimePattern(){
    var split = _pattern.split('-');
    if(split[0].contains(':')) return split[0];
    return split[1];
  }

  /// Returns the time pattern element at the given index
  ///
  /// [index] The index of the element
  String getTimePatternElement(int index){
    var split = getTimePattern().split(':');
    return split[index];
  }

  /// Formats the given datetime to the string using the pattern
  ///
  /// ** Requires that the [_dateTime] has been set **
  String format() {
    String result = _pattern;

    // Replace pattern elements
    result = result.replaceAll('dd', _dateTime.day.toString());
    result = result.replaceAll('mm', _dateTime.month.toString());
    result = result.replaceAll('yy', _dateTime.year.toString());

    result = result.replaceAll('hh', _dateTime.hour.toString());
    result = result.replaceAll('MM', _dateTime.minute.toString());
    result = result.replaceAll('ss', _dateTime.second.toString());
    result = result.replaceAll('ms', _dateTime.microsecond.toString());
    return result;
  }

  /// Reads the informations about a date from the given string applying the pattern
  ///
  /// [dateSource] The string to read informations from <br>
  /// Returns an **incomplete DateTime** containing only the date, all the parameters relative to the time are set to 0
  DateTime dateFromString(String dateSource) {
    // Read date time
    int day;
    int month;
    int year;

    var split = dateSource.split('/');
    int fieldCount = split.length;

    for (int x = 0; x < fieldCount; x++) {
      // get current date pattern element
      var elemType = getDatePatternElement(x);
      // Check assigning
      if (elemType == 'dd') day = int.parse(split[x]);
      else if (elemType == 'mm') month = int.parse(split[x]);
      else if (elemType == 'yy') year = int.parse(split[x]);
      else throw FormattingException(' parsing a date from the string $dateSource');
    }
    // Construct a datetime object and return it
    return DateTime(year, month, day);
  }

  /// Reads the informations about a time from the given string applying the pattern
  ///
  /// [timeSource] The string to read informations from <br>
  /// Returns an ** incomplete DateTime ** containing only the informations about the time and not the date.
  DateTime timeFromString(String timeSource) {
    // Divide into separator
    var div = timeSource.split(':');
    // Number of elements
    int elemCount = div.length;

    int hour;
    int minute;
    int second;
    int millisecond = 0;

    for(int x = 0; x < elemCount; x++){
        var elemType = getTimePatternElement(x);

        if(elemType == 'hh') hour = int.parse(div[x]);
        else if(elemType == 'MM') minute = int.parse(div[x]);
        else if(elemType == 'ss') second = int.parse(div[x]);
        else if(elemType == 'ms') millisecond = int.parse(div[x]);
        else throw FormattingException(' parsing time from the string: $timeSource');
    }
    // Create a datetime object and return it
    return DateTime(0, 0, 0, hour, minute, second, millisecond);
  }

  /// Loads the information about a datetime starting from a string, applying a given pattern
  ///
  /// [source] The string to read informations from <br>
  /// Returns a complete datetime containing all the informations
  DateTime fromString(String source) {
    if (source != '') {
      if (_pattern != '') {
        // Get the two parts of the pattern
        var div = source.split('-');
        String dateString;
        String timeString;
        // Check if first is date or time
        if (div[0].contains('/')) {
          dateString = div[0];
          timeString = div[1];
        } else {
          dateString = div[1];
          timeString = div[0];
        }

        // Start format
        DateTime date = dateFromString(dateString);
        DateTime time = timeFromString(timeString);

        // Create a complete datetime and return it
        return DateTime(date.year, date.month, date.day, time.hour, time.minute, time.second, time.millisecond);
      }
    }
  }
}
