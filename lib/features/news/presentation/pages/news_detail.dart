// FILE:NEWS_DETAIL.DART CONTEXT
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/news/domain/entities/news_entity.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsEntity news;
  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    DateTime createAt = news.createdAt;
    String formattedDate = DateFormat('dd/MM/yyyy').format(createAt);
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width, // full screen width
                  height: MediaQuery.of(context).size.height *
                      0.5, // half screen height
                  child: Image.network(news.cover,
                      fit: BoxFit.cover), // thumbnail image
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -120.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: context.select((ThemeSettingBloc bloc) =>
                        bloc.state.scaffoldBackgroundColor),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextMonserats(news.title,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                            fontSize: 22), // title
                        TextMonserats(
                          formattedDate,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                          fontSize: 16,
                        ),
                        const SizedBox(height: 10),
                        // TextMonserats(news.content,fontWeight: FontWeight.w500, color: Colors.black, fontSize: 20),  // content
                        Html(
                          data: news.content,
                          style: {
                            "p": Style(
                                fontSize: FontSize(16),
                                color: textColor,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                textDecorationColor: textColor
                                ),
                            "h2": Style(
                                fontSize: FontSize(22),
                                color: textColor,
                                fontFamily: GoogleFonts.montserrat().fontFamily,
                                textDecorationColor: textColor),
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: BackButtonCircle(
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
