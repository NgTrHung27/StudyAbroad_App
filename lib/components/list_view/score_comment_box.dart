import 'package:flutter/material.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class ScoreCommentBox extends StatelessWidget {
  final String comment;

  const ScoreCommentBox({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context);
    final cmt = localizations != null ? localizations.scr_cmt : "Default Text";
    return Container(
      width: screenWidth,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.015),
      constraints: BoxConstraints(minHeight: screenHeight * 0.1),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextMonserats(
            cmt,
            color: AppColor.redButton,
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
          ),
          TextMonserats(
            comment,
            fontSize: 16.0,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
