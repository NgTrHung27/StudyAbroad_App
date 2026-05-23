import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/login_bloc.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/bloc/legacy/login_event.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_bloc.dart';
import 'package:study_abroad_cemc_mobile/blocs/theme_setting_cubit/theme_setting_event.dart';
import 'package:study_abroad_cemc_mobile/components/action/action_tab.dart';
import 'package:study_abroad_cemc_mobile/components/action/id_tab.dart';
import 'package:study_abroad_cemc_mobile/components/action/id_tab_logout.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/functions/alert_dialog.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/components/style/simplebutton.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/features/home/presentation/pages/base_lang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends BasePage {
  const Profile({super.key});

  @override
  State<Profile> createState() => _UserProfileState();
}

class _UserProfileState extends BasePageState<Profile> {
  bool isChangeColor = false;

  @override
  void initState() {
    super.initState();
    _loadIconState();

    // Fetch fresh profile data in background
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<UserAuthProvider>().fetchFreshProfile();
      }
    });
  }

  Future<void> _loadIconState() async {
    final prefs = await SharedPreferences.getInstance();
    isChangeColor = prefs.getBool('isChangeColor') ?? false;
    setState(() {});
  }

  void toggleTheme() {
    context.read<ThemeSettingBloc>().add(ToggleThemeEvent());
    setState(() {
      isChangeColor = !isChangeColor;
    });
  }

  void userLogout(BuildContext context) {
    context.read<LoginBloc>().add(LogoutEvent());
  }

  @override
  Widget build(BuildContext context) {
    final userAuth =
        this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final isLoggedIn = userAuth != null;

    final logoutText =
        isLoggedIn ? profileLogoutSS1Key.tr() : profileLogoutSS2Key.tr();

    final screenHeight = MediaQuery.of(context).size.height;
    final backgroundColor = context.select(
      (ThemeSettingBloc bloc) => bloc.state.isDarkMode
          ? AppColor.backgrTabDark
          : AppColor.backgrTabLight,
    );
    final colorIcon = context.select(
      (ThemeSettingBloc bloc) =>
          bloc.state.isDarkMode ? Colors.white : Colors.black,
    );

    return Scaffold(
      backgroundColor: context.select(
          (ThemeSettingBloc bloc) => bloc.state.scaffoldBackgroundColor),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          if (!mounted) return;
          // ignore: use_build_context_synchronously
          final loginBloc = context.read<LoginBloc>();
          loginBloc.add(AutoLoginEvent());
        },
        child: Stack(
          children: <Widget>[
            Container(
              color: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.08),
                    // UserID and UserName
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLoggedIn
                            ? IdTab(
                                userName: homeHelloKey.tr(),
                                idUser: userAuth.name ?? 'User',
                                avatarImgUrl: userAuth.student?.school
                                    .logo, // Sử dụng hình ảnh từ API nếu có
                                avatarImgPath: 'assets/logo/logo_white.png',
                              )
                            : IdTabLogout(
                                textTab: registerSignInKey.tr(),
                                avatarImgPath: 'assets/logo/logo_white.png',
                              )
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    ActionTab(
                      header: profileAccountKey.tr(),
                      backgroundColor: backgroundColor,
                      colorIcon: colorIcon,
                      functions: [
                        FunctionItem(
                            name: profileAccountInfoKey.tr(),
                            icon: Icons.person,
                            onTap: () {
                              isLoggedIn
                                  ? Navigator.pushNamed(
                                      context, '/profiledetail')
                                  : showCustomDialog(
                                      context: context,
                                      onConfirm: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                    );
                            }),
                        FunctionItem(
                            name: profileChangePasswordKey.tr(),
                            icon: Icons.key,
                            onTap: () {
                              isLoggedIn
                                  ? Navigator.pushNamed(context, '/changepass')
                                  : showCustomDialog(
                                      context: context,
                                      onConfirm: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                    );
                            }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ActionTab(
                      header: profileStatusKey.tr(),
                      backgroundColor: backgroundColor,
                      colorIcon: colorIcon,
                      functions: [
                        FunctionItem(
                            name: profileStatusPS1Key.tr(),
                            icon: Icons.account_circle,
                            onTap: () {
                              isLoggedIn
                                  ? Navigator.pushNamed(
                                      context, '/profilestatus')
                                  : showCustomDialog(
                                      context: context,
                                      onConfirm: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                    );
                            }),
                        FunctionItem(
                          name: profileStatusPS2Key.tr(),
                          icon: Icons.school_outlined,
                          onTap: () {
                            isLoggedIn
                                ? Navigator.pushNamed(context, '/scholarDetail')
                                : showCustomDialog(
                                    context: context,
                                    onConfirm: () {
                                      Navigator.pushNamed(context, '/login');
                                    },
                                  );
                          },
                        ),
                        FunctionItem(
                            name: profileStatusPS3Key.tr(),
                            icon: Icons.payment,
                            onTap: () {
                              isLoggedIn
                                  ? Navigator.pushNamed(context, '/tuition')
                                  : showCustomDialog(
                                      context: context,
                                      onConfirm: () {
                                        Navigator.pushNamed(context, '/login');
                                      },
                                    );
                            }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ActionTab(
                      header: requestStaKey.tr(),
                      backgroundColor: backgroundColor,
                      colorIcon: colorIcon,
                      functions: [
                        FunctionItem(
                          name: request1Key.tr(),
                          icon: Icons.mail_outline,
                          onTap: () {
                            Navigator.pushNamed(context, '/respondrequest');
                          },
                        ),
                        FunctionItem(
                          name: request2Key.tr(),
                          icon: Icons.mark_email_read_outlined,
                          onTap: () {
                            Navigator.pushNamed(context, '/respondrequested');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ActionTab(
                      header: profileSettingKey.tr(),
                      backgroundColor: backgroundColor,
                      colorIcon: colorIcon,
                      functions: [
                        FunctionItem(
                          name: profileLanguageKey.tr(),
                          icon: Icons.language,
                          dropdownCallback: (Locale newValue) {
                            context.setLocale(newValue);
                          },
                        ),
                        FunctionItem(
                          name: profileScreenModeKey.tr(),
                          icon: Icons.nightlight_round,
                          isEnable: true,
                          switchValue: false,
                        ),
                        FunctionItem(
                            name: profileSupportKey.tr(),
                            icon: Icons.question_mark_rounded,
                            onTap: () {
                              Navigator.pushNamed(context, '/help&feedback');
                            }),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SimpleButton(
                      onPressed: () {
                        userLogout(context);
                        Navigator.pushNamed(context, '/logout');
                      },
                      child: TextMonserats(logoutText,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
