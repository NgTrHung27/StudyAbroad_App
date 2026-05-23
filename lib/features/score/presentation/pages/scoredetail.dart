import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/Style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/Style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/Style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/features/score/presentation/widgets/scoretable.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/models/user_login.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';
import 'package:study_abroad_cemc_mobile/features/score/presentation/pages/pdf_score_api.dart';

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
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    List<Score>? scores = userAuth?.student?.program?.scores;

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
                          '${scrSmsKey.tr()} ${widget.semester} \n ${widget.year}',
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
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: screenHeight * 0.01),
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
                    backgroundColor: AppColor.orangeWarning,
                    onPressed: () async {
                      print('Download');
                      final pdfFile =
                          await PdfScoreApi.generateScorePdf(scores!);
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
                            scrDwnKey.tr(),
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
