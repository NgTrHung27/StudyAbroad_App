import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kltn_mobile/blocs/theme_setting_cubit/theme_setting_cubit.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';
import 'package:kltn_mobile/models/schools.dart';

class CarouselSliderDataFound extends StatefulWidget {
  final List<Schools> carouselList;
  const CarouselSliderDataFound(this.carouselList, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CarouselSliderDataFoundState createState() => _CarouselSliderDataFoundState();
}

class _CarouselSliderDataFoundState extends State<CarouselSliderDataFound> {
  int _current = 0;
  late List<Widget> imageSlider;

  @override
  void initState() {
    imageSlider = widget.carouselList
        .map((e) => Container(
              margin: const EdgeInsets.all(10),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: e.background,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                        child: CircularProgressIndicator(
                          value: downloadProgress.progress,
                        ),
                      ),
                      fit: BoxFit.cover,
                      width: 1000,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withValues(alpha: 0.2),
                              Colors.black.withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: TextMonserats(e.name, fontSize: 20, color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
            ))
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select((ThemeSettingCubit cubit) => cubit.state.brightness == Brightness.dark);
    final circleBG = isDarkMode ? const Color(0xff616161) : Colors.white;
    final circleHL = isDarkMode ? Colors.white : const Color(0xff959595);

    final screenWidth = MediaQuery.of(context).size.width;
    double orientationSizeHor = MediaQuery.of(context).orientation == Orientation.portrait ? 1 : 0.7;
    final screenHeight = MediaQuery.of(context).size.height;
    double orientationSizeVer = MediaQuery.of(context).orientation == Orientation.portrait ? 0.25 : 0.5;
    return Column(
      children: [
        SizedBox(
          width: screenWidth * orientationSizeHor,
          height: screenHeight * orientationSizeVer,
          child: CarouselSlider(
              items: imageSlider,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 7.5,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  })),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.carouselList.map((e) {
            int index = widget.carouselList.indexOf(e);
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index ? circleHL : circleBG,
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
