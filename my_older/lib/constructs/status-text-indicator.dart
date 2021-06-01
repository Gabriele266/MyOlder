/// Created by gabriele on 14/04/21
/// Project myolder

/// Represents a status
enum StatusType{
  Success,
  Error,
  Warning
}

class StatusTextIndicator {
  // Status of this indicator
  StatusType status;
  // The applied text
  String _appliedText;
  // The default text
  final String defaultText;

  // ignore: unnecessary_getters_setters
  set text (String text) {
    _appliedText = text;
  }

  String get text => _appliedText;

  /// Olds the informations about a text, giving it a default value 
  /// and allowing the user to change it
  /// 
  /// [defaultText] The default text to apply
  StatusTextIndicator(this.defaultText);

  /// Creates a new instance of a textindicator and gives it a default value and a status
  ///
  /// [statusType] Defines the status of the text, if it is an error, a success text or a warning
  StatusTextIndicator.stateful(this.defaultText, StatusType statusType){
    status = statusType;
  }

  /// Returns the text of this indicator
  ///
  /// If there is only a defaultText set, it will return it, otherwise it will return any other text
  /// It is based onto [_defaultText] and [_appliedText]
  String getText(){
    if(_appliedText != null) return _appliedText;
    else return defaultText;
  }

  /// Returns the status string of this text indicator
  String getStatusString() {
    switch(status){
      case StatusType.Error:
        return 'Error';
      case StatusType.Success:
        return 'Success';
      case StatusType.Warning:
        return 'Warning';
      default:
        return null;
    }
  }

  /// Changes the text and optionally his status
  void changeText(String newText, {StatusType status = StatusType.Success}){
    _appliedText = newText;
    status = status;
  }

  /// Returns true if this indicator is a success message
  bool isSuccessMessage() => status == StatusType.Success;

  /// Returns true if this indicator is an error message
  bool isErrorMessage() => status == StatusType.Error;

  String toString() => 'StatusTextIndicator. Default text: $defaultText. Applied text: $_appliedText. ';
}