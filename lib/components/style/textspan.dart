import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextSpan styledTextSpan(String text,
    {Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
    double fontSize = 13,
    FontStyle fontStyle = FontStyle.italic,
    TextDecoration decoration = TextDecoration.none,
    Color? decorationColor,
    TextDecorationStyle? decorationStyle,
    GestureRecognizer? recognizer}) {
  return TextSpan(
    text: text,
    style: GoogleFonts.getFont(
      'Montserrat',
      color: color,
      fontWeight: fontWeight,
      fontSize: fontSize,
      decoration: decoration,
      decorationColor: color,
      decorationStyle: decorationStyle,
      fontStyle: fontStyle,
    ),
    recognizer: recognizer,
  );
}
