import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/Style/simplebutton.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/list_view/scoretable.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/screens/score/pdf_score_api.dart';

class ScoreDetail extends BasePage {
  final String semester;
  final String year;
  const ScoreDetail({super.key, required this.semester, required this.year});

  @override
  ScoreDetailState createState() => ScoreDetailState();
}

class ScoreDetailState extends BasePageState<ScoreDetail> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final localizations = AppLocalizations.of(context);
    final sms = localizations != null ? localizations.scr_sms : "Default Text";
    final dwn = localizations != null ? localizations.scr_dwn : "Default Text";
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    List<Score>? scores = userAuth?.student.program?.scores;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: screenHeight * 0.15,
              color: AppColor.redButton,
              child: Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.05),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButtonCircle(),
                        TextMonserats(
                          '$sms ${widget.semester} \n ${widget.year}',
                          color: Colors.white,
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: screenWidth * 0.13,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.01),
              child: Column(
                children: [
                  SizedBox(height: screenHeight * 0.025),
                  ScoreTable(
                    semester: widget.semester,
                    year: widget.year,
                  ),
                  SizedBox(height: screenHeight * 0.025),
                  SizedBox(height: screenHeight * 0.025),
                  SimpleButton(
                    backgroundColor: const Color(0xffF58218),
                    onPressed: () async {
                      print('Download');
                      final pdfFile = await PdfScoreApi.generateScorePdf(scores!);
                      print(pdfFile);
                      PdfApi.openFile(pdfFile);
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: screenWidth * 0.009,
                          ),
                          TextMonserats(
                            dwn,
                            color: Colors.white,
                            fontSize: screenWidth * 0.04,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
