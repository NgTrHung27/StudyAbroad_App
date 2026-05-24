import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/change_pass_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/components/style/backbutton.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/functions/button.dart';
import 'package:study_abroad_cemc_mobile/components/functions/text_field.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

class ChangePass extends StatefulWidget {
  const ChangePass({super.key});
  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  String email = '';
  String? errorMessage;
  final usermailController = TextEditingController();

  void userChangePass(BuildContext context) async {
    try {
      email = usermailController.text.trim();
      await context.read<ChangePassBloc>().accept(email);
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
                ? ImageAssets.bgForgotPassDark
                : ImageAssets.bgForgotPass),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: BlocConsumer<ChangePassBloc, ChangePassState>(
            listener: (context, state) {
              if (state is ChangePassLoading) {
                const Center(child: CircularProgressIndicator());
              }
              if (state is ChangePassFailure) {
                setState(() {
                  errorMessage = state.message;
                });
              } else if (state is ChangePassSuccess) {
                errorMessage = 'Password changed successfully!';
              } else if (state is ChangePassEmailError) {
                setState(() {
                  errorMessage = state.message;
                });
              } else if (state is ChangePassInitial) {
                setState(() {
                  errorMessage = null;
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
                          Navigator.pop(context);
                        }),
                        //Logo
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextMonserats(
                            changePassTitleKey.tr(),
                            textAlign: TextAlign.center,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                          ),
                          const SizedBox(height: 10),
                          TextMonserats(
                            changePassSubtitleKey.tr(),
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
                                          .read<ChangePassBloc>()
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
                                  userChangePass(context);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.28),
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
                                      Navigator.pushNamed(context, '/login');
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
      ),
    );
  }
}
