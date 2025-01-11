import 'package:flutter/material.dart';
import 'package:kltn_mobile/components/style/montserrat.dart';

class BoxGradient extends StatelessWidget {
  final Color color1;
  final Color color2;
  final String smallText;
  final String bigText;
  final Function()? onTap;
  final AssetImage image;
  const BoxGradient(
      {super.key,
      required this.color1,
      required this.color2,
      required this.smallText,
      required this.bigText,
      this.onTap,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset.fromDirection(1.5, 2.5),
            ),
          ],
          color: const Color((0xffFFC107)),
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              color1.withValues(alpha: 1),
              color2.withValues(alpha: 0.85),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: null,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 10, bottom: 0, left: 15, right: 0),
              child: Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextMonserats(
                        smallText,
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      Transform.translate(
                        offset: const Offset(0, -8),
                        child: TextMonserats(bigText,
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            maxLine: 2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(-15, -10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image(
                    image: image,
                    width: 68,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
