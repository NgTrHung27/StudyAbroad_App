import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  Widget build(BuildContext context) {
    final widthscreen = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double orientationSize =
        MediaQuery.of(context).orientation == Orientation.portrait ? 0.85 : 0.7;

    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImageAssets.bgLogoutFin),
                fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 40),
                          SizedBox(height: screenHeight * 0.15),
                          const Spacer(),
                          Image.asset(ImageAssets.logoRed, height: 80),
                          const Spacer(),
                          Container(width: 35)
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.2),
                      TextMonserats(logoutTitle1Key.tr(),
                          fontSize: 38, color: Colors.white),
                      SizedBox(height: screenHeight * 0.01),
                      TextMonserats(logoutTitle2Key.tr(),
                          fontSize: 14, color: Colors.white),
                      SizedBox(height: screenHeight * 0.07),
                      Center(
                        child: SizedBox(
                            width: widthscreen * orientationSize,
                            height: 45,
                            child: SimpleButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/register', (route) => false);
                              },
                              child: TextMonserats(logoutSignUpKey.tr(),
                                  color: Colors.white),
                            )),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: SizedBox(
                            width: widthscreen * orientationSize,
                            child: SimpleButton(
                              backgroundColor: Colors.transparent,
                              borderColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/login', (route) => false);
                              },
                              child: TextMonserats(logoutSignInKey.tr(),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Center(
                        child: SizedBox(
                            width: widthscreen * orientationSize,
                            child: SimpleButton(
                              backgroundColor: Colors.transparent,
                              borderColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/mainpage', (route) => false);
                              },
                              child: TextMonserats(logoutHomeKey.tr(),
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                    ]),
              ),
            )));
  }
}
