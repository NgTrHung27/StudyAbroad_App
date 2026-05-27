import 'package:flutter/material.dart';
import 'package:study_abroad_cemc_mobile/components/style/montserrat.dart';

class EmptyDataWidget extends StatelessWidget {
  final String text;
  final IconData icon;
  final double? iconSize;
  final double? textSize;
  final Color? color;

  const EmptyDataWidget({
    super.key,
    this.text = 'Không có dữ liệu',
    this.icon = Icons.article_outlined,
    this.iconSize,
    this.textSize,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final displayColor = color ?? Colors.grey.shade400;
    final displayTextColor = color ?? Colors.grey.shade600;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: iconSize ?? screenWidth * 0.2,
            color: displayColor,
          ),
          SizedBox(height: screenHeight * 0.02),
          TextMonserats(
            text,
            fontSize: textSize ?? screenWidth * 0.04,
            color: displayTextColor,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
