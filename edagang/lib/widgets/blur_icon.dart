import 'dart:ui';
import 'package:flutter/material.dart';

class BlurIcon extends StatelessWidget {
  final double width;
  final double height;
  final EdgeInsets padding;
  final Icon icon;

  BlurIcon({this.width = 36, this.height = 36, this.icon, this.padding});

  @override
  Widget build(BuildContext context) {
    //final themeData = CartsiniThemeProvider.get();
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
        child: Padding(
          padding: padding == null ? EdgeInsets.only(left: 10, right: 10) : padding,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black38,
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
