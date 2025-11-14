// lib/theme.dart
import 'package:flutter/material.dart';

// Tes couleurs
const Color kPrimaryColor = Color(0xFF885E5D); // navbar & boutons
const Color kSecondaryColor = Color(0xFF914A4A); // autres éléments

final ThemeData appTheme = ThemeData(
  primaryColor: kPrimaryColor,
  colorScheme: ColorScheme.fromSwatch(
    primarySwatch: MaterialColor(0xFF885E5D, <int, Color>{
      50: Color(0xFFF6EEED),
      100: Color(0xFFEDDBDA),
      200: Color(0xFFE3C6C5),
      300: Color(0xFFD9B2B1),
      400: Color(0xFFCF9E9D),
      500: kPrimaryColor,
      600: Color(0xFF7B4F4D),
      700: Color(0xFF6F4442),
      800: Color(0xFF633838),
      900: Color(0xFF552D2C),
    }),
  ).copyWith(secondary: kSecondaryColor),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: const AppBarTheme(
    backgroundColor: kPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 2,
    centerTitle: true,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
);
