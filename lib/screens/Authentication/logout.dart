import 'package:flutter/material.dart';
import 'package:kltn_mobile/components/style/backbutton.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/style/simplebutton.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';

class LogoutPage extends BasePage {
  const LogoutPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogoutPageState createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthscreen = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    double orientationSize = MediaQuery.of(context).orientation == Orientation.portrait ? 0.85 : 0.7;
    final localizations = AppLocalizations.of(context);
    final logout1 = localizations != null ? localizations.logout_1 : 'Default Text';
    final logout2 = localizations != null ? localizations.logout_2 : 'Default Text';
    final logout3 = localizations != null ? localizations.logout_3_signup : 'Default Text';
    final logout4 = localizations != null ? localizations.logout_4_signin : 'Default Text';
    final logout5 = localizations != null ? localizations.logout_5_home : 'Default Text';

    return Container(
        decoration: const BoxDecoration(
            image: DecorationImage(image: AssetImage("assets/backgrounds/backgr_logoutfin.png"), fit: BoxFit.cover)),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButtonCircle(onPressed: () {
                        Navigator.pop(context);
                      }),
                      //Logo
                      SizedBox(height: screenHeight * 0.15),
                      const Spacer(),
                      Image.asset("assets/logo/logo_red.png", height: 80),
                      const Spacer(),
                      Container(width: 35)
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.2),
                  TextMonserats(logout1, fontSize: 38, color: Colors.white),
                  SizedBox(height: screenHeight * 0.01),
                  TextMonserats(logout2, fontSize: 14, color: Colors.white),
                  SizedBox(height: screenHeight * 0.07),
                  Center(
                    child: SizedBox(
                        width: widthscreen * orientationSize,
                        height: 45,
                        child: SimpleButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/register');
                          },
                          child: TextMonserats(
                            logout3,
                            color: Colors.white,
                          ),
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
                            Navigator.pushNamed(context, '/login');
                          },
                          child: TextMonserats(
                            logout4,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
                            Navigator.pushNamed(context, '/mainpage');
                          },
                          child: TextMonserats(
                            logout5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                  ),
                ]),
              ),
            )));
  }
}
