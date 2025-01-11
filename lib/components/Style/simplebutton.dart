import 'package:flutter/material.dart';
import 'package:kltn_mobile/components/constant/color_constant.dart';

class SimpleButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final Widget child;

  const SimpleButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 45,
      width: screenWidth * 0.9,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor ?? AppColor.redButton),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: borderColor ?? Colors.transparent),
            ),
          ),
          overlayColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.pressed)
                ? (backgroundColor ?? AppColor.redButton).withValues(alpha: 0.2)
                : (backgroundColor ?? AppColor.redButton).withValues(alpha: 0.1),
          ),
          shadowColor: WidgetStateProperty.resolveWith<Color>((states) =>
              states.contains(WidgetState.pressed) ? Colors.black.withValues(alpha: 0.3) : Colors.transparent),
          elevation:
              WidgetStateProperty.resolveWith<double>((states) => states.contains(WidgetState.pressed) ? 5.0 : 0.0),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
