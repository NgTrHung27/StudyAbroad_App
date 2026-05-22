import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/functions/alert_dialog.dart';
import 'package:study_abroad_cemc_mobile/components/functions_main_page/boxgradient.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:study_abroad_cemc_mobile/screens/home/base_lang.dart';
import 'package:provider/provider.dart';

class BoxGridView extends BasePage {
  const BoxGridView({super.key});
  @override
  State<BoxGridView> createState() => _BoxGridViewState();
}

class _BoxGridViewState extends BasePageState<BoxGridView> {
  @override
  Widget build(BuildContext context) {
    final userAuth = this.userAuth ?? context.watch<UserAuthProvider>().userAuthLogin;
    final isLoggedIn = userAuth != null;

    int crossAxisCount = MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3;
    double childAspectRatio = MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2.3;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      height: MediaQuery.of(context).orientation == Orientation.portrait
          ? 330
          : 330, // Điều chỉnh chiều cao khi thiết bị xoay

      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 17,
        mainAxisSpacing: 17,
        childAspectRatio: height * childAspectRatio / 755,
        children: [
          BoxGradient(
            color1: const Color(0xffFF9736),
            color2: const Color(0xffC41010),
            smallText: homeOrangeScore1Key.tr(),
            bigText: homeOrangeScore2Key.tr(),
            onTap: () {
              isLoggedIn
                  ? Navigator.pushNamed(context, '/score')
                  : showCustomDialog(
                      context: context,
                      onConfirm: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    );
            },
            image: const AssetImage('assets/icons_3d/icon_3d_medal.png'),
          ),
          BoxGradient(
            color1: const Color(0xff86E0D0),
            color2: const Color(0xff3A9571),
            smallText: homeGreenNews1Key.tr(),
            bigText: homeGreenNews2Key.tr(),
            onTap: () {
              Navigator.pushNamed(context, "/news");
            },
            image: const AssetImage('assets/icons_3d/icon_3d_newspaper.png'),
          ),
          BoxGradient(
            color1: const Color(0xff80E8FF),
            color2: const Color(0xff297BC5),
            smallText: homeBlueComments1Key.tr(),
            bigText: homeBlueComments2Key.tr(),
            onTap: () {
              Navigator.pushNamed(context, "/contactus");
            },
            image: const AssetImage('assets/icons_3d/icon_3d_contact.png'),
          ),
          BoxGradient(
            color1: const Color(0xff608AFF),
            color2: const Color(0xff131166),
            smallText: homeBlueSchols1Key.tr(),
            bigText: homeBlueSchols2Key.tr(),
            onTap: () {
              isLoggedIn
                  ? Navigator.pushNamed(context, '/scholarship')
                  : showCustomDialog(
                      context: context,
                      onConfirm: () {
                        Navigator.pushNamed(context, '/login');
                      },
                    );
            },
            image: const AssetImage('assets/icons_3d/icon_3d_scholarship.png'),
          ),
        ],
      ),
    );
  }
}
