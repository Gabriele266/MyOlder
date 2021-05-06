import 'package:xml/xml.dart';

/// Represents a user of the application
/// TODO: Make _name and _password public and remove getters and setters
class MyOlderUser{
  String _name;
  String _password;

  /// Initializes a new user
  ///
  /// Creates a new instance of the user, giving it a name and a password <br>
  /// [name] : String that contains the name of the new user <br>
  /// [password] : String that contains the new password <br>
  /// **All the parameters can be null**
  MyOlderUser({String name, String password}){
    _name = name;
    _password = password;
  }

  // TODO: Write better documentation for fromXmlElement *documentation*
  MyOlderUser.fromXmlElement(XmlElement element){
    _name = element.findElements('name').first.text;
    _password = element.findElements('password').first.text;
  }

  /// Returns the name of the user
  String get name => _name;

  /// Returns the name of the user
  String get password => _password;

  /// Checks if the current user is equal (same name and password) to another user
  bool equals(MyOlderUser user)
    => (user.name == _name && user.password == _password);

  /// Sets the password of the user
  set password(String password)  {
    _password = password;
  }

  /// Sets the name of the user
  set name(String name){
    _name = name;
  }

  /// Checks if the user has some informations or not
  bool isNotEmpty()
    => (_name != '') && (_password != '');

  /// Returns a xml string representing this user
  String toXmlString(){
    var builder = XmlBuilder();
    builder.element('user', nest: (){
      builder.element('name', nest: (){
        builder.text(_name);
      });
      builder.element('password', nest: (){
        builder.text(_password);
      });
    });

    return builder.buildDocument().toXmlString();
  }

  @override
  String toString(){
    String u = 'Username: $_name\nPassword:';

    for(int x = 0; x < _password.length; x++){
      u += '*';
    }
    return u;
  }
}