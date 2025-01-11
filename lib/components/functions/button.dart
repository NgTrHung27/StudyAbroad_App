import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text; // Thêm tham số text
  const MyButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenWidth * 0.9,
        height: 45,
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: AppColor.redButton,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1), // Color of the shadow
              spreadRadius: 2, // Spread radius
              blurRadius: 3, // Blur radius
              offset: const Offset(0, 5), // Offset in x and y directions
            ),
          ],
        ),
        child: Center(
          child: Text(
            text, // Sử dụng tham số text
            style: GoogleFonts.getFont(
              'Montserrat',
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}
