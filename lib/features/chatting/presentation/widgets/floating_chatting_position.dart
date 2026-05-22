import 'package:flutter/material.dart';

class CustomFABLocation extends FloatingActionButtonLocation {
  final FloatingActionButtonLocation baseLocation;
  final double offsetY;

  CustomFABLocation(this.baseLocation, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final Offset baseOffset = baseLocation.getOffset(scaffoldGeometry);
    return Offset(baseOffset.dx, baseOffset.dy - offsetY);
  }
}