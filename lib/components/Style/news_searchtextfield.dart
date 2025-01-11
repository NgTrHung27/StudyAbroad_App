import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kltn_mobile/screens/home/search_page.dart';

class NewsSearchTextField extends StatelessWidget {
  const NewsSearchTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final textSearch =
        localizations != null ? localizations.home_search : 'Default Text';
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
                borderSide: BorderSide(color: Colors.white, width: 0.0),
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              hintText: textSearch,
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
