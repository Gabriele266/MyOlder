import 'package:flutter/foundation.dart';

import 'package:xml/xml.dart';

/// Represents a user of the application
class MyOlderUser {
  final String name;
  final String password;

  /// Initializes a new user
  ///
  /// Creates a new instance of the user, giving it a name and a password <br>
  /// [name] : String that contains the name of the new user <br>
  /// [password] : String that contains the new password <br>
  MyOlderUser({@required this.name, @required this.password});

  /// Creates a new [MyOlderUser] starting from an xml element. 
  static MyOlderUser fromXmlElement(XmlElement element) {
    return MyOlderUser(
      name: element.findElements('name').first.text,
      password: element.findElements('password').first.text,
    );
  }

  /// Checks if the current user is equal (same name and password) to another user
  bool equals(MyOlderUser user) =>
      (user.name == name && user.password == password);

  /// Checks if the user has some informations or not
  bool isNotEmpty() => (name != '') && (password != '');

  /// Returns a xml string representing this user
  String toXmlString() {
    var builder = XmlBuilder();
    builder.element('user', nest: () {
      builder.element('name', nest: () {
        builder.text(name);
      });
      builder.element('password', nest: () {
        builder.text(password);
      });
    });

    return builder.buildDocument().toXmlString();
  }

  @override
  String toString() {
    String u = 'Username: $name\nPassword:';

    for (int x = 0; x < password.length; x++) {
      u += '*';
    }
    return u;
  }
}
