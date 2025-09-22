import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/components/language/app_localizations.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/Style/backbutton.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:kltn_mobile/models/user_login.dart';
import 'package:kltn_mobile/screens/Authentication/auth_data_notify.dart';
import 'package:kltn_mobile/screens/home/base_lang.dart';
import 'package:kltn_mobile/screens/profiles/response_requested_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResponseRequested extends BasePage {
  const ResponseRequested({super.key});
  @override
  State<ResponseRequested> createState() => _RequestedState();
}

class _RequestedState extends BasePageState<ResponseRequested> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        getUserAuth(context);
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        checkLoginStatus();
      }
    });
  }

  Future<UserAuthLogin?> getUserAuth(BuildContext context) async {
    return userAuth ?? context.read<UserAuthProvider>().userAuthLogin;
  }

  Future<UserAuthLogin?> checkLoginStatus() async {
    late SharedPreferences logindata;
    UserAuthLogin? userAuthLogin;

    logindata = await SharedPreferences.getInstance();
    final userString = logindata.getString('user');
    if (userString != null) {
      final userMap = json.decode(userString);
      if (userMap['student'] != null) {}
    }
    return userAuthLogin;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final resq = localizations != null ? localizations.resq : 'Default Text';

    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final boxColor = isDarkMode ? AppColor.backgrTabDark : Colors.white;
    final textBox = isDarkMode ? Colors.white : Colors.black;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    //userAuth
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColor.redButton,
          toolbarHeight: screenHeight * 0.09,
          title: Row(
            children: [
              BackButtonCircle(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Center(
                  child: TextMonserats(
                    resq,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
        backgroundColor: context.select((ThemeSettingCubit cubit) => cubit.state.scaffoldBackgroundColor),
        body: FutureBuilder<UserAuthLogin?>(
            future: getUserAuth(context),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data == null) {
                return const Center(child: Text('User not logged in'));
              } else {
                // final userAuth = snapshot.data!;
                final List<Requirement>? requirementList = userAuth?.student.requirements;
                if (requirementList != null && requirementList != []) {
                  // Lọc danh sách requirementList để chỉ giữ lại các mục có status là RESOLVE hoặc REPLIED
                  // ignore: unnecessary_nullable_for_final_variable_declarations
                  final List<Requirement>? filteredRequirements = requirementList
                      .where((requirement) => requirement.status == 'RESOLVED' || requirement.status == 'REPLIED')
                      .toList();

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenWidth * 0.05),
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        decoration: BoxDecoration(
                          color: boxColor, // White background
                          borderRadius: BorderRadius.circular(15.0), // Rounded corners
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredRequirements?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final titleRe = filteredRequirements?[index].title;
                                  final detailRe = filteredRequirements?[index].description;

                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TextMonserats(
                                                titleRe ?? '',
                                                fontSize: screenWidth * 0.04,
                                                fontWeight: FontWeight.w600,
                                                color: textBox,
                                                textAlign: TextAlign.left,
                                              ),
                                              TextMonserats(
                                                detailRe ?? '',
                                                fontSize: screenWidth * 0.03,
                                                fontWeight: FontWeight.w400,
                                                color: textBox,
                                                maxLine: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        trailing: Icon(
                                          Icons.arrow_forward_ios,
                                          size: screenWidth * 0.04,
                                          color: textBox,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ResponseRequestedDetail(
                                                  title: titleRe ?? '',
                                                  replies: filteredRequirements![index].replies ?? []),
                                            ),
                                          );
                                        },
                                      ),
                                      if (index != filteredRequirements!.length - 1)
                                        const Divider(
                                          color: Colors.grey,
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        )),
                  );
                } else {
                  return const Center(child: Text('Không có dữ liệu'));
                }
              }
            }));
  }
}
