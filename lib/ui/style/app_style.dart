import 'package:flutter/material.dart';
import 'package:weather_app/ui/style/app_colors.dart';

abstract class AppStyle {
  static TextStyle fontStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
    shadows: [
      Shadow(
        color: AppColors.black,
        offset: const Offset(4, 4),
        blurRadius: 20,
      ),
    ],
  );
}
