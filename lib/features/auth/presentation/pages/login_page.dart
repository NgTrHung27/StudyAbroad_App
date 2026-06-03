import 'package:easy_localization/easy_localization.dart';

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/login_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/style/textspan.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions/button.dart';
import 'package:study_abroad_cemc_mobile/components/functions/text_field.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  String? errorMessage;
  bool? isRememberChange = false;
  int selectedValue = 0;
  bool isLoading = false;
  final usermailController = TextEditingController();
  final passwordController = TextEditingController();

  void userLogin(BuildContext context) {
    String email = usermailController.text.trim();
    String password = passwordController.text.trim();
    log('data email: $email');
    log('data pass: $password');
    context
        .read<LoginBloc>()
        .add(LoginRequested(email: email, password: password));
  }

  void changeSelectedValueRadio(bool? isRemember) {
    setState(() {
      isRememberChange = isRemember;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkMode = context.select(
        (ThemeSettingBloc bloc) => bloc.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                  context.watch<ThemeSettingBloc>().state.isDarkMode
                      ? ImageAssets.bgLoginDark
                      : ImageAssets.bgLogin),
              fit: BoxFit.cover)),
      child: Stack(children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginInitial) {
                setState(() {
                  errorMessage = null;
                  isLoading = false;
                });
              } else if (state is LoginFailure) {
                setState(() {
                  errorMessage = state.message;
                  isLoading = false;
                });
              } else if (state is LoginLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is LoginSuccess) {
                setState(() {
                  isLoading = false;
                });
                // Navigate to mainpage when login succeeds
                context.read<UserAuthProvider>().setUserAuthLogin();
                Navigator.pushNamed(context, '/mainpage');
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.05,
                      right: screenWidth * 0.05,
                      top: screenHeight * 0.05,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButtonCircle(onPressed: () {
                          Navigator.pushNamed(context, '/logout');
                        }),
                        SizedBox(width: screenWidth * 0.20),
                        Image.asset(
                          context.watch<ThemeSettingBloc>().state.isDarkMode
                              ? ImageAssets.logoWhite
                              : ImageAssets.logoRed,
                          height: 80,
                        ),
                        SizedBox(width: screenWidth * 0.25),
                        Container(width: 35)
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: screenHeight * 0.02),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: TextMonserats(loginWelcomeKey.tr(),
                                  fontSize: 30, color: textColorRed),
                            ),
                            SizedBox(height: screenHeight * 0.008),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: TextMonserats(loginContinueKey.tr(),
                                  fontSize: 15, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyTextField(
                                  controller: usermailController,
                                  hintText: registerEmailKey.tr(),
                                  keyboardType: TextInputType.emailAddress,
                                  obscureText: false,
                                  prefixIcon: Icons.email,
                                  onChanged: (value) {
                                    email = value;
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.001),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyTextField(
                                  controller: passwordController,
                                  hintText: registerPasswordKey.tr(),
                                  obscureText: true,
                                  prefixIcon: Icons.lock,
                                  onChanged: (value) {
                                    password = value;
                                  },
                                ),
                              ],
                            ),
                            if (errorMessage != null)
                              Center(
                                child: TextMonserats(errorMessage!,
                                    color: Colors.red),
                              ),
                            // Row(
                            //   children: [
                            //     Transform.scale(
                            //         scale: 0.8,
                            //         child: Checkbox(
                            //           checkColor: Colors.white,
                            //           value: isRememberChange,
                            //           shape: RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(50)),
                            //           fillColor: WidgetStateProperty.all<Color>(
                            //               AppColor.redButton),
                            //           onChanged: (bool? value) {
                            //             changeSelectedValueRadio(value!);
                            //           },
                            //         )),
                            //     TextMonserats(loginRememberKey.tr(),
                            //         fontWeight: FontWeight.w400, fontSize: 15),
                            //   ],
                            // ),
                            SizedBox(height: screenHeight * 0.04),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                MyButton(
                                  onTap: () => userLogin(context),
                                  text: registerSignInKey.tr(),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, "/forgotpass");
                                  },
                                  child: TextMonserats(loginForgotKey.tr(),
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.25),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Divider(
                                  height: 1,
                                  color: AppColor.borderGrey,
                                  thickness: 1.0,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                SizedBox(height: screenHeight * 0.02),
                                Align(
                                  alignment: Alignment.center,
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        styledTextSpan(loginDoNotKey.tr(),
                                            color: textColor),
                                        styledTextSpan(
                                          ' ${logoutSignUpKey.tr()}',
                                          color: AppColor.redButton,
                                          fontWeight: FontWeight.w700,
                                          decoration: TextDecoration.underline,
                                          decorationColor: AppColor.redButton,
                                          decorationStyle:
                                              TextDecorationStyle.solid,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pushNamed(
                                                  context, "/register");
                                            },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        if (isLoading)
          Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withValues(alpha: 0.1)),
              ),
              const Center(child: CircularProgressIndicator()),
            ],
          ),
      ]),
    );
  }
}
