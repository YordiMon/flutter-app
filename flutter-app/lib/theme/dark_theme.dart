import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.grey[500],
  secondaryHeaderColor:const Color.fromARGB(255, 54, 128, 255),
  cardColor: Colors.white,
  
  colorScheme: ColorScheme.dark(
    background: Colors.black,
    
    primary: Colors.grey.shade900,
    secondary: Colors.grey.shade800,
    tertiary: Colors.grey.shade500,
  ),

  textSelectionTheme:  TextSelectionThemeData(
    selectionColor: Colors.grey.shade800 ,
  ),
);

