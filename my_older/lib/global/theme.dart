import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  /// The default normal Theme
  ///
  /// Uses most of the colors definded into [CustomColors] in file [colors.dart]
  static get normalTheme => ThemeData(
        backgroundColor: CustomColors.orangeAccent,
        primaryColor: CustomColors.redAccent,
        primaryColorDark: CustomColors.brown,
        primaryColorLight: CustomColors.bluet,
        accentColor: CustomColors.lightYellow,
        canvasColor: CustomColors.orangeAccent,
        errorColor: Colors.red[800],

        buttonColor: CustomColors.redAccent,
        buttonTheme: ButtonThemeData(
          buttonColor: CustomColors.redAccent,
          textTheme: ButtonTextTheme.normal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(
              color: CustomColors.lightYellow,
            ),
          ),
          disabledColor: Colors.grey[600],
        ),

        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(CustomColors.redAccent),
            foregroundColor: MaterialStateProperty.all(CustomColors.brown),
            elevation: MaterialStateProperty.all(2),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  width: 1.5,
                  color: CustomColors.lightYellow,
                ),
                borderRadius: const BorderRadius.all(
                  const Radius.circular(30),
                ),
              ),
            ),
          ),
        ),

        textTheme: TextTheme(
          headline1: TextStyle(
            color: CustomColors.lightYellow,
            fontSize: 24,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times New Roman',
            shadows: [
              Shadow(
                blurRadius: 3,
                color: Colors.black,
              ),
            ],
          ),
          headline2: TextStyle(
            color: CustomColors.lightYellow,
            fontSize: 18,
            letterSpacing: 0.4,
            fontWeight: FontWeight.w600,
            fontFamily: 'Times new Roman',
          ),
          headline3: TextStyle(
            color: CustomColors.brown,
            fontSize: 15,
            fontWeight: FontWeight.w300,
            fontFamily: 'Times new Roman',
          ),
          headline4: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFamily: 'Times new Roman',
              letterSpacing: 1.2),
          headline5: TextStyle(
            color: Colors.yellowAccent,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          overline: TextStyle(
            color: Colors.red[800],
            fontSize: 15,
            letterSpacing: 0.4,
            fontWeight: FontWeight.bold,
            fontFamily: 'Times new Roman',
          ),
          bodyText1: TextStyle(
            color: Colors.yellow[800],
            fontSize: 20,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
          bodyText2: TextStyle(
            color: CustomColors.brown,
            fontSize: 18,
            fontWeight: FontWeight.w300,
            fontFamily: 'Times new Roman',
          ),
        ),

        /// The appbar theme for styling the [AppBar]
        appBarTheme: AppBarTheme(
          backgroundColor: CustomColors.redAccent,
          foregroundColor: Colors.amberAccent,
          titleTextStyle: TextStyle(
            color: CustomColors.lightYellow,
            fontFamily: 'Times New Roman',
            fontWeight: FontWeight.bold,
          ),
          actionsIconTheme: IconThemeData(
            color: CustomColors.lightYellow,
            size: 30,
            opacity: 1,
          ),
        ),

        // Icon themes
        primaryIconTheme: IconThemeData(
          size: 20,
          color: CustomColors.lightYellow,
        ),

        accentIconTheme: IconThemeData(
          size: 20,
          color: CustomColors.bluet,
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          splashColor: CustomColors.lightYellow,
          backgroundColor: CustomColors.bluet,
          elevation: 1.2,
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          border: const OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              const Radius.circular(10),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CustomColors.lightYellow,
              width: 2,
            ),
          ),
          labelStyle: TextStyle(
            color: CustomColors.brown,
            fontSize: 20,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: CustomColors.brown,
        ),
      );
}
