// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/auth_cubit_bloc/login_cubit.dart';
import 'package:kltn_mobile/blocs/lang_cubit/language_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/style/backbutton.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/components/style/textspan.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/components/constant/theme.dart';
import 'package:kltn_mobile/components/functions/button.dart';
import 'package:kltn_mobile/components/functions/text_field.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';

class LoginPage extends BasePage {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BasePageState<LoginPage> {
  String email = '';
  String password = '';
  String? errorMessage;
  bool? isRememberChange = false;
  int selectedValue = 0;
  bool isLoading = false;
  //Text Editing Controller
  final usermailController = TextEditingController();
  final passwordController = TextEditingController();
// LoginUser Method for API
  void userLogin(BuildContext context) {
    // Get email and password values from TextFields
    setState(() {
      isLoading = true;
    });
    String email = usermailController.text.trim();
    String password = passwordController.text.trim();
    log('data email: $email');
    log('data pass: $password');

    // Call login method from LoginCubit
    context.read<LoginCubit>().login(email, password, isRememberChange!).then((_) {
      final loginCubit = context.read<LoginCubit>();
      if (loginCubit.state is LoginSuccess) {
        final userAuth = (loginCubit.state as LoginSuccess).userAuthLogin;
        Navigator.pushNamed(
          context,
          '/mainpage',
        );
        context.read<UserAuthProvider>().setUserAuthLogin(userAuth);

        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void changeSelectedValueRadio(bool? isRemember) {
    setState(() {
      isRememberChange = isRemember;
    });
  }

  @override
  Widget build(BuildContext context) {
    //size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    //language
    final localizations = AppLocalizations.of(context);
    final welcome = localizations != null ? localizations.login_welcome : 'Default Text';
    final loginContinue = localizations != null ? localizations.login_continue : 'Default Text';
    final emailText = localizations != null ? localizations.register_login_cpass__fg_mail : 'Default Text';
    final passText = localizations != null ? localizations.register_login_cpass__fg_pass : 'Default Text';
    final remem = localizations != null ? localizations.login_remember : 'Default Text';
    final signin = localizations != null ? localizations.register_login_signin : 'Default Text';
    final signup = localizations != null ? localizations.logout_3_signup : 'Default Text';
    final forgot = localizations != null ? localizations.login_forgot : 'Default Text';
    final notAccout = localizations != null ? localizations.login_donot : 'Default Text';
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final textColorRed = isDarkMode ? Colors.white : AppColor.redButton;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(context.watch<ThemeSettingCubit>().state == AppTheme.blackTheme
                  ? "assets/backgrounds/bckgr_login_dark.jpg"
                  : "assets/backgrounds/bckgr_login.jpg"),
              fit: BoxFit.cover)),
      child: Stack(children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginInitial) {
                setState(() {
                  errorMessage = null;
                  isLoading = false;
                });
              } else if (state is LoginFailure) {
                setState(() {
                  errorMessage = state.error;
                  isLoading = false;
                });
              } else if (state is EmailError) {
                setState(() {
                  errorMessage = state.error;
                  isLoading = false;
                });
              } else if (state is LoginLoading) {
                setState(() {
                  isLoading = true;
                });
              } else if (state is LoginSuccess) {
                isLoading = false;
              } else {
                setState(() {
                  isLoading = false;
                });
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: BlocBuilder<LanguageBloc, Locale>(
                  builder: (context, state) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BackButtonCircle(onPressed: () {
                                Navigator.pushNamed(context, '/logout');
                              }),
                              //Logo
                              SizedBox(width: screenWidth * 0.20),
                              Image.asset(
                                context.watch<ThemeSettingCubit>().state == AppTheme.blackTheme
                                    ? "assets/logo/logo_white.png"
                                    : "assets/logo/logo_red.png",
                                height: 80,
                              ),
                              SizedBox(width: screenWidth * 0.25),
                              Container(width: 35)
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextMonserats(
                              welcome,
                              fontSize: 30,
                              color: textColorRed,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: TextMonserats(
                              loginContinue,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          //Email TextFied
                          SizedBox(height: screenHeight * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyTextField(
                                controller: usermailController,
                                hintText: emailText,
                                keyboardType: TextInputType.emailAddress,
                                obscureText: false,
                                prefixIcon: Icons.email,
                                onChanged: (value) {
                                  // Lưu giá trị email mới được nhập
                                  email = value;
                                  context.read<LoginCubit>().checkEmail(email);
                                },
                              ),
                            ],
                          ),
                          //Pass TextFied
                          SizedBox(height: screenHeight * 0.001),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyTextField(
                                controller: passwordController,
                                hintText: passText,
                                obscureText: true,
                                prefixIcon: Icons.lock,
                                onChanged: (value) {
                                  // Lưu giá trị password mới được nhập
                                  password = value;
                                },
                              ),
                            ],
                          ),
                          //Error Message
                          if (errorMessage != null)
                            Center(
                              child: TextMonserats(
                                errorMessage!,
                                color: Colors.red,
                              ),
                            ),
                          //Forgot Pass
                          Row(
                            children: [
                              Transform.scale(
                                  scale: 0.8, // Adjust the scale factor as needed
                                  child: Checkbox(
                                    checkColor: Colors.white,
                                    value: isRememberChange,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    fillColor: WidgetStateProperty.all<Color>(AppColor.redButton),
                                    onChanged: (bool? value) {
                                      changeSelectedValueRadio(value!);
                                    },
                                  )),
                              TextMonserats(
                                remem,
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                              ),
                            ],
                          ),

                          //Login Button
                          SizedBox(height: screenHeight * 0.04),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                onTap: () => userLogin(context),
                                text: signin,
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          //Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // Navigate to the ForgetPass screen
                                  Navigator.pushNamed(context, "/forgotpass");
                                },
                                child: TextMonserats(
                                  forgot,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.25),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Divider(
                                height: 1,
                                color: Color(0xFFCBD5E1),
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
                                      styledTextSpan(
                                        notAccout,
                                        color: textColor,
                                      ),
                                      styledTextSpan(
                                        signup,
                                        color: AppColor.redButton,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                        decorationColor: const Color(0xff7D1F1F), // Change the color of the underline
                                        decorationStyle: TextDecorationStyle.solid, // Change the number of lines
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.pushNamed(context, "/register");
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
        if (isLoading)
          Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
      ]),
    );
  }
}
