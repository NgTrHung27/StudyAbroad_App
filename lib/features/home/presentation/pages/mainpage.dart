import 'package:easy_localization/easy_localization.dart';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/pages/ably_websocket.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/widgets/flash_dismissible_chatting_gemini_ai.dart';
import 'package:study_abroad_cemc_mobile/features/chatting/presentation/widgets/floating_chatting_position.dart';
import 'package:study_abroad_cemc_mobile/core/translations/translation_keys.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';

import 'package:study_abroad_cemc_mobile/features/notifications/presentation/pages/notifications_page.dart';
import 'package:study_abroad_cemc_mobile/features/profiles/presentation/pages/profile.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  final int initialIndex = 0;
  const MainPage({super.key, initialIndex = 0});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;

  final List<Widget> _bodyView = [
    const HomePage(),
    const AblyWebsocket(),
    const NotificationsPage(),
    const Profile()
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map && args.containsKey('index')) {
      setState(() {
        _currentIndex = args['index'];
      });
    }
  }

  Widget _tabItem(String icon, String label, int index) {
    bool isSelected = _currentIndex == index;
    String iconPath =
        isSelected ? '${icon}_selected.png' : '${icon}_unselected.png';

    return GestureDetector(
      onTap: () => onTabTapped(index),
      child: AnimatedContainer(
        margin: const EdgeInsets.all(8),
        alignment: Alignment.center,
        duration: const Duration(milliseconds: 500),
        decoration: !isSelected
            ? null
            : BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: AppColor.redLight,
              ),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset(iconPath, width: 24),
            Container(
              transform: Matrix4.translationValues(0.0, 3.0, 0.0),
              child: TextMonserats(
                label,
                fontSize: 12,
                color: isSelected ? Colors.white : AppColor.redButton,
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<String> _icons = [
    ImageAssets.iconHome,
    ImageAssets.iconMess,
    ImageAssets.iconNoti,
    ImageAssets.iconUser,
  ];

  @override
  Widget build(BuildContext context) {
    bool isRunningOnAndroid = Platform.isAndroid;
    final floatingHeight = isRunningOnAndroid ? 0.12 : 0.08;
    final screenHeight = MediaQuery.of(context).size.height;
    final List<String> labels = [
      navHomeKey.tr(),
      aiChattingNavKey.tr(),
      navNotiKey.tr(),
      navProfileKey.tr(),
    ];
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          Center(
            child: IndexedStack(
              index: _currentIndex,
              children: _bodyView,
            ),
          ),
          // Floating bottom navigation bar
          if (_currentIndex != 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent,
                height: 110,
                padding: const EdgeInsets.all(12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(_icons.length, (index) {
                          return _tabItem(_icons[index], labels[index], index);
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: _currentIndex != 1
          ? FloatingActionButton(
              onPressed: () => _showAIBottomSheet(context),
              backgroundColor: AppColor.redLight,
              child: const ImageIcon(
                AssetImage(ImageAssets.icon3dChatbot),
                size: 30,
                color: Colors.white,
              ),
            )
          : null,
      floatingActionButtonLocation: CustomFABLocation(
        FloatingActionButtonLocation.endFloat,
        screenHeight * floatingHeight,
      ),
    );
  }

  Future<void> _showAIBottomSheet(BuildContext context) async {
    return showModalBottomSheet(
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => FlashDismissibleBottomSheetView(
        childView: Container(
            width: double.infinity,
            color: Colors.white,
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("Chat AI",
                    style: TextStyle(fontSize: 30, color: Colors.blue)),
              ),
            )),
      ),
    );
  }
}
