import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:study_abroad_cemc_mobile/components/constant/color_constant.dart';
import 'package:study_abroad_cemc_mobile/core/constants/image_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoTranslateAnimation;
  late Animation<double> _textOpacityAnimation;
  late Animation<double> _textTranslateAnimation;

  bool? _isFirstLaunch;
  bool _animationCompleted = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Logo scale: 1.0 to 1.125 (1 + 10/80)
    _logoScaleAnimation = Tween<double>(begin: 1.0, end: 1.125).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Logo translate: 0.0 to 10.0
    _logoTranslateAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Text opacity: 0.0 to 1.0
    _textOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Text translate: 50.0 to 0.0 (offset = 50 * (1 - value))
    _textTranslateAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Pre-fetch SharedPreferences immediately
    _checkFirstLaunch();

    // Start immediately since main() initialization is already complete
    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationCompleted = true;
        _navigateIfReady();
      }
    });
  }

  Future<void> _checkFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
      _navigateIfReady();
    } catch (e) {
      _isFirstLaunch = false;
      _navigateIfReady();
    }
  }

  void _navigateIfReady() async {
    if (_animationCompleted && _isFirstLaunch != null) {
      if (!mounted) return;
      if (_isFirstLaunch!) {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstLaunch', false);
        } catch (e) {
          // silent error
        }
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/intro');
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/mainpage');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo driven by _controller
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Transform.scale(
                    scale: _logoScaleAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _logoTranslateAnimation.value),
                      child: Image.asset(ImageAssets.logoRed, width: 100),
                    ),
                  ),
                );
              },
            ),
            // Animated text driven by _controller
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  margin: const EdgeInsets.only(top: 0),
                  child: Opacity(
                    opacity: _textOpacityAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, _textTranslateAnimation.value),
                      child: Text(
                        'Canada Education Manage Company',
                        style: GoogleFonts.montserrat(
                          color: AppColor.redButton,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
