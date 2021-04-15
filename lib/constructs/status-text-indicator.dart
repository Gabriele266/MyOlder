/// Created by gabriele on 14/04/21
/// Project myolder
import 'package:flutter/material.dart';

enum StatusType{
  Success,
  Error,
  Warning
}

class StatusTextIndicator {
  // Status of this indicator
  StatusType _status;
  // The applied text
  String _appliedText;
  // The default text
  final String _defaultText;

  set text (String text) {
    _appliedText = text;
  }

  String get text => _appliedText;
  String get defaultText => _defaultText;

  set status(StatusType status){
    _status = status;
  }
  /// Olds the informations about a text, giving it a default value and allowing the user to change it
  StatusTextIndicator(this._defaultText);

  /// Creates a new instance of a textindicator and gives it a default value and a status
  ///
  /// [statusType] Defines the status of the text, if it is an error, a success text or a warning
  StatusTextIndicator.stateful(this._defaultText, StatusType statusType){
    _status = statusType;
  }

  /// Returns the text of this indicator
  ///
  /// If there is only a defaultText set, it will return it, otherwise it will return any other text
  /// It is based onto [_defaultText] and [_appliedText]
  String getText(){
    if(_appliedText != null) return _appliedText;
    else return _defaultText;
  }

  /// Returns the status string of this text indicator
  String getStatusString() {
    switch(_status){
      case StatusType.Error:
        return 'Error';
      case StatusType.Success:
        return 'Success';
      case StatusType.Warning:
        return 'Warning';
    }
  }

  /// Changes the text and optionally his status
  void changeText(String newText, {StatusType status = StatusType.Success}){
    _appliedText = newText;
    _status = status;
  }

  /// Returns true if this indicator is a success message
  bool isSuccessMessage() => _status == StatusType.Success;

  /// Returns true if this indicator is an error message
  bool isErrorMessage() => _status == StatusType.Error;

  String toString() => 'StatusTextIndicator. Default text: $_defaultText. Applied text: $_appliedText. ';
}