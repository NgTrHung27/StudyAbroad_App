import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/constant/theme.dart';

class IdTab extends StatefulWidget {
  final String userName;
  final String idUser;
  final String? avatarImgUrl;
  final String avatarImgPath;

  const IdTab({
    super.key,
    required this.userName,
    required this.idUser,
    this.avatarImgUrl,
    required this.avatarImgPath,
  });

  @override
  State<IdTab> createState() => _IdTabState();
}

class _IdTabState extends State<IdTab> {
  @override
  Widget build(BuildContext context) {
    final ImageProvider<Object> imageWidget = widget.avatarImgUrl != null
        ? CachedNetworkImageProvider(widget.avatarImgUrl!)
            as ImageProvider<Object>
        : AssetImage(widget.avatarImgPath) as ImageProvider<Object>;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode =
        context.watch<ThemeSettingCubit>().state == AppTheme.blackTheme;
    return Container(
      height: 80,
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColor.scafflodBgColorDark : AppColor.redButton,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isDarkMode ? Colors.white : Colors.transparent, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 20,
            bottom: 10,
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageWidget,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: 17,
            left: 85,
            bottom: 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName, // Name User
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.idUser, // ID User
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
