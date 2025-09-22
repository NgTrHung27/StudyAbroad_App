import 'package:flutter/material.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class ResponseRequestedDetail extends StatelessWidget {
  final String title;
  final List<Reply> replies;

  const ResponseRequestedDetail({
    super.key,
    required this.title,
    required this.replies,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    final textBox = isDarkMode ? Colors.white : Colors.black;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final localizations = AppLocalizations.of(context);
    final resq = localizations != null ? localizations.resq : 'Default Text';
    final request = localizations != null ? localizations.resq_4 : 'Default Text';
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: screenHeight * 0.09,
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.redButton,
        title: Row(
          children: [
            const BackButtonCircle(),
            Expanded(
              child: Center(
                child: TextMonserats(
                  resq,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: screenHeight * 0.09),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06, vertical: screenWidth * 0.06),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          decoration: BoxDecoration(
            color: boxColor, // White background
            borderRadius: BorderRadius.circular(15.0), // Rounded corners
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: TextMonserats(
                  '$request:',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: textBox,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Center(
                  child: TextMonserats(
                    title,
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.w400,
                    color: textBox,
                  ),
                ),
              ),
              Divider(
                color: textBox,
                thickness: 3,
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: TextMonserats(
                  '$resq:',
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: textBox,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: replies.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: TextMonserats(
                            '- ${replies[index].message}',
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w400,
                            color: textBox,
                          ),
                        ),
                        Divider(
                          color: textBox,
                          thickness: 0.6,
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
