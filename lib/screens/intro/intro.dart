import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:kltn_mobile/components/Style/montserrat.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  IntroPageState createState() => IntroPageState();
}

class IntroPageState extends State<IntroPage> {
  final PageController _controller = PageController();

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
              height: screenHeight * 0.6,
              width: double.infinity,
              child: PageView(
                controller: _controller,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == 2;
                  });
                },
                children: [
                  BuildIntroPage(
                    img: 'assets/Education.gif',
                    description: 'Choose international affiliated universities',
                  ),
                  BuildIntroPage(
                    img: 'assets/CA.gif',
                    description: 'We manage progress and application status',
                  ),
                  BuildIntroPage(
                    img: 'assets/Graduation.gif',
                    description: 'Easily manage points and scholarships according to your wishes',
                  ),
                ],
              )),
          Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              onDotClicked: (index) {
                _controller.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeIn);
              },
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.grey,
                dotHeight: 7.0,
                dotWidth: 7.0,
                dotColor: Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: AppColor.redButton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isLastPage
                    ? () {
                        Navigator.pushReplacementNamed(context, '/mainpage');
                      }
                    : () {
                        _controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                child: TextMonserats(
                  isLastPage ? 'Done' : 'Next',
                  color: Colors.white,
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: isLastPage
                ? Container(
                    height: screenHeight * 0.055,
                  )
                : TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: AppColor.redButton, width: 1)),
                    onPressed: () {
                      _controller.jumpToPage(2);
                    },
                    child: TextMonserats(
                      'Skip',
                      color: AppColor.redButton,
                    )),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class BuildIntroPage extends StatelessWidget {
  String img;
  String description;
  BuildIntroPage({
    super.key,
    required this.description,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Gif(
            image: AssetImage(img),
            placeholder: (BuildContext context) => const Center(
              child: CircularProgressIndicator(),
            ),
            autostart: Autostart.once,
            duration: const Duration(milliseconds: 800),
          ),
          TextMonserats(
            description,
            color: AppColor.redButton,
            fontSize: 20,
            height: 1.5,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
