import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/search_page.dart';

class NewsSearchTextField extends StatelessWidget {
  const NewsSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    double orientationSize =
        MediaQuery.of(context).orientation == Orientation.portrait
            ? 0.055
            : 0.15;
    final screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SearchPage(),
          ),
        );
      },
      child: AbsorbPointer(
        child: SizedBox(
          height: screenHeight * orientationSize,
          child: TextField(
            style: GoogleFonts.getFont(
              'Montserrat',
              color: AppColor.redButton,
              fontSize: 19.0,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColor.redButton,
                  width: 1.0,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.borderGrey, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              hintText: homeSearchKey.tr(),
              hintStyle: GoogleFonts.getFont('Montserrat',
                  color: AppColor.redButton.withValues(alpha: 0.6),
                  fontSize: 19.0,
                  fontWeight: FontWeight.w500),
              prefixIcon: Icon(
                Icons.search,
                color: AppColor.redButton,
                size: 30.0,
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
