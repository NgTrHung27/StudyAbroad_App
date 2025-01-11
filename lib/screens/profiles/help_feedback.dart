// FILE:NEWS_DETAIL.DART CONTEXT
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';

import '../../components/style/backbutton.dart';

class HelpFeedback extends StatelessWidget {
  const HelpFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final bgColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    final bgPic = isDarkMode ? AppColor.scafflodBgColorDark : Colors.white;
    final height = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ListView(
              children: [
                Container(
                  color: bgPic,
                  width: MediaQuery.of(context).size.width, // full screen width
                  height: MediaQuery.of(context).size.height * 0.3, // half screen height
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: isDarkMode ? 0 : 0.1),
                          Colors.black.withValues(alpha: isDarkMode ? 0 : 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Image.asset('assets/backgrounds/help&feedback.png'),
                  ), // thumbnail image
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.6),
                  child: Container(
                    transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    decoration:
                        BoxDecoration(color: bgColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextMonserats('Introduce about CEMC CO., LTD',
                              fontWeight: FontWeight.w700, color: textColor, fontSize: 22), // title
                          const SizedBox(height: 10),
                          const TextMonserats(
                              'Tax Code: 0317892172 \nHead Office Address: 25/20 Tai Thiet, Ward 11, \nTan Binh District, Ho Chi Minh City, Vietnam \nPhone: 0984122837 \nEmail: Services@mecltd.edu.vn \nFacebook: CEMC CO., LTD',
                              fontWeight: FontWeight.w500),
                          SizedBox(height: height * 0.04),
                          const TextMonserats(
                            'Study Abroad Consulting Services: ',
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                          const TextMonserats(
                              height: 2.5,
                              fontWeight: FontWeight.w500,
                              'The company provides information and support for students in finding study abroad programs, applying for admission, handling visa procedures, finding accommodation, and providing support for life and studies after students arrive in Canada.We have a team of experienced and knowledgeable staff regarding educational')
                        ],
                      ),
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
