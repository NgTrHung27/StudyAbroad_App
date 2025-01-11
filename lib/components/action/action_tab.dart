import 'package:flutter/cupertino.dart'; // Import Cupertino library
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/blocs/lang_cubit/language_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/constant/theme.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';

class FunctionItem {
  final String name;
  final IconData icon;
  final bool isEnable;
  bool switchValue;
  final void Function(Locale)? dropdownCallback;
  final Function()? onTap;

  FunctionItem({
    required this.name,
    required this.icon,
    this.isEnable = false,
    this.switchValue = false,
    this.dropdownCallback,
    this.onTap,
  });
}

class ActionTab extends StatefulWidget {
  final String header;
  final List<FunctionItem> functions;
  final Color backgroundColor;
  final Color colorIcon;

  const ActionTab({
    super.key,
    required this.header,
    this.functions = const [],
    required this.backgroundColor,
    required this.colorIcon,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ActionTabState createState() => _ActionTabState();
}

class _ActionTabState extends State<ActionTab> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = context.watch<ThemeSettingCubit>().state == AppTheme.blackTheme;
    final dropdownColor = isDarkMode ? AppColor.scafflodBgColorDark : Colors.white;
    final textcolor = isDarkMode ? Colors.white : Colors.black;
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextMonserats(
            widget.header,
            fontSize: 17,
            color: isDarkMode ? Colors.white : AppColor.redButton,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.functions.asMap().entries.map((entry) {
              int idx = entry.key;
              FunctionItem function = entry.value;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: function.onTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(function.icon, color: widget.colorIcon, size: 25),
                            const SizedBox(width: 15),
                            Expanded(
                              child: TextMonserats(
                                function.name,
                                fontSize: 16,
                                color: isDarkMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (function.isEnable)
                              CupertinoSwitch(
                                value: context.watch<ThemeSettingCubit>().state == AppTheme.blackTheme,
                                onChanged: (value) {
                                  context.read<ThemeSettingCubit>().toggleTheme();
                                },
                              ),
                            if (function.dropdownCallback != null)
                              BlocBuilder<LanguageBloc, Locale>(builder: (context, state) {
                                return Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: textcolor, width: 1),
                                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: SizedBox(
                                    height: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      child: DropdownButton<Locale>(
                                          value: context.watch<LanguageBloc>().state,
                                          items: const [
                                            DropdownMenuItem(value: Locale('en'), child: Text('English')),
                                            DropdownMenuItem(value: Locale('ko'), child: Text('Korean')),
                                            DropdownMenuItem(
                                                value: Locale('vi'),
                                                child: Padding(
                                                  padding: EdgeInsets.only(right: 5),
                                                  child: Text('Vietnamese'),
                                                )),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              function.dropdownCallback!(value);
                                            }
                                          },
                                          dropdownColor: dropdownColor,
                                          style: GoogleFonts.montserrat(
                                            color: textcolor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          underline: Container(),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(15),
                                          )),
                                    ),
                                  ),
                                );
                              }),
                          ],
                        ),
                        if (idx != widget.functions.length - 1) const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
