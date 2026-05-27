// FILE: text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final int? maxLines;
  final IconData? additionalIcon;
  final double? fontSize;
  final Null Function(dynamic value) onChanged;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Function()? onpressed;
  final String? errorText;
  final bool? filled;
  final Color? fillColor;
  final double? height;

  const MyTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      required this.prefixIcon,
      this.maxLines,
      this.additionalIcon,
      this.fontSize,
      required this.onChanged,
      this.keyboardType,
      this.textCapitalization,
      this.onpressed,
      this.errorText,
      this.filled,
      this.fillColor,
      this.height});

  @override
  // ignore: library_private_types_in_public_api
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _obscureText = true;
  String hintText = '';
  IconData prefixIcon = Icons.person;
  IconData iconButton = Icons.remove_red_eye;
  TextEditingController controller = TextEditingController();
  bool obscureText = false;
  int? maxLines;
  IconData? additionalIcon;
  double? fontSize;
  Null Function(dynamic value)? onChanged;
  TextInputType? keyboardType;
  TextCapitalization? textCapitalization;
  Function()? onpressed;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final iconColor = isDarkMode ? Colors.white : Colors.black;
    final border = isDarkMode ? Colors.black : Colors.white;

    return SizedBox(
      height: widget.height ?? 73,
      child: SizedBox(
        height: 43,
        width: screenWidth * 0.85,
        child: TextField(
          //
          controller: widget.controller,
          obscureText: widget.obscureText ? _obscureText : false,
          maxLines: widget.maxLines ?? 1,
          onChanged: widget.onChanged,
          autofocus: true,
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          //Con trỏ |
          cursorHeight: 20,
          cursorWidth: 1.5,
          //Decoration of TextField
          style: GoogleFonts.montserrat(
            color: textColor,
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Icon(
                widget.prefixIcon,
                size: 20,
                color: iconColor,
              ),
              suffixIcon: widget.obscureText
                  ? IconButton(
                      color: iconColor,
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              hintStyle: GoogleFonts.montserrat(
                color: textColor,
                fontSize: fontSize ?? 14,
                fontWeight: FontWeight.w400,
              ),
              //error
              errorText: widget.errorText,
              errorStyle: GoogleFonts.montserrat(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.red, style: BorderStyle.solid, width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: border),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: iconColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              contentPadding: const EdgeInsets.all(10),
              filled: widget.filled,
              fillColor: widget.fillColor,
            ),
        ),
      ),
    );
  }
}
