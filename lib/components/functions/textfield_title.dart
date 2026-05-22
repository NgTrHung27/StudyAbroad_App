import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';

class TextFieldTitle extends StatefulWidget {
  final String title, hintText;
  final TextEditingController controller;
  final Color color;
  final Null Function(dynamic value) onChanged;
  final String? errorText;

  const TextFieldTitle({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    required this.onChanged,
    this.color = Colors.white,
    this.errorText,
  });

  @override
  State<TextFieldTitle> createState() => _TextFieldTitleState();
}

class _TextFieldTitleState extends State<TextFieldTitle> {
  late FocusNode _focusNode;
  // Null Function(dynamic value)? onChanged;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isFocused = _focusNode.hasFocus;
    final isDarkMode = context.watch<ThemeSettingBloc>().state.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: screenWidth * 0.85,
          child: Stack(
            children: <Widget>[
              Container(
                height: 65.0,
                constraints: const BoxConstraints(minWidth: double.infinity),
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: widget.errorText != null
                            ? Colors.red
                            : AppColor.borderTextField,
                        width: 1.0),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      onChanged: widget.onChanged,
                      autofocus: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: TextStyle(
                            color: AppColor.borderTextField, fontSize: 16),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 15.0),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: isDarkMode ? Colors.white : Colors.black,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: widget.errorText != null
                                  ? Colors.red
                                  : AppColor.borderTextField,
                              width: 1.0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15.0,
                child: Container(
                  color:
                      isDarkMode ? AppColor.scafflodBgColorDark : widget.color,
                  padding: const EdgeInsets.symmetric(horizontal: 7.0),
                  child: TextMonserats(
                    widget.title,
                    color: (isFocused && isDarkMode)
                        ? Colors.white
                        : (isFocused && !isDarkMode)
                            ? Colors.black
                            : AppColor.borderTextField,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 15.0),
            child: Text(
              widget.errorText!,
              style: GoogleFonts.montserrat(
                color: Colors.red,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
