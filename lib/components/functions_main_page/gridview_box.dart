import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/functions/alert_dialog.dart';
import 'package:study_abroad_cemc_mobile/components/functions_main_page/boxgradient.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/features/auth/presentation/pages/auth_data_notify.dart';
import 'package:provider/provider.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

class BoxGridView extends StatefulWidget {
  const BoxGridView({super.key});
  @override
  State<BoxGridView> createState() => _BoxGridViewState();
}

class _BoxGridViewState extends State<BoxGridView> {
  @override
  Widget build(BuildContext context) {
    final userAuth =
        context.watch<UserAuthProvider>().userAuthLogin;
    final isLoggedIn = userAuth != null;

    int crossAxisCount =
        MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 3;
    double childAspectRatio =
        MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 2.3;
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
            color1: AppColor.orangeAccent,
            color2: AppColor.redDanger,
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
            image: const AssetImage(ImageAssets.icon3dMedal),
          ),
          BoxGradient(
            color1: AppColor.tealLight,
            color2: AppColor.greenTeal,
            smallText: homeGreenNews1Key.tr(),
            bigText: homeGreenNews2Key.tr(),
            onTap: () {
              Navigator.pushNamed(context, "/news");
            },
            image: const AssetImage(ImageAssets.icon3dNewspaper),
          ),
          BoxGradient(
            color1: AppColor.cyanAccent,
            color2: AppColor.blue700,
            smallText: homeBlueComments1Key.tr(),
            bigText: homeBlueComments2Key.tr(),
            onTap: () {
              Navigator.pushNamed(context, "/contactus");
            },
            image: const AssetImage(ImageAssets.icon3dContact),
          ),
          BoxGradient(
            color1: AppColor.blueAccentLight,
            color2: AppColor.navyBlue,
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
            image: const AssetImage(ImageAssets.icon3dScholarship),
          ),
        ],
      ),
    );
  }
}
