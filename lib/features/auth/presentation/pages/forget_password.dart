import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/forgot_pass_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/forgot_pass_state.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/functions/button.dart';
import 'package:study_abroad_cemc_mobile/components/functions/text_field.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';

class ForgetPass extends BasePage {
  const ForgetPass({super.key});
  @override
  State<ForgetPass> createState() => _ForgetPassState();
}

class _ForgetPassState extends BasePageState<ForgetPass> {
  String email = '';
  String? errorMessage;
  final usermailController = TextEditingController();

  void userForgetPass(BuildContext context) async {
    try {
      email = usermailController.text.trim();
      await context.read<ForgotPassBloc>().accept(email);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(context.watch<ThemeSettingBloc>().state.isDarkMode
                ? 'assets/backgrounds/bckgr_fgpass_dark.jpg'
                : 'assets/backgrounds/bckgr_fgpass.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<ForgotPassBloc, ForgotPassState>(
            listener: (context, state) {
              if (state is ForgotPassLoading) {
                const Center(child: CircularProgressIndicator());
              }
              if (state is ForgotPassFailure) {
                setState(() {
                  errorMessage = state.error;
                });
              } else if (state is ForgotPassSuccess) {
                errorMessage = 'Verification email has been sent!';
              } else if (state is ForgotPassEmailError) {
                setState(() {
                  errorMessage = state.error;
                });
              } else if (state is ForgotPassInitial) {
                setState(() {
                  errorMessage = null;
                });
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.05,
                    vertical: screenHeight * 0.05),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButtonCircle(onPressed: () {
                            Navigator.pop(context);
                          }),
                          //Logo
                          SizedBox(width: screenWidth * 0.20),
                          Image.asset(
                            context.watch<ThemeSettingBloc>().state.isDarkMode
                                ? "assets/logo/logo_white.png"
                                : "assets/logo/logo_red.png",
                            height: 80,
                          ),
                          SizedBox(width: screenWidth * 0.25),
                          Container(width: 35)
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextMonserats(
                            forgotTitleKey.tr(),
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                          ),
                          const SizedBox(height: 10),
                          TextMonserats(
                            forgotSubtitleKey.tr(),
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextMonserats(
                                forgotEmailKey.tr(),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  MyTextField(
                                    controller: usermailController,
                                    hintText: registerEmailKey.tr(),
                                    obscureText: false,
                                    prefixIcon: Icons.email,
                                    onChanged: (value) {
                                      email = value;
                                      context
                                          .read<ForgotPassBloc>()
                                          .errorEmail(email);
                                    },
                                  ),
                                  // Display errorMessage if it is not null
                                  if (errorMessage != null)
                                    TextMonserats(
                                      errorMessage!,
                                      color: Colors.red,
                                      textAlign: TextAlign.left,
                                    ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MyButton(
                                text: forgotSendKey.tr(),
                                onTap: () {
                                  userForgetPass(context);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.32),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate back to login screen
                                      Navigator.pop(context);
                                    },
                                    child: TextMonserats(
                                      forgotBackSignInKey.tr(),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ));
            },
          ),
        ),
      ),
    );
  }
}
